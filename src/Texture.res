type imageRepresentation = ImageBitmap | HTMLCanvasElement | HTMLVideoElement | OffscreenCanvas

type t = {
  sampler: Sampler.t,
  image: option<imageRepresentation>,
  format: option<int>,
  textureType: option<int>,
  mutable needsUpdate: bool,
}

let make = (
  ~image=None,
  ~sampler=Sampler.make(),
  ~format=None,
  ~textureType=None,
  ~needsUpdate=true,
  (),
) => {
  image,
  sampler,
  format,
  textureType,
  needsUpdate,
}
