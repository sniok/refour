@@warning("-8")

type t = {
  mutable x: float,
  mutable y: float,
  mutable z: float,
}

let make = (x, y, z): t => {x, y, z}

let set = (v: t, x, y, z) => {
  v.x = x
  v.y = y
  v.z = z
  v
}

let multiply = (me: t, v: t) => {
  me.x = me.x *. v.x
  me.y = me.y *. v.y
  me.z = me.z *. v.z
  me
}

let multiplyScalar = (me: t, scalar) => {
  me.x = me.x *. scalar
  me.y = me.y *. scalar
  me.z = me.z *. scalar
  me
}

let add = (me: t, v: t) => {
  me.x = me.x +. v.x
  me.y = me.y +. v.y
  me.z = me.z +. v.z
  me
}

let addScalar = (me, scalar) => {
  me.x = me.x +. scalar
  me.y = me.y +. scalar
  me.z = me.z +. scalar
  me
}

let subtract = (me: t, v: t) => {
  me.x = me.x -. v.x
  me.y = me.y -. v.y
  me.z = me.z -. v.z
  me
}

let subtractScalar = (me: t, scalar) => {
  me.x = me.x -. scalar
  me.y = me.y -. scalar
  me.z = me.z -. scalar
  me
}

let divide = (me: t, v: t) => {
  me.x = me.x /. v.x
  me.y = me.y /. v.y
  me.z = me.z /. v.z
  me
}

let divideScalar = (me: t, scalar) => {
  me.x = me.x /. scalar
  me.y = me.y /. scalar
  me.z = me.z /. scalar
  me
}

let clone = a => make(a.x, a.y, a.z)

module Ops = {
  // let \"/" = (a, b) => a->clone->subtract(b)
  // let \"/." = subtractScalar
  // let \"*" = multiply
  // let \"*." = multiplyScalar
  // let \"+" = (a, b) => a->clone->add(b)
  // let \"+." = addScalar
  // let \"-" = subtract
  // let \"-." = subtractScalar
}

let copy = (me, v) => {
  me.x = v.x
  me.y = v.y
  me.z = v.z
  me
}

let distanceTo = (me: t, to: t) => Math.hypotMany([me.x -. to.x, me.y -. to.y, me.z -. to.z])

let dot = (me: t, v: t) => me.x *. v.x +. me.y *. v.y +. me.z *. v.z

let cross = (me: t, v: t) => {
  me.x = me.y *. v.z -. me.z *. v.y
  me.y = me.z *. v.x -. me.x *. v.z
  me.z = me.x *. v.y -. me.y *. v.x
  me
}

let lerp = (me: t, v: t, t: float) => {
  me.x = v.x -. me.x
  me.y = v.y -. me.y
  me.z = v.z -. me.z

  me->multiplyScalar(t)
}

// let applyQuaternion = (me: t) => ()

let applyMatrix4 = (this: t, m: Matrix4.t) => {
  let [m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33] = m

  this.x = m00 *. this.x +. m10 *. this.y +. m20 *. this.z +. m30
  this.y = m01 *. this.x +. m11 *. this.y +. m21 *. this.z +. m31
  this.z = m02 *. this.x +. m12 *. this.y +. m22 *. this.z +. m32

  this->divideScalar(m03 *. this.x +. m13 *. this.y +. m23 *. this.z +. m33)
}

let invert = (me: t) => {
  me->multiplyScalar(-1.0)
}

let getLength = (me: t) => Math.hypotMany([me.x, me.y, me.z])

let normalize = (me: t) => {
  me->divideScalar(me->getLength)
}
