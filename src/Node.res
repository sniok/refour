type rec nodeKind = [#Mesh(Mesh.t) | #Camera(Camera.t) | #Group]

type rec tOfKind<'a> = {
  kind: 'a,
  matrix: Matrix4.t,
  quaternion: Quaternion.t,
  position: Vector3.t,
  scale: Vector3.t,
  up: Vector3.t,
  children: array<t>,
  mutable parent?: t,
  mutable matrixAutoUpdate: bool,
  mutable visible: bool,
  mutable frustumCulled: bool,
}
and t = tOfKind<nodeKind>

let make = (kind, ~children=[]) => {
  kind,
  matrix: Matrix4.make(),
  quaternion: Quaternion.make(),
  position: Vector3.make(0.0, 0.0, 0.0),
  scale: Vector3.make(1.0, 1.0, 1.0),
  up: Vector3.make(0.0, 1.0, 0.0),
  children,
  matrixAutoUpdate: true,
  visible: true,
  frustumCulled: true,
}

let rec updateMatrix = (this: t) => {
  open Ops
  if this.matrixAutoUpdate {
    this.matrix->compose(this.position, this.quaternion, this.scale)->ignore
    switch this.parent {
    | Some(parent) => this.matrix->Matrix4.multiply(parent.matrix)->ignore
    | None => ()
    }
    this.children->Array.forEach(child => updateMatrix(child))
  }
  switch this.kind {
  | #Camera(cam) => Camera.updateMatrix(cam, this.matrix)
  | _ => ()
  }
}

let unpack = kind => {
  switch kind {
  | #Mesh(m) => m
  | #Camera(c) => c
  }
}

let add = (this: t, child: t) => {
  this.children->Array.push(child)->ignore
  child.parent = Some(this)
}

let addMany = (this: t, children: array<t>) => {
  this.children->Array.pushMany(children)->ignore
  children->Array.forEach(child => {
    child.parent = Some(this)
  })
}

let remove = (this: t, children: array<t>) => {
  children->Array.forEach(child => {
    let childIndex = this.children->Array.indexOf(child)
    if childIndex != -1 {
      this.children->Array.splice(~start=childIndex, ~remove=1, ~insert=[])
    }
    child.parent = None
  })
}

let rec traverse = (this: t, callback) => {
  if !callback(this) {
    this.children->Array.forEach(child => child->traverse(callback))
  }
}

let lookAt = (this: t, target) => {
  this.quaternion->Quaternion.lookAt(this.position, target, this.up)
}
