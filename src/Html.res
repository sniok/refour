module Canvas = {
  type t = {
    mutable width: int,
    mutable height: int,
  }
  @send external getContext: (t, string) => WebGL.glT = "getContext"
}

@scope("document.body") external appendChild: Canvas.t => unit = "appendChild"
@scope("document") external createElement: string => Canvas.t = "createElement"
