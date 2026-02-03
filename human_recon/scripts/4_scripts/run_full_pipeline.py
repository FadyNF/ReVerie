import os
import re
import shutil
import subprocess
import argparse
from pathlib import Path

# ----------------------------
# CONFIG (edit if needed)
# ----------------------------
PROJECT_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_INPUT = PROJECT_ROOT / "0_data" / "personal"
STAGE_DIR = PROJECT_ROOT / "1_stage"
FINAL_DIR = PROJECT_ROOT / "2_final"
ICON_DIR = Path("/mnt/sdb/CSC/Full_HumanRecon_Pipeline/3_models/ICON")
DECA_DIR = Path("/mnt/sdb/CSC/Full_HumanRecon_Pipeline/3_models/DECA")


# Optional: clear staging/final before running
CLEAR_STAGE = False
CLEAR_FINAL = False

# ----------------------------
# HELPERS
# ----------------------------
def next_run_dir(final_dir: Path) -> Path:
    final_dir.mkdir(parents=True, exist_ok=True)
    runs = []
    for d in final_dir.iterdir():
        if d.is_dir():
            m = re.match(r"run_(\d+)$", d.name)
            if m:
                runs.append(int(m.group(1)))
    next_id = max(runs, default=0) + 1
    return final_dir / f"run_{next_id}"

def copy_tree(src: Path, dst: Path):
    if dst.exists():
        shutil.rmtree(dst)
    shutil.copytree(src, dst)

def copy_final_outputs(src_final: Path, dst_final: Path):
    dst_final.mkdir(parents=True, exist_ok=True)
    for item in src_final.iterdir():
        # Skip run folders to avoid recursion
        if item.is_dir() and item.name.startswith("run_"):
            continue
        target = dst_final / item.name
        if item.is_dir():
            if target.exists():
                shutil.rmtree(target)
            shutil.copytree(item, target)
        else:
            shutil.copy2(item, target)

def run_in_env(env_name: str, command: str, cwd: Path = None):
    """
    Run a command inside a micromamba environment.
    If cwd is given, run from that folder.
    """
    full_cmd = f"micromamba activate {env_name} && {command}"
    subprocess.run(["bash", "-lc", full_cmd], check=True, cwd=cwd)

# ----------------------------
# MAIN
# ----------------------------
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--input_dir",
        type=str,
        default=str(DEFAULT_INPUT),
        help="Path to input folder (default: 0_data/personal)"
    )
    args = parser.parse_args()

    input_source = Path(args.input_dir).resolve()

    # 1) Create a new run folder under 2_final/run_X
    run_dir = next_run_dir(FINAL_DIR)
    run_inputs = run_dir / "inputs"
    run_stage = run_dir / "1_stage"
    run_final = run_dir / "2_final"

    print(f"✅ New run folder: {run_dir}")

    # 2) Prepare run folders
    run_inputs.mkdir(parents=True, exist_ok=True)
    run_stage.mkdir(parents=True, exist_ok=True)
    run_final.mkdir(parents=True, exist_ok=True)

    # 3) Copy inputs snapshot
    if not input_source.exists():
        raise FileNotFoundError(f"Missing input folder: {input_source}")
    copy_tree(input_source, run_inputs)
    print("✅ Inputs copied")

    # 4) Optional cleanup
    if CLEAR_STAGE and STAGE_DIR.exists():
        shutil.rmtree(STAGE_DIR)
        STAGE_DIR.mkdir(parents=True, exist_ok=True)
    if CLEAR_FINAL and FINAL_DIR.exists():
        # Only clear non-run outputs
        for item in FINAL_DIR.iterdir():
            if item.is_dir() and item.name.startswith("run_"):
                continue
            if item.is_dir():
                shutil.rmtree(item)
            else:
                item.unlink()

    # 5) Run ICON in icon_env
    icon_cmd = (
        "python -m apps.infer "
        "-cfg ./configs/icon-filter.yaml "
        "-gpu 0 "
        f"-in_dir {input_source} "
        f"-out_dir {STAGE_DIR / 'icon'} "
        "-export_video "
        "-loop_smpl 100 "
        "-loop_cloth 200 "
        "-hps_type pymaf"
    )
    print("▶ Running ICON (icon_env)...")
    run_in_env("icon_env", icon_cmd, cwd=ICON_DIR)

    # 6) Run DECA in deca_env
    deca_cmd = (
        "python demos/demo_reconstruct.py "
        f"-i {input_source} "
        f"-s {STAGE_DIR / 'deca'} "
        "--rasterizer_type pytorch3d "
        "--saveDepth True "
        "--saveObj True"
    )
    print("▶ Running DECA (deca_env)...")
    run_in_env("deca_env", deca_cmd, cwd=DECA_DIR)

    # 7) Run full batch merge/texture in icon_env
    print("▶ Running run_full_batch.py (icon_env)...")
    run_in_env("icon_env", f"python {PROJECT_ROOT / '4_scripts' /'run_full_batch.py'}")

    # 8) Copy staging + final outputs into run folder
    copy_tree(STAGE_DIR, run_stage)
    copy_final_outputs(FINAL_DIR, run_final)

    print(f"✅ Run saved to: {run_dir}")

if __name__ == "__main__":
    main()
