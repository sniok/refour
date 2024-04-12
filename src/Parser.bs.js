// Generated by ReScript, PLEASE EDIT WITH CARE


function compile(expr) {
  var pad = function (str, depth) {
    return str.split("\n").map(function (it) {
                  return "  ".repeat(depth) + it;
                }).join("\n");
  };
  var step = function (expr, depthOpt) {
    var depth = depthOpt !== undefined ? depthOpt : 0;
    var tmp;
    switch (expr.TAG) {
      case "ModuleType" :
          tmp = "module " + expr._0 + " = {\n" + expr._1.map(function (it) {
                  return step(it, depth + 1 | 0);
                }).join("\n") + "\n}";
          break;
      case "TypeDeclaration" :
          var params = expr._1;
          var name = expr._0;
          tmp = params.length !== 0 ? "type " + name + " = {\n" + params.map(function (param) {
                    return pad("mutable " + param.name + ": " + param.typ, depth);
                  }).join(",\n") + "\n}" : "type " + name;
          break;
      case "FunctionDeclaration" :
          var name$1 = expr.name;
          tmp = "@send external " + name$1 + ": (" + expr.args.join(", ") + ") => " + expr.returnType + " = \"" + name$1 + "\"";
          break;
      
    }
    return pad(tmp, depth);
  };
  return step(expr, undefined);
}

function makeModule(name, props, funs) {
  return {
          TAG: "ModuleType",
          _0: name,
          _1: [{
                TAG: "TypeDeclaration",
                _0: "t",
                _1: props.map(function (param) {
                      return {
                              name: param[0],
                              typ: param[1]
                            };
                    })
              }].concat(funs.map(function (param) {
                    return {
                            TAG: "FunctionDeclaration",
                            name: param[0],
                            args: param[1],
                            returnType: param[2]
                          };
                  }))
        };
}

var canvas = makeModule("Canvas", [
      [
        "width",
        "int"
      ],
      [
        "height",
        "int"
      ]
    ], [[
        "getContext",
        ["t"],
        "unit"
      ]]);

var result = compile(canvas);

console.log(result);

var testString = "\nmodule type GLt = {\n  type t\n\n  let clear : ( t , int ) => unit\n}\n";

export {
  testString ,
  compile ,
  makeModule ,
  canvas ,
  result ,
}
/* canvas Not a pure module */
