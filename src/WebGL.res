type glT
type programT
type shaderT
type bufferT
type samplerT
type textureT
type framebufferT
type vaoT

@send external clear: (glT, int) => unit = "clear"
@send external clearColor: (glT, float, float, float, float) => unit = "clearColor"
@send external enable: (glT, int) => unit = "enable"
@send external disable: (glT, int) => unit = "disable"
@send external blendFunc: (glT, int, int) => unit = "blendFunc"
@send external cullFace: (glT, int) => unit = "cullFace"
@send external createBuffer: glT => bufferT = "createBuffer"
@send external deleteBuffer: (glT, bufferT) => unit = "deleteBuffer"
@send external bindBuffer: (glT, int, bufferT) => unit = "bindBuffer"
@send external bufferIntData: (glT, int, TypedArray.t<int>, int) => unit = "bufferData"
@send external bufferFloatData: (glT, int, TypedArray.t<float>, int) => unit = "bufferData"
@send external createProgram: glT => programT = "createProgram"
@send external createSampler: glT => samplerT = "createSampler"
@send external createTexture: glT => textureT = "createTexture"
@send external deleteProgram: (glT, programT) => unit = "deleteProgram"
@send external linkProgram: (glT, programT) => unit = "linkProgram"
@send external useProgram: (glT, programT) => unit = "useProgram"
@send external getProgramInfoLog: (glT, programT) => string = "getProgramInfoLog"
@send external bindAttribLocation: (glT, programT, int, string) => unit = "bindAttribLocation"
@send external createShader: (glT, int) => shaderT = "createShader"
@send external deleteShader: (glT, shaderT) => unit = "deleteShader"
@send external shaderSource: (glT, shaderT, string) => unit = "shaderSource"
@send external compileShader: (glT, shaderT) => unit = "compileShader"
@send external attachShader: (glT, programT, shaderT) => unit = "attachShader"
@send external getShaderInfoLog: (glT, shaderT) => string = "getShaderInfoLog"
@send external drawElements: (glT, int, int, int, int) => unit = "drawElements"
@send
external drawElementsInstanced: (glT, int, int, int, int, int) => unit = "drawElementsInstanced"
@send external enableVertexAttribArray: (glT, int) => unit = "enableVertexAttribArray"
@send
external vertexAttribPointer: (glT, int, int, int, bool, int, int) => unit = "vertexAttribPointer"
@send external vertexAttribIPointer: (glT, int, int, int, int, int) => unit = "vertexAttribIPointer"
@send external vertexAttribDivisor: (glT, int, int) => unit = "vertexAttribDivisor"
@send external getAttribLocation: (glT, programT, string) => int = "getAttribLocation"
@send external drawArrays: (glT, int, int, int) => unit = "drawArrays"
@send external viewport: (glT, int, int, int, int) => unit = "viewport"
@send external samplerParameri: (glT, samplerT, int, int) => unit = "samplerParameri"
@send external bindTexture: (glT, int, textureT) => unit = "bindTexture"
@send external pixelStorei: (glT, int, int) => unit = "pixelStorei"
@send external texImage2D: (glT, int, int, int, int, int, 'a) => unit = "texImage2D"
@send external texImage2Dm: (glT, int, int, int, int, int, int, int, int) => unit = "texImage2D"
@send external bindFramebuffer: (glT, int, framebufferT) => unit = "bindFramebuffer"
@send external createFrameBuffer: glT => framebufferT = "createFrameBuffer"
@send
external framebufferTexture2D: (glT, int, int, int, textureT, int) => unit = "framebufferTexture2D"
@send external drawBuffers: (glT, array<int>) => unit = "drawBuffers"
@send external depthFunc: (glT, int) => unit = "depthFunc"
@send external depthMask: (glT, bool) => unit = "depthMask"
@send external getUniformLocation: (glT, programT, string) => int = "getUniformLocation"
@send external activeTexture: (glT, int) => unit = "activeTexture"
@send external bindSampler: (glT, int, samplerT) => unit = "bindSampler"
@unboxed type oneOrManyInts = Array(array<float>) | Int(int)
@send external uniform1i: (glT, int, oneOrManyInts) => unit = "uniform1i"
@send external uniform2fv: (glT, int, oneOrManyInts) => unit = "uniform2fv"
@send external uniform3fv: (glT, int, oneOrManyInts) => unit = "uniform3fv"
@send external uniform4fv: (glT, int, oneOrManyInts) => unit = "uniform4fv"
@send external uniformMatrix3fv: (glT, int, bool, oneOrManyInts) => unit = "uniformMatrix3fv"
@send external uniformMatrix4fv: (glT, int, bool, oneOrManyInts) => unit = "uniformMatrix4fv"
@send external createVertexArray: glT => vaoT = "createVertexArray"
@send external bindVertexArray: (glT, vaoT) => unit = "bindVertexArray"
@get external trinagles: glT => int = "TRIANGLES"
@get external points: glT => int = "POINTS"
@send external getError: glT => int = "getError"

let gl_FRAMEBUFFER = 0x8d40
let gl_COLOR_ATTACHMENT0 = 0x8ce0
let gl_TEXTURE_2D = 0x0de1
let gl_TEXTURE_MAG_FILTER = 0x2800
let gl_TEXTURE_MIN_FILTER = 0x2801
let gl_TEXTURE_WRAP_S = 0x2802
let gl_TEXTURE_WRAP_T = 0x2803
let gl_RGBA = 0x1908
let gl_DEPTH_TEST = 0x0b71
let gl_CULL_FACE = 0x0b44
let gl_BLEND = 0x0be2
let gl_UNPACK_ALIGNMENT = 0x0cf5
let gl_VERTEX_SHADER = 0x8b31
let gl_FRAGMENT_SHADER = 0x8b30
let gl_ELEMENT_ARRAY_BUFFER = 0x8893
let gl_ARRAY_BUFFER = 0x8892
let gl_STATIC_DRAW = 0x88e4
let gl_DYNAMIC_DRAW = 0x88e8
let gl_COLOR_BUFFER_BIT = 0x00004000
let gl_DEPTH_BUFFER_BIT = 0x00000100
let gl_STENCIL_BUFFER_BIT = 0x00000400
let gl_LESS = 0x0201
let gl_FRONT = 0x0404
let gl_BACK = 0x0405
let gl_TEXTURE0 = 0x84c0
let gl_POINTS = 0x0000
let gl_TRANSFORM_FEEDBACK = 0x8e22
let gl_TRANSFORM_FEEDBACK_BUFFER = 0x8c8e
let gl_SEPARATE_ATTRIBS = 0x8c8d
let gl_RASTERIZER_DISCARD = 0x8c89

let gl_NEAREST = 0x2600
let gl_LINEAR = 0x2601

let gl_filters = filter => {
  open Sampler
  switch filter {
  | Nearest => gl_NEAREST
  | Linear => gl_LINEAR
  }
}
let gl_REPEAT = 0x2901
let gl_CLAMP_TO_EDGE = 0x812f
let gl_MIRRORED_REPEAT = 0x8370

let gl_wrappings = wrapping => {
  open Sampler
  switch wrapping {
  | Repeat => gl_REPEAT
  | Clamp => gl_CLAMP_TO_EDGE
  | Mirror => gl_MIRRORED_REPEAT
  }
}

let gl_ZERO = 0
let gl_ONE = 1
let gl_SRC_COLOR = 0x0300
let gl_ONE_MINUS_SRC_COLOR = 0x0301
let gl_SRC_ALPHA = 0x0302
let gl_ONE_MINUS_SRC_ALPHA = 0x0303
let gl_DST_COLOR = 0x0306
let gl_DST_ALPHA = 0x0304
let gl_ONE_MINUS_DST_ALPHA = 0x0305
let gl_ONE_MINUS_DST_COLOR = 0x0307
let gl_SRC_ALPHA_SATURATE = 0x0308
let gl_letANT_COLOR = 0x8001
let gl_ONE_MINUS_letANT_COLOR = 0x8002

let gl_blend_factors = blendFactor => {
  open Material
  switch blendFactor {
  | Zero => gl_ZERO
  | One => gl_ONE
  }
}

let gl_FUNC_ADD = 0x8006
let gl_FUNC_SUBSTRACT = 0x800a
let gl_FUNC_REVERSE_SUBTRACT = 0x800b
let gl_MIN = 0x8007
let gl_MAX = 0x8008

let gl_blend_operations = op => {
  open Material
  switch op {
  | Add => gl_FUNC_ADD
  | Subtract => gl_FUNC_SUBSTRACT
  | ReverseSubtract => gl_FUNC_REVERSE_SUBTRACT
  | Min => gl_MIN
  | Max => gl_MAX
  }
}

let gl_FLOAT = 0x1406
let gl_BYTE = 0x1400
let gl_SHORT = 0x1402
let gl_INT = 0x1404
let gl_UNSIGNED_BYTE = 0x1401
let gl_UNSIGNED_SHORT = 0x1403
let gl_UNSIGNED_INT = 0x1405
