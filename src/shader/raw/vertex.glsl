
uniform mat4 projectionMatrix;
    uniform mat4 viewMatrix;
    uniform mat4 modelMatrix;
    precision mediump float;
    attribute vec3 position;
    attribute vec2 uv;
    varying vec2 vUv;

    varying float vElevation;
   
    void main() {
        vUv = uv;
        vec4 modelPosition = modelMatrix * vec4(position, 1.0);
         modelPosition.z += sin(modelPosition.x * 10.0) * 0.05;
         modelPosition.z += sin(modelPosition.y * 10.0) * 0.05;
        vElevation = modelPosition.z;
         gl_Position = projectionMatrix * viewMatrix * modelPosition;
    }