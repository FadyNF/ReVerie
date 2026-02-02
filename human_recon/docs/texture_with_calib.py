import os
import argparse
import numpy as np
from PIL import Image
import trimesh
import torch
import torch.nn.functional as F
from pytorch3d.renderer import FoVOrthographicCameras

def parse_args():
    parser = argparse.ArgumentParser(description="Fast texture projection using ICON camera params")
    parser.add_argument("--mesh", required=True, help="Path to recon mesh (.obj)")
    parser.add_argument("--image", required=True, help="Path to ICON processed input image (.png)")
    parser.add_argument("--cam", required=True, help="Path to camera params (.npz)")
    parser.add_argument("--out_dir", required=True, help="Output directory for GLB")
    parser.add_argument("--out_name", default="textured_fast.glb", help="Output GLB filename")
    parser.add_argument("--image_size", type=int, default=512, help="Input image size (default: 512)")
    return parser.parse_args()

def main():
    args = parse_args()

    mesh_path = os.path.abspath(args.mesh)
    img_path = os.path.abspath(args.image)
    cam_path = os.path.abspath(args.cam)
    out_dir = os.path.abspath(args.out_dir)
    out_glb = os.path.join(out_dir, args.out_name)

    os.makedirs(out_dir, exist_ok=True)

    print("[1/5] Load mesh + image + camera")
    mesh = trimesh.load(mesh_path, process=False)

    img = Image.open(img_path).convert("RGB").resize((args.image_size, args.image_size))
    img_np = np.array(img)

    img_t = torch.from_numpy(img_np).float() / 255.0
    img_t = (img_t * 2.0) - 1.0
    img_t = img_t.permute(2, 0, 1).unsqueeze(0)

    cam = np.load(cam_path)

    camera = FoVOrthographicCameras(
        R=torch.from_numpy(cam["R"]).float(),
        T=torch.from_numpy(cam["T"]).float(),
        znear=float(cam["znear"]),
        zfar=float(cam["zfar"]),
        max_x=float(cam["max_x"]),
        min_x=float(cam["min_x"]),
        max_y=float(cam["max_y"]),
        min_y=float(cam["min_y"]),
        scale_xyz=torch.from_numpy(cam["scale_xyz"]).float(),
    )

    print("[2/5] Prepare vertices (ICON axis flip)")
    verts = torch.from_numpy(mesh.vertices).float()
    verts = verts * torch.tensor([1.0, -1.0, -1.0])
    verts = verts.unsqueeze(0)

    print("[3/5] Project to image")
    proj = camera.transform_points_screen(verts, image_size=(args.image_size, args.image_size))
    xy = proj[0, :, :2]

    xy[:, 0] = (xy[:, 0] / (args.image_size / 2)) - 1.0
    xy[:, 1] = 1.0 - (xy[:, 1] / (args.image_size / 2))

    uv = xy.unsqueeze(0).unsqueeze(2)
    colors = F.grid_sample(img_t, uv, align_corners=True)[0, :, :, 0].permute(1, 0)
    colors = ((colors + 1.0) * 0.5 * 255.0).clamp(0, 255)

    print("[4/5] Fast backface culling")
    v = verts[0]
    faces = torch.from_numpy(mesh.faces).long()
    v0, v1, v2 = v[faces[:, 0]], v[faces[:, 1]], v[faces[:, 2]]
    face_normals = torch.cross(v1 - v0, v2 - v0)
    face_normals = F.normalize(face_normals, dim=1)

    forward = torch.tensor([0.0, 0.0, 1.0])
    front_mask = (face_normals @ forward) < 0

    vertex_mask = torch.zeros((v.shape[0],), dtype=torch.bool)
    vertex_mask[faces[front_mask].flatten()] = True

    gray = torch.tensor([180.0, 180.0, 180.0])
    colors[~vertex_mask] = gray

    alpha = torch.full((colors.shape[0], 1), 255.0)
    colors = torch.cat([colors, alpha], dim=1)
    colors = colors.cpu().numpy().astype(np.uint8)

    print("[5/5] Export")
    mesh.visual.vertex_colors = colors
    mesh.export(out_glb)

    print("✅ Saved:", out_glb)

if __name__ == "__main__":
    main()
