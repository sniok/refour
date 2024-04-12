type uniform = Single(int) | Array(array<float>) | Texture(Texture.t)

type side = Front | Back | Both

type blendOperation = Add | Subtract | ReverseSubtract | Min | Max

type blendFactor = Zero | One

type blendComponent = {
  operation: option<blendOperation>,
  srcFactor: option<blendFactor>,
  dstFactor: option<blendFactor>,
}

type blending = {
  color: blendComponent,
  alpha: blendComponent,
}

type t = {
  uniforms: Js.Dict.t<uniform>,
  vertex: string,
  fragment: string,
  side: side,
  transparent: bool,
  depthTest: bool,
  depthWrite: bool,
  blending: option<blending>,
}

let make = (
  ~uniforms=Js.Dict.empty(),
  ~vertex,
  ~fragment,
  ~side=Front,
  ~transparent=false,
  ~depthTest=true,
  ~depthWrite=true,
  ~blending=None,
) => {
  uniforms,
  vertex,
  fragment,
  side,
  transparent,
  depthTest,
  depthWrite,
  blending,
}
