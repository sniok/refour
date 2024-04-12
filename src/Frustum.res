@@warning("-8")
type t = array<float>

let make = (): t => []

let set = (this: t, f: array<float>) => {
  for i in 0 to 23 {
    Array.setUnsafe(this, i, Array.getUnsafe(f, i))
  }
}

let copy = (this: t, f: t) => {
  this->set(f)
}

let fromMatrix4 = (this: t, projectionViewMatrix: Matrix4.t) => {
  let [
    m00,
    m01,
    m02,
    m03,
    m10,
    m11,
    m12,
    m13,
    m20,
    m21,
    m22,
    m23,
    m30,
    m31,
    m32,
    m33,
  ] = projectionViewMatrix

  //. http://cs.otago.ac.nz/postgrads/alexis/planeExtraction.pdf
  this->set([
    //. Left clipping plane
    m03 -. m00,
    m13 -. m10,
    m23 -. m20,
    m33 -. m30,
    //. Right clipping plane
    m03 +. m00,
    m13 +. m10,
    m23 +. m20,
    m33 +. m30,
    //. Top clipping plane
    m03 +. m01,
    m13 +. m11,
    m23 +. m21,
    m33 +. m31,
    //. Bottom clipping plane
    m03 -. m01,
    m13 -. m11,
    m23 -. m21,
    m33 -. m31,
    //. Near clipping plane
    m03 -. m02,
    m13 -. m12,
    m23 -. m22,
    m33 -. m32,
    //. Far clipping plane
    m03 +. m02,
    m13 +. m12,
    m23 +. m22,
    m33 +. m32,
  ])
  this
}

let contains = (_: t, _: Mesh.t) => {
  // let position = mesh.geometry.attributes->Js.Dict.get("position")->Option.getUnsafe
  // let vertices = position.data->TypeArray.length / position.size

  true
}

//  let contains = (mesh: Mesh) => {
//     const { position } = mesh.geometry.attributes
//     const vertices = position.data.length / position.size

//     let radius = 0

//     for (let i = 0; i < vertices; i += position.size) {
//       let vertexLengthSquared = 0
//       for (let vi = i; vi < i + position.size; vi++) vertexLengthSquared += position.data[vi] ** 2
//       radius = max(radius, sqrt(vertexLengthSquared))
//     }

//     radius *= max(...mesh.scale)

//     for (let i = 0; i < 6; i++) {
//       const offset = i * 4
//       const distance =
//         this[offset] * mesh.matrix[12] +
//         this[offset + 1] * mesh.matrix[13] +
//         this[offset + 2] * mesh.matrix[14] +
//         this[offset + 3]

//       if (distance <= -radius) return false
//     }

//     return true
//   }
