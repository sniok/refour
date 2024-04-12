// Make aliases
let vec3 = Vector3.make
let basicMaterial = BasicMaterial.make
let cubeGeometry = CubeGeometry.make
let mat4 = Matrix4.make
let quat = Quaternion.make
let {add, addScalar, multiply, multiplyScalar, subtract, distanceTo} = module(Vector3)

// Node creators
let mesh = (~geometry, ~material) => Node.make(#Mesh(Mesh.make(~geometry, ~material)))
let group = children => Node.make(#Group, ~children)

let camera = (): Node.tOfKind<[#Camera(Camera.t)]> => {
  let camera = Camera.make()
  let node = Node.make(#Camera(camera))
  node
}
