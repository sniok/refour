let dict = (key, value) => {
  let dict = Dict.make()
  dict->Dict.set(key, value)
  dict
}

let make = (~color: Color.t) =>
  Material.make(
    ~uniforms=dict("color", Material.Array(color->Color.toArray)),
    ~vertex=`#version 300 es
    uniform mat4 normalMatrix;
    uniform mat4 projectionMatrix;
    uniform mat4 modelViewMatrix;
    in vec3 position;
    in vec3 normal;
    out vec3 vNormal;

    void main() {
      vNormal = (normalMatrix * vec4(normal, 0)).xyz;
      gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    }
  `,
    ~fragment=`#version 300 es
    precision lowp float;

    uniform vec3 color;
    in vec3 vNormal;
    out vec4 pc_fragColor;

    void main() {
      float lighting = dot(vNormal, normalize(vec3(10)));
      pc_fragColor = vec4(color + lighting * 0.1, 1.0);
    }
  `,
  )
