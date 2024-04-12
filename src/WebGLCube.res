open Global
open WebGLRenderer

let renderer = WebGLRenderer.make()
renderer->setSize(~width=1000, ~height=1000)

let camera = camera()
camera.position.z = 5.0

let makeRotation = (thing: Node.t) => {
  let angle = ref(0.0)
  let update = () => {
    let a = angle.contents
    thing.quaternion->Quaternion.fromEuler(a, a, a)->ignore
    angle.contents = angle.contents +. 0.01
  }

  {"update": update}
}

let cube = mesh(~geometry=cubeGeometry(), ~material=basicMaterial(~color=Red))
let scene = group([cube])
let rotator = makeRotation(cube)

let animate = () => {
  renderer->render(scene, camera)

  rotator["update"]()

  cube.quaternion.x = cube.quaternion.x +. 0.1
  cube.quaternion.y = cube.quaternion.y +. 0.1
  ()
}

animate()
// setInterval(() => animate(), 20)->ignore
