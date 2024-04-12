type t = {
  center: Vector3.t,
  speed: float,
  camera: Node.tOfKind<[#Camera(Camera.t)]>,
}

let make = camera => {
  let center = Vector3.make(0.0, 0.0, 0.0)

  camera->Node.lookAt(center)
}

// let orbit = (this, deltaX, deltaY) => {
//   open Vector3

//   let offset = this.camera.position->subtract(this.center)

//   // let radius = offset->getLength

//   // let deltaPhi = deltaX *. (this.speed /. )

//   this
// }
