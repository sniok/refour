type t = {
  projectionMatrix: Matrix4.t,
  viewMatrix: Matrix4.t,
  projectionViewMatrix: Matrix4.t,
  frustum: Frustum.t,
  fov: float,
  aspect: float,
  near: float,
  far: float,
}

let make = (): t => {
  projectionMatrix: Matrix4.make(),
  viewMatrix: Matrix4.make(),
  projectionViewMatrix: Matrix4.make(),
  frustum: Frustum.make(),
  fov: 90.0,
  aspect: 1.0,
  near: 0.1,
  far: 1000.0,
}

let updateMatrix = (this: t, objectMatrix: Matrix4.t) => {
  open Matrix4
  this.viewMatrix->copy(objectMatrix)->invert->ignore
  this.projectionMatrix->perspective(this.fov, this.aspect, this.near, this.far)->ignore
}
