type t =
  | Float32Array(Float32Array.t)
  | Uint16Array(Uint16Array.t)

let float32Array = (arr: array<'a>) => Float32Array(Float32Array.fromArrayLikeOrIterable(arr))
let uint16Array = (arr: array<'a>) => Uint16Array(Uint16Array.fromArrayLikeOrIterable(arr))

let length = t =>
  switch t {
  | Float32Array(arr) => TypedArray.length(arr)
  | Uint16Array(arr) => TypedArray.length(arr)
  }

let float = t =>
  switch t {
  | Float32Array(arr) => arr
  | Uint16Array(_) => failwith("meh this is int")
  }

let int = (t: t) =>
  switch t {
  | Float32Array(_) => failwith("meh this is float")
  | Uint16Array(arr) => arr
  }

@get external bytesPerElement: TypedArray.t<'a> => int = "BYTES_PER_ELEMENT"

let bytesPerElement = (t: t) => {
  switch t {
  | Float32Array(arr) => arr->bytesPerElement
  | Uint16Array(arr) => arr->bytesPerElement
  }
}
