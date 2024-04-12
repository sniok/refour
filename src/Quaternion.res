type t = {mutable x: float, mutable y: float, mutable z: float, mutable w: float}

let make = (~x=0.0, ~y=0.0, ~z=0.0, ~w=1.0) => {x, y, z, w}

let set = (this, x, y, z, w) => {
  this.x = x
  this.y = y
  this.z = z
  this.w = w
  this
}

let copy = (this: t, q: t) => this->set(q.x, q.y, q.z, q.w)

let identity = (this: t) => this->set(0.0, 0.0, 0.0, 1.0)

let addScalar = (this: t, scalar: float) => {
  this.x = this.x +. scalar
  this.y = this.y +. scalar
  this.z = this.z +. scalar
  this.w = this.w +. scalar
  this
}

// let add = (this: t, q: t) => {
//   this.x = this.x +. q.x
//   this.y = this.y +. q.y
//   this.z = this.z +. q.z
//   this.w = this.w +. q.w
//   this
// }

@unboxed
type scalarOrQuat = Scalar(float) | Quat(t)

type op = Add | Sub | Div | Mutl

@inline
let add = (a, b) => a +. b

@inline
let opFn = op => @inline
(a, b) =>
  switch op {
  | Add => a +. b
  | Sub => a -. b
  | Div => a /. b
  | Mutl => a *. b
  }
@inline
let forEachComp = (op: op) => @inline
(this: t, that: scalarOrQuat) => {
  let op = opFn(op)
  switch that {
  | Scalar(s) => {
      this.x = op(this.x, s)
      this.y = op(this.y, s)
      this.z = op(this.z, s)
      this.w = op(this.w, s)
      this
    }
  | Quat(q) => {
      this.x = op(this.x, q.x)
      this.y = op(this.y, q.y)
      this.z = op(this.z, q.z)
      this.w = op(this.w, q.w)
      this
    }
  }
}

let addValue = (this: t, v: scalarOrQuat) => {
  forEachComp(Add)(this, v)->ignore

  this
}

let fromEuler = (t: t, x, y, z) => {
  open! Math

  let sx = sin(x)
  let cx = cos(x)
  let sy = sin(y)
  let cy = cos(y)
  let sz = sin(z)
  let cz = cos(z)

  t->set(
    sx *. cy *. cz +. cx *. sy *. sz,
    cx *. sy *. cz -. sx *. cy *. sz,
    cx *. cy *. sz +. sx *. sy *. cz,
    cx *. cy *. cz -. sx *. sy *. sz,
  )
}

let eps = 0.00001

let lookAt = (this: t, eye, target, up) => {
  let z = eye->Vector3.clone->Vector3.subtract(target)

  if z->Vector3.getLength === 0.0 {
    z.z = 1.0
  } else {
    z->Vector3.normalize->ignore
  }

  let x = up->Vector3.clone->Vector3.cross(z)

  if x->Vector3.getLength === 0.0 {
    let pup = up->Vector3.clone

    if pup.z > 0.0 {
      pup.x = pup.x +. eps
    } else if pup.y > 0.0 {
      pup.z = pup.z +. eps
    } else {
      pup.y = pup.y +. eps
    }

    x->Vector3.cross(pup)->ignore
  }
  x->Vector3.normalize->ignore

  let y = z->Vector3.clone->Vector3.cross(x)

  let sm11 = x.x
  let sm12 = x.y
  let sm13 = x.z
  let sm21 = y.x
  let sm22 = y.y
  let sm23 = y.z
  let sm31 = z.x
  let sm32 = z.y
  let sm33 = z.z

  let trace = sm11 +. sm22 +. sm33

  if trace > 0.0 {
    let s = sqrt(trace +. 1.0) *. 2.0
    this->set((sm23 -. sm32) /. s, (sm31 -. sm13) /. s, (sm12 -. sm21) /. s, s /. 4.0)
  } else if sm11 > sm22 && sm11 > sm33 {
    let s = sqrt(1.0 +. sm11 -. sm22 -. sm33) *. 2.0
    this->set(s /. 4.0, (sm12 +. sm21) /. s, (sm31 +. sm13) /. s, (sm23 -. sm32) /. s)
  } else if sm22 > sm33 {
    let s = sqrt(1.0 +. sm22 -. sm11 -. sm33) *. 2.0
    this->set((sm12 +. sm21) /. s, s /. 4.0, (sm23 +. sm32) /. s, (sm31 -. sm13) /. s)
  } else {
    let s = sqrt(1.0 +. sm33 -. sm11 -. sm22) *. 2.0
    this->set((sm31 +. sm13) /. s, (sm23 +. sm32) /. s, s /. 4.0, (sm12 -. sm21) /. s)
  }
}

// let subValue = (this: t, v: scalarOrQuat) => {
//   for i in 0 to 3 {
//     Array.setUnsafe(
//       this,
//       i,
//       Array.getUnsafe(this, i) -.
//       switch v {
//       | #Scalar(v) => v
//       | #Quat(q) => Array.getUnsafe(q, i)
//       },
//     )
//   }
//   this
// }

// let multiplyScalar = (this: t, v: float) => {
//   for i in 0 to 3 {
//     unsafe_mult(this, i, v)
//   }
//   this
// }

// let multiply = (this: t, t: t) => {
//   let [qx, qy, qz, qw] = this
//   let [tx, ty, tz, tw] = t

//   this->set(
//     qx *. tw +. qw *. tx +. qy *. tz -. qz *. ty,
//     qy *. tw +. qw *. ty +. qz *. tx -. qx *. tz,
//     qz *. tw +. qw *. tz +. qx *. ty -. qy *. tx,
//     qw *. tw -. qx *. tx -. qy *. ty -. qz *. tz,
//   )
// }

// let divide = (this: t, t: t) => {
//   for i in 0 to 3 {
//     unsafe_div(this, i, Array.getUnsafe(t, i))
//   }
//   this
// }

// let divideScalar = (this: t, v: float) => {
//   for i in 0 to 3 {
//     unsafe_div(this, i, v)
//   }
//   this
// }

// let invert = (this: t) => this->multiplyScalar(-1.0)

// let getLength = (this: t) => Utils.hypot(this)

// let normalize = (this: t) => this->divideScalar(this->getLength)

// let dot = (this: t, q: t) => this.x *. q.x +. this.y *. q.y +. this.z *. q.z +. this.w *. q.w

// let fromEuler = (this: t, x: float, y: float, z: float) => {
//   let sx = sin(x)
//   let cx = cos(x)
//   let sy = sin(y)
//   let cy = cos(y)
//   let sz = sin(z)
//   let cz = cos(z)

//   this->set(
//     sx *. cy *. cz +. cx *. sy *. sz,
//     cx *. sy *. cz -. sx *. cy *. sz,
//     cx *. cy *. sz +. sx *. sy *. cz,
//     cx *. cy *. cz -. sx *. sy *. sz,
//   )
// }

// let slerp = (this: t, q: t, t: float) => {
//   let cosom = ref(this->dot(q))
//   if cosom.contents < 0.0 {
//     cosom := cosom.contents *. -1.0
//   }

//   let scale0 = ref(1.0 -. t)
//   let scale1 = ref(t)

//   if 1.0 -. cosom.contents > Utils.epsilon {
//     let omega = acos(cosom.contents)
//     let sinom = sin(omega)

//     scale0 := sin((1.0 -. t) *. omega) /. sinom
//     scale1 := sin(t *. omega) /. sinom
//   }

//   if cosom.contents < 0.0 {
//     scale1 := scale1.contents *. -1.0
//   }

//   let s0 = scale0.contents
//   let s1 = scale1.contents

//   this->set(
//     s0 *. this.x +. s1 *. q.x,
//     s0 *. this.y +. s1 *. q.y,
//     s0 *. this.z +. s1 *. q.z,
//     s0 *. this.w +. s1 *. q.w,
//   )
// }
