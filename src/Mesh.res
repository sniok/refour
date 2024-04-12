type mode = Triangles | Points | Lines

type t = {
  modelViewMatrix: Matrix4.t,
  normalMatrix: Matrix4.t,
  mode: mode,
  instances: int,
  geometry: Geometry.t,
  material: Material.t,
}

let make = (~geometry, ~material): t => {
  modelViewMatrix: Matrix4.make(),
  normalMatrix: Matrix4.make(),
  mode: Triangles,
  instances: 1,
  geometry,
  material,
}
