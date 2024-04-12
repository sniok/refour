type filter = Nearest | Linear

type wrapping = Clamp | Repeat | Mirror

type t = {
  magFilter: filter,
  minFilter: filter,
  wrapS: wrapping,
  wrapT: wrapping,
  anisotropy: float,
  mutable needsUpdate: bool,
}

let make = (
  ~magFilter=Nearest,
  ~minFilter=Nearest,
  ~wrapS=Clamp,
  ~wrapT=Clamp,
  ~anisotropy=1.0,
  ~needsUpdate=true,
  (),
) => {
  magFilter,
  minFilter,
  wrapS,
  wrapT,
  anisotropy,
  needsUpdate,
}
