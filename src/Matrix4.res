@@warning("-8")

type t = array<float>

let make = (): t => [1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0]

let set = (this: t, arr: array<float>): t => {
  for i in 0 to 15 {
    Array.setUnsafe(this, i, Array.getUnsafe(arr, i))
  }
  this
}

let copy = (this: t, m: t): t => this->set(m)

let identity = this =>
  this->set([1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0])

let multiply = (this: t, t: t): t => {
  let [m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33] = this
  let [t00, t01, t02, t03, t10, t11, t12, t13, t20, t21, t22, t23, t30, t31, t32, t33] = t

  this->set([
    m00 *. t00 +. m10 *. t01 +. m20 *. t02 +. m30 *. t03,
    m01 *. t00 +. m11 *. t01 +. m21 *. t02 +. m31 *. t03,
    m02 *. t00 +. m12 *. t01 +. m22 *. t02 +. m32 *. t03,
    m03 *. t00 +. m13 *. t01 +. m23 *. t02 +. m33 *. t03,
    m00 *. t10 +. m10 *. t11 +. m20 *. t12 +. m30 *. t13,
    m01 *. t10 +. m11 *. t11 +. m21 *. t12 +. m31 *. t13,
    m02 *. t10 +. m12 *. t11 +. m22 *. t12 +. m32 *. t13,
    m03 *. t10 +. m13 *. t11 +. m23 *. t12 +. m33 *. t13,
    m00 *. t20 +. m10 *. t21 +. m20 *. t22 +. m30 *. t23,
    m01 *. t20 +. m11 *. t21 +. m21 *. t22 +. m31 *. t23,
    m02 *. t20 +. m12 *. t21 +. m22 *. t22 +. m32 *. t23,
    m03 *. t20 +. m13 *. t21 +. m23 *. t22 +. m33 *. t23,
    m00 *. t30 +. m10 *. t31 +. m20 *. t32 +. m30 *. t33,
    m01 *. t30 +. m11 *. t31 +. m21 *. t32 +. m31 *. t33,
    m02 *. t30 +. m12 *. t31 +. m22 *. t32 +. m32 *. t33,
    m03 *. t30 +. m13 *. t31 +. m23 *. t32 +. m33 *. t33,
  ])
}

let multiplyScalar = (this: t, scalar: float) => {
  for i in 0 to 15 {
    Array.setUnsafe(this, i, Array.getUnsafe(this, i) *. scalar)
  }
  this
}

let determinant = (this: t) => {
  let [m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33] = this

  let b0 = m00 *. m11 -. m01 *. m10
  let b1 = m00 *. m12 -. m02 *. m10
  let b2 = m01 *. m12 -. m02 *. m11
  let b3 = m20 *. m31 -. m21 *. m30
  let b4 = m20 *. m32 -. m22 *. m30
  let b5 = m21 *. m32 -. m22 *. m31
  let b6 = m00 *. b5 -. m01 *. b4 +. m02 *. b3
  let b7 = m10 *. b5 -. m11 *. b4 +. m12 *. b3
  let b8 = m20 *. b2 -. m21 *. b1 +. m22 *. b0
  let b9 = m30 *. b2 -. m31 *. b1 +. m32 *. b0

  m13 *. b6 -. m03 *. b7 +. m33 *. b8 -. m23 *. b9
}

let transpose = (this: t) => {
  let [m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33] = this
  this->set([m00, m10, m20, m30, m01, m11, m21, m31, m02, m12, m22, m32, m03, m13, m23, m33])
}

let invert = (this: t) => {
  let [m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33] = this

  let b00 = m00 *. m11 -. m01 *. m10
  let b01 = m00 *. m12 -. m02 *. m10
  let b02 = m00 *. m13 -. m03 *. m10
  let b03 = m01 *. m12 -. m02 *. m11
  let b04 = m01 *. m13 -. m03 *. m11
  let b05 = m02 *. m13 -. m03 *. m12
  let b06 = m20 *. m31 -. m21 *. m30
  let b07 = m20 *. m32 -. m22 *. m30
  let b08 = m20 *. m33 -. m23 *. m30
  let b09 = m21 *. m32 -. m22 *. m31
  let b10 = m21 *. m33 -. m23 *. m31
  let b11 = m22 *. m33 -. m23 *. m32

  //. Make sure we're not dividing by zero
  let det = this->determinant

  if det != 0.0 {
    this
    ->set([
      m11 *. b11 -. m12 *. b10 +. m13 *. b09,
      m02 *. b10 -. m01 *. b11 -. m03 *. b09,
      m31 *. b05 -. m32 *. b04 +. m33 *. b03,
      m22 *. b04 -. m21 *. b05 -. m23 *. b03,
      m12 *. b08 -. m10 *. b11 -. m13 *. b07,
      m00 *. b11 -. m02 *. b08 +. m03 *. b07,
      m32 *. b02 -. m30 *. b05 -. m33 *. b01,
      m20 *. b05 -. m22 *. b02 +. m23 *. b01,
      m10 *. b10 -. m11 *. b08 +. m13 *. b06,
      m01 *. b08 -. m00 *. b10 -. m03 *. b06,
      m30 *. b04 -. m31 *. b02 +. m33 *. b00,
      m21 *. b02 -. m20 *. b04 -. m23 *. b00,
      m11 *. b07 -. m10 *. b09 -. m12 *. b06,
      m00 *. b09 -. m01 *. b07 +. m02 *. b06,
      m31 *. b01 -. m30 *. b03 -. m32 *. b00,
      m20 *. b03 -. m21 *. b01 +. m22 *. b00,
    ])
    ->multiplyScalar(1.0 /. det)
  } else {
    this
  }
}

let perspective = (this: t, fov: float, aspect: float, near: float, far: float) => {
  let fovRad = fov *. (Utils.pi /. 180.0)
  let f = 1.0 /. tan(fovRad /. 2.0)
  let depth = 1.0 /. (near -. far)

  this->set([
    f /. aspect,
    0.0,
    0.0,
    0.0,
    0.0,
    f,
    0.0,
    0.0,
    0.0,
    0.0,
    (far +. near) *. depth,
    -1.0,
    0.0,
    0.0,
    2.0 *. far *. near *. depth,
    0.0,
  ])
}

let orthogonal = (
  this: t,
  left: float,
  right: float,
  bottom: float,
  top: float,
  near: float,
  far: float,
) => {
  let horizontal = 1.0 /. (left -. right)
  let vertical = 1.0 /. (bottom -. top)
  let depth = 1.0 /. (near -. far)

  this->set([
    -2.0 *. horizontal,
    0.0,
    0.0,
    0.0,
    0.0,
    -2.0 *. vertical,
    0.0,
    0.0,
    0.0,
    0.0,
    2.0 *. depth,
    0.0,
    (left +. right) *. horizontal,
    (top +. bottom) *. vertical,
    (far +. near) *. depth,
    1.0,
  ])
}

let normal = (this: t, m: t) => {
  let [m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33] = m

  let b00 = m00 *. m11 -. m01 *. m10
  let b01 = m00 *. m12 -. m02 *. m10
  let b02 = m00 *. m13 -. m03 *. m10
  let b03 = m01 *. m12 -. m02 *. m11
  let b04 = m01 *. m13 -. m03 *. m11
  let b05 = m02 *. m13 -. m03 *. m12
  let b06 = m20 *. m31 -. m21 *. m30
  let b07 = m20 *. m32 -. m22 *. m30
  let b08 = m20 *. m33 -. m23 *. m30
  let b09 = m21 *. m32 -. m22 *. m31
  let b10 = m21 *. m33 -. m23 *. m31
  let b11 = m22 *. m33 -. m23 *. m32

  //. Make sure we're not dividing by zero
  let det = m->determinant

  if det != 0.0 {
    this
    ->set([
      m11 *. b11 -. m12 *. b10 +. m13 *. b09,
      m02 *. b10 -. m01 *. b11 -. m03 *. b09,
      m31 *. b05 -. m32 *. b04 +. m33 *. b03,
      0.0,
      m12 *. b08 -. m10 *. b11 -. m13 *. b07,
      m00 *. b11 -. m02 *. b08 +. m03 *. b07,
      m32 *. b02 -. m30 *. b05 -. m33 *. b01,
      0.0,
      m10 *. b10 -. m11 *. b08 +. m13 *. b06,
      m01 *. b08 -. m00 *. b10 -. m03 *. b06,
      m30 *. b04 -. m31 *. b02 +. m33 *. b00,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
    ])
    ->multiplyScalar(1.0 /. det)
  } else {
    this
  }
}
