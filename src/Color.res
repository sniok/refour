type t =
  | RGB(int, int, int)
  | Red
  | White

let toArray = t => {
  switch t {
  | RGB(r, g, b) => [r, g, b]
  | Red => [255, 0, 0]
  | White => [255, 255, 255]
  }->Array.map(Int.toFloat)
}
