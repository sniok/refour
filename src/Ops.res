let compose = (
  this: Matrix4.t,
  position: Vector3.t,
  quaternion: Quaternion.t,
  scale: Vector3.t,
): Matrix4.t => {
  open Quaternion

  let xx = 2.0 *. quaternion.x *. quaternion.x
  let xy = 2.0 *. quaternion.y *. quaternion.x
  let xz = 2.0 *. quaternion.z *. quaternion.x
  let yy = 2.0 *. quaternion.y *. quaternion.y
  let yz = 2.0 *. quaternion.z *. quaternion.y
  let zz = 2.0 *. quaternion.z *. quaternion.z
  let wx = 2.0 *. quaternion.x *. quaternion.w
  let wy = 2.0 *. quaternion.y *. quaternion.w
  let wz = 2.0 *. quaternion.z *. quaternion.w

  this->Matrix4.set([
    (1.0 -. (yy +. zz)) *. scale.x,
    (xy +. wz) *. scale.x,
    (xz -. wy) *. scale.x,
    0.0,
    (xy -. wz) *. scale.y,
    (1.0 -. (xx +. zz)) *. scale.y,
    (yz +. wx) *. scale.y,
    0.0,
    (xz +. wy) *. scale.z,
    (yz -. wx) *. scale.z,
    (1.0 -. (xx +. yy)) *. scale.z,
    0.0,
    position.x,
    position.y,
    position.z,
    1.0,
  ])
}
