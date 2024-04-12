type t = {
  textures: array<Texture.t>,
  mutable needsUpdate: bool,
  width: int,
  height: int,
  count: int,
}

let make = (~width, ~height, ~count=1) => {
  textures: [Texture.make()],
  needsUpdate: true,
  width,
  height,
  count,
}
