@@warning("-45")
open Sampler
open Material
open WebGL
open Html

let varyingRegex = %re("/[^\w](?:varying|out)\s+\w+\s+(\w+)\s*;/g")

type webGLCompiled = {
  program: programT,
  vao: vaoT,
}

type t = {
  canvas: Canvas.t,
  gl: glT,
  autoClear: bool,
  _compiled: Compiled.t<Mesh.t, webGLCompiled>,
  _programs: Compiled.t<Material.t, programT>,
  _geometry: Compiled.t<Geometry.t, vaoT>,
  _samplers: Compiled.t<Sampler.t, samplerT>,
  _textures: Compiled.t<Texture.t, textureT>,
  _buffers: Compiled.t<Geometry.Attribute.t, bufferT>,
  _fbo: Compiled.t<RenderTarget.t, framebufferT>,
  mutable _textureIndex: int,
}

let make = () => {
  let canvas = createElement("canvas")
  canvas.width = 1200
  canvas.height = 1200

  appendChild(canvas)

  let gl = canvas->Canvas.getContext("webgl2")

  {
    canvas,
    gl,
    autoClear: true,
    _compiled: Compiled.make(),
    _programs: Compiled.make(),
    _geometry: Compiled.make(),
    _samplers: Compiled.make(),
    _textures: Compiled.make(),
    _buffers: Compiled.make(),
    _fbo: Compiled.make(),
    _textureIndex: 0,
  }
}

let setSize = (t, ~width, ~height) => {
  t.canvas.width = width
  t.canvas.height = height
  t.gl->viewport(0, 0, width, height)
}

let updateSampler = (t: t, sampler: Sampler.t) => {
  let maybeTarget = t._samplers->Compiled.get(sampler)

  let target = switch maybeTarget {
  | None => {
      let compiledSampler = t.gl->createSampler
      t._samplers->Compiled.set(sampler, compiledSampler)
      sampler.needsUpdate = true
      compiledSampler
    }
  | Some(t) => t
  }

  if sampler.needsUpdate {
    // if sampler.anisoetropy {
    //   let anisotropyExt = t.gl->getExtension("EXT_texture_filter_anisotropic")
    // }

    t.gl->samplerParameri(target, gl_TEXTURE_MAG_FILTER, gl_filters(sampler.magFilter))
    t.gl->samplerParameri(target, gl_TEXTURE_MIN_FILTER, gl_filters(sampler.minFilter))
    t.gl->samplerParameri(target, gl_TEXTURE_WRAP_S, gl_wrappings(sampler.wrapS))
    t.gl->samplerParameri(target, gl_TEXTURE_WRAP_T, gl_wrappings(sampler.wrapT))

    sampler.needsUpdate = false
  }

  target
}

let updateTexture = (t, texture: Texture.t, ~width=0, ~height=0) => {
  open Compiled
  open Option

  let target =
    t._textures
    ->get(texture)
    ->getWithDefault({
      let tex = t.gl->createTexture
      texture.needsUpdate = true
      t._textures->Compiled.set(texture, tex)
      tex
    })

  t.gl->bindTexture(gl_TEXTURE_2D, target)

  if texture.needsUpdate {
    t.gl->pixelStorei(gl_UNPACK_ALIGNMENT, 1)

    let format = texture.format->Option.getWithDefault(gl_RGBA)
    let typ = texture.textureType->Option.getWithDefault(gl_UNSIGNED_BYTE)

    switch texture.image {
    | Some(img) => t.gl->texImage2D(gl_TEXTURE_2D, 0, format, format, typ, img)
    | None => t.gl->texImage2Dm(gl_TEXTURE_2D, 0, format, width, height, 0, format, typ)
    }

    switch texture.image {
    | Some(img) =>
      switch img {
      | ImageBitmap
      | HTMLCanvasElement
      | OffscreenCanvas =>
        texture.needsUpdate = true
      | HTMLVideoElement => ()
      }
    | None => ()
    }
  }

  t->updateSampler(texture.sampler)->ignore

  target
}

let setRenderTarget = (t: t, renderTarget: RenderTarget.t) => {
  let maybeFbo = t._fbo->Compiled.get(renderTarget)

  let fbo = switch maybeFbo {
  | None => {
      let fbo = t.gl->createFrameBuffer

      t.gl->bindFramebuffer(gl_FRAMEBUFFER, fbo)

      let attachments = renderTarget.textures->Array.mapWithIndex((texture, i) => {
        let attachment = gl_COLOR_ATTACHMENT0 + i
        let target =
          t->updateTexture(texture, ~width=renderTarget.width, ~height=renderTarget.height)
        t.gl->framebufferTexture2D(gl_FRAMEBUFFER, attachment, gl_TEXTURE_2D, target, 0)
        attachment
      })
      t.gl->drawBuffers(attachments)
      renderTarget.needsUpdate = false
      t._fbo->Compiled.set(renderTarget, fbo)

      fbo
    }
  | Some(target) => target
  }

  t.gl->bindFramebuffer(gl_FRAMEBUFFER, fbo)
  t.gl->viewport(0, 0, renderTarget.width, renderTarget.height)
}

let setDepthTest = (t: t, enabled: bool) =>
  if enabled {
    t.gl->enable(gl_DEPTH_TEST)
    t.gl->depthFunc(gl_LESS)
  } else {
    t.gl->disable(gl_DEPTH_TEST)
  }

let setDepthMask = (t: t, enabled: bool) => t.gl->depthMask(enabled)

let setCullSide = (t: t, side: side) =>
  switch side {
  | Front
  | Back => {
      t.gl->enable(gl_CULL_FACE)
      t.gl->cullFace(side === Front ? gl_BACK : gl_FRONT)
    }
  | Both => {
      t.gl->disable(gl_CULL_FACE)
      t.gl->disable(gl_DEPTH_TEST)
    }
  }

let setBlending = (t: t, blending: option<blending>) =>
  switch blending {
  | None => t.gl->disable(gl_BLEND)
  | Some(_) => failwith("TODO")
  }

let setUniform = (t: t, program: programT, name: string, value: Material.uniform) => {
  let location = t.gl->getUniformLocation(program, name)

  switch location {
  | -1 => ()
  | location =>
    switch value {
    | Single(value) => t.gl->uniform1i(location, Int(value))
    | Array(value) =>
      switch value->Array.length {
      | 2 => t.gl->uniform2fv(location, Array(value))
      | 3 => t.gl->uniform3fv(location, Array(value))
      | 4 => t.gl->uniform4fv(location, Array(value))
      | 9 => t.gl->uniformMatrix3fv(location, false, Array(value))
      | 16 => t.gl->uniformMatrix4fv(location, false, Array(value))
      | _ => failwith("unknown value")
      }
    | Texture(texture) => {
        t._textureIndex = t._textureIndex + 1
        let index = t._textureIndex
        t.gl->activeTexture(gl_TEXTURE0 + index)
        let sampler = t._samplers->Compiled.get(texture.sampler)
        switch sampler {
        | Some(sampler) => t.gl->bindSampler(index, sampler)
        | None => ()
        }
        t->updateTexture(texture)->ignore
        t.gl->uniform1i(location, Int(index))
        ()
      }
    }
  }
}

let compile = (t: t, mesh: Mesh.t, meshNode: Node.t, camera: Camera.t) => {
  open Js.Dict

  mesh.material.uniforms->set("modelMatrix", Array(meshNode.matrix))
  mesh.material.uniforms->set("projectionMatrix", Array(camera.projectionMatrix))
  mesh.material.uniforms->set("viewMatrix", Array(camera.viewMatrix))
  mesh.material.uniforms->set("normalMatrix", Array(mesh.normalMatrix))
  mesh.material.uniforms->set("modelViewMatrix", Array(mesh.modelViewMatrix))

  mesh.modelViewMatrix->Matrix4.copy(camera.viewMatrix)->Matrix4.multiply(meshNode.matrix)->ignore
  mesh.normalMatrix->Matrix4.normal(mesh.modelViewMatrix)->ignore

  let compiled = t._compiled->Compiled.get(mesh)
  let program = t._programs->Compiled.get(mesh.material)

  let program = switch program {
  | Some(program) => program
  | None => {
      let program = t.gl->createProgram

      t._programs->Compiled.set(mesh.material, program)

      let vertexShader = t.gl->createShader(gl_VERTEX_SHADER)
      t.gl->shaderSource(vertexShader, mesh.material.vertex)
      t.gl->compileShader(vertexShader)
      t.gl->attachShader(program, vertexShader)

      let fragmentShader = t.gl->createShader(gl_FRAGMENT_SHADER)
      t.gl->shaderSource(fragmentShader, mesh.material.fragment)
      t.gl->compileShader(fragmentShader)
      t.gl->attachShader(program, fragmentShader)

      t.gl->linkProgram(program)

      let error = t.gl->getShaderInfoLog(fragmentShader)
      Console.log(error)

      let error = t.gl->getShaderInfoLog(vertexShader)
      Console.log(error)

      let error = t.gl->getProgramInfoLog(program)
      Console.log(error)

      t.gl->deleteShader(vertexShader)
      t.gl->deleteShader(fragmentShader)

      program
    }
  }

  let vao = switch t._geometry->Compiled.get(mesh.geometry) {
  | Some(vao) => vao
  | None => {
      let vao = t.gl->createVertexArray
      t._geometry->Compiled.set(mesh.geometry, vao)
      vao
    }
  }

  t.gl->useProgram(program)
  t.gl->bindVertexArray(vao)

  mesh.geometry.attributes
  ->entries
  ->Array.forEach(((key, attribute)) => {
    let typ = key == "index" ? gl_ELEMENT_ARRAY_BUFFER : gl_ARRAY_BUFFER

    let buffer = switch t._buffers->Compiled.get(attribute) {
    | Some(buffer) => buffer
    | None => {
        let buffer = t.gl->createBuffer
        t._buffers->Compiled.set(attribute, buffer)
        t.gl->bindBuffer(typ, buffer)
        switch attribute.data {
        | Float32Array(arr) => t.gl->bufferFloatData(typ, arr, gl_STATIC_DRAW)
        | Uint16Array(arr) => t.gl->bufferIntData(typ, arr, gl_STATIC_DRAW)
        }
        attribute.needsUpdate = false

        buffer
      }
    }

    let maybeCompiledProgram = compiled->Option.flatMap(it => Some(it.program))->Option.getUnsafe
    let maybeCompiledVao = compiled->Option.flatMap(it => Some(it.vao))->Option.getUnsafe

    if program != maybeCompiledProgram || vao != maybeCompiledVao {
      t.gl->bindBuffer(typ, buffer)

      let location = t.gl->getAttribLocation(program, key)
      if location != -1 {
        let slots =
          Math.min(4.0, Math.max(1.0, Math.floor(attribute.size->Int.toFloat /. 3.0)))->Float.toInt

        for i in 0 to slots - 1 {
          t.gl->enableVertexAttribArray(location + i)
          let typ = gl_FLOAT
          let stride = attribute.size * attribute.data->TypeArray.bytesPerElement
          let offset = attribute.size * i

          if typ === gl_FLOAT {
            t.gl->vertexAttribPointer(location, attribute.size, typ, false, stride, offset)
          } else {
            t.gl->vertexAttribIPointer(location, attribute.size, typ, stride, offset)
          }

          switch attribute.divisor {
          | None => ()
          | Some(divisor) => t.gl->vertexAttribDivisor(location + i, divisor)
          }
        }
      }
    }

    if attribute.needsUpdate {
      t.gl->bindBuffer(typ, buffer)

      switch attribute.data {
      | Float32Array(arr) => t.gl->bufferFloatData(typ, arr, gl_DYNAMIC_DRAW)
      | Uint16Array(arr) => t.gl->bufferIntData(typ, arr, gl_DYNAMIC_DRAW)
      }

      attribute.needsUpdate = false
    }
  })

  t._textureIndex = 0
  mesh.material.uniforms
  ->entries
  ->Array.forEach(((key, value)) => {
    t->setUniform(program, key, value)
  })

  switch compiled {
  | None => {
      let comp = {program, vao}
      t._compiled->Compiled.set(mesh, comp)
      comp
    }
  | Some(comp) => comp
  }
}

let clear = (t: t) => {
  let bits = lor(lor(gl_COLOR_BUFFER_BIT, gl_DEPTH_BUFFER_BIT), gl_STENCIL_BUFFER_BIT)
  t.gl->clear(bits)
}

let sort = (_: t, scene: array<Node.t>, camera: Node.tOfKind<[#Camera(Camera.t)]>): array<(
  Node.t,
  Mesh.t,
)> => {
  let cam = camera.kind->Node.unpack

  if camera.matrixAutoUpdate {
    cam.projectionViewMatrix
    ->Matrix4.copy(cam.projectionMatrix)
    ->Matrix4.multiply(cam.viewMatrix)
    ->ignore

    cam.frustum->Frustum.fromMatrix4(cam.projectionViewMatrix)->ignore
  }

  let renderList = scene->Array.flatMap(it => {
    switch it.kind {
    | #Mesh(mesh) => it.visible ? [(it, mesh)] : []
    | _ => []
    }
  })

  let v = Vector3.make(0.0, 0.0, 0.0)

  renderList->Array.sort(((aNode, _), (bNode, _)) => {
    Vector3.applyMatrix4(
      v->Vector3.set(
        bNode.matrix->Array.getUnsafe(12),
        bNode.matrix->Array.getUnsafe(13),
        bNode.matrix->Array.getUnsafe(14),
      ),
      cam.projectionViewMatrix,
    ).z -.
    Vector3.applyMatrix4(
      v->Vector3.set(
        aNode.matrix->Array.getUnsafe(12),
        aNode.matrix->Array.getUnsafe(13),
        aNode.matrix->Array.getUnsafe(14),
      ),
      cam.projectionViewMatrix,
    ).z
  })

  renderList
}

let getDataType = (arr: TypeArray.t) =>
  switch arr {
  | Float32Array(_) => gl_FLOAT
  | Uint16Array(_) => gl_UNSIGNED_SHORT
  }

let render = (t: t, scene: Node.t, camera: Node.tOfKind<[#Camera(Camera.t)]>) => {
  if t.autoClear {
    t->clear
  }

  scene.children->Array.forEach(it => it->Node.updateMatrix)
  Node.updateMatrix((camera :> Node.t))

  let renderList = t->sort(scene.children, camera)

  renderList->Array.forEach(((node, mesh)) => {
    Node.updateMatrix(node)

    t->compile(mesh, node, camera.kind->Node.unpack)->ignore
    t->setDepthTest(mesh.material.depthTest)
    t->setDepthMask(mesh.material.depthWrite)
    t->setCullSide(mesh.material.side)
    t->setBlending(mesh.material.blending)

    let mode = t.gl->trinagles
    let index = mesh.geometry.attributes->Js.Dict.get("index")
    // let position = mesh.geometry.attributes->Js.Dict.get("position")
    let {start, count} = mesh.geometry.drawRange

    switch index {
    | Some(index) =>
      t.gl->drawElements(
        mode,
        Math.min(
          count->Int.toFloat,
          (index.data->TypeArray.length / index.size)->Int.toFloat,
        )->Float.toInt,
        getDataType(index.data),
        start,
      )
    | None => ()
    }
  })
}
