type t<'a, 'b> = WeakMap.t<'a, 'b>

let make = (): t<'a, 'b> => {
  let it = WeakMap.make()
  it
}

let get = (t, a) => {
  t->WeakMap.get(a)
}

let set = (t, a, v) => {
  t->WeakMap.set(a, v)->ignore
  ()
}
