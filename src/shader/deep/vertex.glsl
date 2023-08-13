
uniform mat4 projectionMatrix;
    uniform mat4 viewMatrix;
    uniform mat4 modelMatrix;
    precision lowp float;
    attribute vec3 position;
    attribute vec2 uv;
    varying vec2 vUv;

    varying float vElevation;
   uniform float uTime;
   uniform vec2 uFrequency;
    void main() {
        vUv = uv;
        vec4 modelPosition = modelMatrix * vec4(position, 1.0);
        //  modelPosition.z += sin((modelPosition.x + uTime) * 10.0) * 0.03;
        //  modelPosition.z += sin((modelPosition.y + uTime) * 10.0) * 0.03;
        vElevation = modelPosition.z;
         gl_Position = projectionMatrix * viewMatrix * modelPosition;
    }