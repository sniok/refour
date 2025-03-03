// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Mesh from "./Mesh.bs.js";
import * as $$Node from "./Node.bs.js";
import * as Camera from "./Camera.bs.js";
import * as Matrix4 from "./Matrix4.bs.js";
import * as Vector3 from "./Vector3.bs.js";
import * as Quaternion from "./Quaternion.bs.js";
import * as CubeGeometry from "./CubeGeometry.bs.js";
import * as BasicMaterial from "./BasicMaterial.bs.js";

function mesh(geometry, material) {
  return $$Node.make({
              NAME: "Mesh",
              VAL: Mesh.make(geometry, material)
            }, undefined);
}

function group(children) {
  return $$Node.make("Group", children);
}

function camera() {
  var camera$1 = Camera.make();
  return $$Node.make({
              NAME: "Camera",
              VAL: camera$1
            }, undefined);
}

var vec3 = Vector3.make;

var basicMaterial = BasicMaterial.make;

var cubeGeometry = CubeGeometry.make;

var mat4 = Matrix4.make;

var quat = Quaternion.make;

var add = Vector3.add;

var addScalar = Vector3.addScalar;

var multiply = Vector3.multiply;

var multiplyScalar = Vector3.multiplyScalar;

var subtract = Vector3.subtract;

var distanceTo = Vector3.distanceTo;

export {
  vec3 ,
  basicMaterial ,
  cubeGeometry ,
  mat4 ,
  quat ,
  add ,
  addScalar ,
  multiply ,
  multiplyScalar ,
  subtract ,
  distanceTo ,
  mesh ,
  group ,
  camera ,
}
/* Mesh Not a pure module */
