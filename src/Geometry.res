module Attribute = {
  type t = {
    data: TypeArray.t,
    size: int,
    divisor?: int,
    mutable needsUpdate: bool,
  }

  let make = (size, data) => {
    data,
    size,
    needsUpdate: false,
  }
}

type drawRange = {
  start: int,
  count: int,
}

type t = {
  drawRange: drawRange,
  attributes: Js.Dict.t<Attribute.t>,
}

let make = (a: array<(string, Attribute.t)>) => {
  let attributes: Js.Dict.t<Attribute.t> = Js.Dict.empty()

  a->Array.forEach(((name, value)) => {
    attributes->Js.Dict.set(name, value)
    Js.Dict.unsafeGet(attributes, name).needsUpdate = true
  })

  {
    attributes,
    drawRange: {
      start: 0,
      count: 9999999,
    },
  }
}
