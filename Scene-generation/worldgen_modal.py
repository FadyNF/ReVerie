# worldgen_modal.py
import os
from pathlib import Path
import modal

APP_NAME = "worldgen-a100"

hf_cache = modal.Volume.from_name("worldgen-hf-cache", create_if_missing=True)
out_vol = modal.Volume.from_name("worldgen-out", create_if_missing=True)
hf_secret = modal.Secret.from_name("huggingface-token")

image = (
    modal.Image.debian_slim(python_version="3.11")
    .apt_install(
        "git",
        "git-lfs",
        "build-essential",
        "ninja-build",
        "cmake",
        "pkg-config",
        "libgl1",
        "libglib2.0-0",
    )
    .run_commands(
        "git lfs install",
        "rm -rf /root/WorldGen",
        "git clone https://github.com/ZiYang-xie/WorldGen.git /root/WorldGen",
        "cd /root/WorldGen && "
        "git config -f .gitmodules submodule.submodules/ml-sharp.url https://github.com/apple/ml-sharp.git && "
        "git submodule sync --recursive && "
        "git submodule update --init --recursive",
    )
    .pip_install("pip>=24.2", "setuptools", "wheel")
    .pip_install(
        "torch==2.5.1",
        "torchvision==0.20.1",
        "torchaudio==2.5.1",
        extra_index_url="https://download.pytorch.org/whl/cu121",
    )
    .pip_install(
        "opencv-python-headless",
        "rich",
        "websockets",
        "timm",
        "diffusers",
        "transformers",
        "py360convert",
        "einops",
        "pillow",
        "scikit-image",
        "sentencepiece",
        "peft",
        "open3d",
        "trimesh",
        "plyfile",
        "msgspec",
        "nodeenv",
        "tyro",
        "yourdfpy",
        "huggingface_hub",
        "pillow-heif",
        "wandb",
        "fvcore",
        "iopath",
        "numpy",
    )
    .pip_install(
        "git+https://github.com/lpiccinelli-eth/UniK3D.git",
        "git+https://github.com/ZiYang-xie/viser.git",
    )
    .run_commands(
        "pip install -e /root/WorldGen --no-deps",
        "pip install -e /root/WorldGen/submodules/ml-sharp --no-deps",
        "python -c \"import site, pathlib; "
        "src='/root/WorldGen/submodules/ml-sharp/src'; "
        "sp=pathlib.Path(site.getsitepackages()[0]); "
        "(sp/'ml_sharp_src.pth').write_text(src+'\\\\n'); "
        "print('Added to site-packages:', src)\"",
    )
    .run_commands(
        "pip uninstall -y nunchaku || true",
        "pip install --no-deps "
        "https://huggingface.co/mit-han-lab/nunchaku/resolve/main/"
        "nunchaku-0.3.1%2Btorch2.5-cp311-cp311-linux_x86_64.whl",
        "python -c \"import nunchaku; print('nunchaku OK:', nunchaku.__file__)\"",
    )
    .run_commands(
        "python -m pip install -v --no-build-isolation "
        "git+https://github.com/facebookresearch/pytorch3d.git || true"
    )
)

app = modal.App(APP_NAME)


@app.function(
    gpu="A100-40GB",
    image=image,
    timeout=60 * 60,
    volumes={"/cache": hf_cache, "/out": out_vol},
    secrets=[hf_secret],
)
def run_worldgen(
    image_bytes: bytes,
    out_name: str,
    prompt: str = "",
    max_side: int = 2048,
) -> str:
    os.environ["PYTORCH_CUDA_ALLOC_CONF"] = "expandable_segments:True"

    os.environ["HF_HOME"] = "/cache/hf"
    os.environ["HF_HUB_CACHE"] = "/cache/hf/hub"
    os.environ["DIFFUSERS_CACHE"] = "/cache/hf/diffusers"
    os.environ["HF_HUB_DISABLE_TELEMETRY"] = "1"
    os.environ["HF_HUB_ENABLE_HF_TRANSFER"] = "0"

    os.environ["HF_TOKEN"] = os.environ["HUGGINGFACE_TOKEN"]
    os.environ["HUGGINGFACE_HUB_TOKEN"] = os.environ["HUGGINGFACE_TOKEN"]

    import io
    import torch
    from PIL import Image as PILImage
    from worldgen import WorldGen

    device = "cuda" if torch.cuda.is_available() else "cpu"

    img = PILImage.open(io.BytesIO(image_bytes)).convert("RGB")

    # Resize (keeps detail if input is already <= max_side)
    w, h = img.size
    scale = max_side / max(w, h)
    if scale < 1.0:
        img = img.resize((int(w * scale), int(h * scale)), PILImage.LANCZOS)

    wg = WorldGen(mode="i2s", device=device, low_vram=False)

    with torch.inference_mode():
        splat = wg.generate_world(image=img, prompt=prompt)

    out_path = f"/out/{out_name}"
    splat.save(out_path)

    out_vol.commit()
    return out_name


def _iter_images(path: Path):
    exts = {".jpg", ".jpeg", ".png", ".webp", ".bmp", ".tif", ".tiff", ".heic", ".heif"}
    if path.is_file():
        if path.suffix.lower() in exts:
            yield path
        return
    for p in sorted(path.glob("*")):
        if p.is_file() and p.suffix.lower() in exts:
            yield p


@app.local_entrypoint()
def main():
    input_path = os.environ.get("WG_INPUT", "").strip()
    if not input_path:
        raise SystemExit("WG_INPUT is empty. Example: $env:WG_INPUT='images dataset/people2.jpg'")

    max_side = int(os.environ.get("WG_MAX_SIDE", "2048").strip())
    prompt = os.environ.get("WG_PROMPT", "")

    inp = Path(input_path)
    if not inp.exists():
        raise SystemExit(f"Input not found: {inp.resolve()}")

    imgs = list(_iter_images(inp))
    if not imgs:
        raise SystemExit(f"No images found in: {inp.resolve()}")

    print(f"WG_INPUT={inp.resolve()}")
    print(f"Submitting {len(imgs)} job(s) to Modal on GPU...")

    for p in imgs:
        out_name = f"worldgen_splat_{p.stem}.ply"
        run_worldgen.remote(
            p.read_bytes(),
            out_name=out_name,
            prompt=prompt,
            max_side=max_side,
        )
        print(f"  -> queued: {p.name}  =>  {out_name}")
