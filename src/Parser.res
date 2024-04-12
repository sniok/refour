module type GLt = {
  type t = {triangles: int}

  let clear: (t, int) => unit
}

let testString = `
module type GLt = {
  type t

  let clear : ( t , int ) => unit
}
`

type token =
  | Module
  | Type
  | Name(string)
  | Let
  | Colon
  | OpenParen
  | CloseParen
  | Comma
  | EqualMoreThan
  | OpenCurly
  | CloseCurly
  | Equal

type propDecl = {name: string, typ: string}

type rec expression =
  | ModuleType(string, array<expression>)
  | TypeDeclaration(string, array<propDecl>)
  | FunctionDeclaration({name: string, args: array<string>, returnType: string})

let compile = expr => {
  open Array

  let pad = (str, depth) =>
    str->String.split("\n")->map(it => "  "->String.repeat(depth) ++ it)->joinWith("\n")

  let rec step = (expr, ~depth=0) =>
    switch expr {
    | TypeDeclaration(name, []) => `type ${name}`
    | TypeDeclaration(name, params) =>
      `type ${name} = {\n${params
        ->map(({name, typ}) => `mutable ${name}: ${typ}`->pad(depth))
        ->joinWith(",\n")}\n}`
    | FunctionDeclaration({name, args, returnType}) =>
      `@send external ${name}: (${args->Array.joinWith(", ")}) => ${returnType} = "${name}"`
    | ModuleType(name, children) =>
      `module ${name} = {\n${children->map(it => step(it, ~depth=depth + 1))->joinWith("\n")}\n}`
    }->pad(depth)

  step(expr)
}

type props = (string, string)
type funs = (string, array<string>, string)

let makeModule = (name, props, funs) => {
  open Array
  ModuleType(
    name,
    [TypeDeclaration("t", props->map(((name, typ)) => {name, typ}))]->concat(
      funs->map(((name, args, returnType)) => FunctionDeclaration({name, args, returnType})),
    ),
  )
}

let canvas = makeModule(
  "Canvas",
  [("width", "int"), ("height", "int")],
  [("getContext", ["t"], "unit")],
)
let result = compile(canvas)
Js.log(result)

// let tokenize = (s: string): array<token> => {
//   let stuffs = s->String.trim->String.splitByRegExp(%re("/[ \n]+/"))

//   let tokens =
//     stuffs
//     ->Array.flatMap(it =>
//       switch it {
//       | Some(item) => [item]
//       | None => []
//       }
//     )
//     ->Array.map(it =>
//       switch it {
//       | "module" => Module
//       | "type" => Type
//       | "let" => Let
//       | ":" => Colon
//       | "(" => OpenParen
//       | ")" => CloseParen
//       | "," => Comma
//       | "=>" => EqualMoreThan
//       | "{" => OpenCurly
//       | "}" => CloseCurly
//       | "=" => Equal
//       | name => Name(name)
//       }
//     )

//   Js.log(tokens)

//   tokens
// }

// let tree = (tokens: array<token>): expression => {
//   let current = ref(-1)
//   let this = () => {
//     tokens->Array.getUnsafe(current.contents)
//   }
//   let peek = () => {
//     tokens->Array.getUnsafe(current.contents + 1)
//   }
//   let next = () => {
//     current.contents = current.contents + 1
//     let token = tokens->Array.getUnsafe(current.contents)
//     Js.log(token)
//     token
//   }

//   let rec parseExpression = () => {
//     let tok = next()
//     Js.log2("Parsing expression", tok)
//     switch tok {
//     | Module => parseModule()
//     | Type => parseType()
//     | Let => parseFunction()
//     | _ => {
//         Js.log(tokens)
//         Js.log(current)
//         failwith("uh uwh")
//       }
//     }
//   }
//   and parseModule = () => {
//     let typToken = next() // type
//     let name = next()
//     let eq = next()
//     let paren = next()

//     let name = switch (typToken, name, eq, paren) {
//     | (Type, Name(str), Equal, OpenCurly) => str
//     | _ => failwith("uh oh")
//     }

//     let children = []
//     while peek() != CloseCurly {
//       children->Array.push(parseExpression())
//     }
//     next()->ignore
//     ModuleType(name, children)
//   }
//   and parseType = () => {
//     let name = next()

//     switch name {
//     | Name(name) => TypeDeclaration(name)
//     | _ => failwith("7h oh")
//     }
//   }
//   and parseFunction = () => {
//     Js.log("parsing function")
//     let name = next()
//     let col = next()
//     let op = next()

//     let name = switch name {
//     | Name(name) => name
//     | _ => failwith("no fun")
//     }

//     let args = []
//     let value = ref(next())
//     while value.contents != CloseParen {
//       switch value.contents {
//       | Name(name) => args->Array.push(name)
//       | Comma => ()
//       | _ => {
//           Js.log(value)
//           failwith("idk")
//         }
//       }
//       value.contents = next()
//     }

//     next()->ignore

//     let returnType = switch next() {
//     | Name(name) => name
//     | _ => failwith("no return")
//     }

//     FunctionDeclaration({name, args, returnType})
//   }

//   parseExpression()
// }

// tokenize(testString)->tree->Js.log
