// Generated by ReScript, PLEASE EDIT WITH CARE


function make(x, y, z) {
  return {
          x: x,
          y: y,
          z: z
        };
}

function set(v, x, y, z) {
  v.x = x;
  v.y = y;
  v.z = z;
  return v;
}

function multiply(me, v) {
  me.x = me.x * v.x;
  me.y = me.y * v.y;
  me.z = me.z * v.z;
  return me;
}

function multiplyScalar(me, scalar) {
  me.x = me.x * scalar;
  me.y = me.y * scalar;
  me.z = me.z * scalar;
  return me;
}

function add(me, v) {
  me.x = me.x + v.x;
  me.y = me.y + v.y;
  me.z = me.z + v.z;
  return me;
}

function addScalar(me, scalar) {
  me.x = me.x + scalar;
  me.y = me.y + scalar;
  me.z = me.z + scalar;
  return me;
}

function subtract(me, v) {
  me.x = me.x - v.x;
  me.y = me.y - v.y;
  me.z = me.z - v.z;
  return me;
}

function subtractScalar(me, scalar) {
  me.x = me.x - scalar;
  me.y = me.y - scalar;
  me.z = me.z - scalar;
  return me;
}

function divide(me, v) {
  me.x = me.x / v.x;
  me.y = me.y / v.y;
  me.z = me.z / v.z;
  return me;
}

function divideScalar(me, scalar) {
  me.x = me.x / scalar;
  me.y = me.y / scalar;
  me.z = me.z / scalar;
  return me;
}

function clone(a) {
  return {
          x: a.x,
          y: a.y,
          z: a.z
        };
}

var Ops = {};

function copy(me, v) {
  me.x = v.x;
  me.y = v.y;
  me.z = v.z;
  return me;
}

function distanceTo(me, to) {
  return Math.hypot(me.x - to.x, me.y - to.y, me.z - to.z);
}

function dot(me, v) {
  return me.x * v.x + me.y * v.y + me.z * v.z;
}

function cross(me, v) {
  me.x = me.y * v.z - me.z * v.y;
  me.y = me.z * v.x - me.x * v.z;
  me.z = me.x * v.y - me.y * v.x;
  return me;
}

function lerp(me, v, t) {
  me.x = v.x - me.x;
  me.y = v.y - me.y;
  me.z = v.z - me.z;
  return multiplyScalar(me, t);
}

function applyMatrix4($$this, m) {
  if (m.length !== 16) {
    throw {
          RE_EXN_ID: "Match_failure",
          _1: [
            "Vector3.res",
            116,
            6
          ],
          Error: new Error()
        };
  }
  var m00 = m[0];
  var m01 = m[1];
  var m02 = m[2];
  var m03 = m[3];
  var m10 = m[4];
  var m11 = m[5];
  var m12 = m[6];
  var m13 = m[7];
  var m20 = m[8];
  var m21 = m[9];
  var m22 = m[10];
  var m23 = m[11];
  var m30 = m[12];
  var m31 = m[13];
  var m32 = m[14];
  var m33 = m[15];
  $$this.x = m00 * $$this.x + m10 * $$this.y + m20 * $$this.z + m30;
  $$this.y = m01 * $$this.x + m11 * $$this.y + m21 * $$this.z + m31;
  $$this.z = m02 * $$this.x + m12 * $$this.y + m22 * $$this.z + m32;
  return divideScalar($$this, m03 * $$this.x + m13 * $$this.y + m23 * $$this.z + m33);
}

function invert(me) {
  return multiplyScalar(me, -1.0);
}

function getLength(me) {
  return Math.hypot(me.x, me.y, me.z);
}

function normalize(me) {
  return divideScalar(me, getLength(me));
}

export {
  make ,
  set ,
  multiply ,
  multiplyScalar ,
  add ,
  addScalar ,
  subtract ,
  subtractScalar ,
  divide ,
  divideScalar ,
  clone ,
  Ops ,
  copy ,
  distanceTo ,
  dot ,
  cross ,
  lerp ,
  applyMatrix4 ,
  invert ,
  getLength ,
  normalize ,
}
/* No side effect */
