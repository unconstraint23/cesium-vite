precision mediump float;
varying vec2 vUv;
varying vec4 vPosition;
varying vec4 gPosition;
    void main() {
        vec4 redColor = vec4(1,0,0,1);
    vec4 yellowColor = vec4(1,1,0.5,1);
    vec4 mixColor = mix(yellowColor,redColor,gPosition.y/3.0);
    // gl_FrontFacing gl_FrontFacing变量是一个布尔值，如果当前片段是正面的一部分那么就是true，否则就是false。
    if(gl_FrontFacing) {
     gl_FragColor = vec4(mixColor.xyz-(vPosition.y-20.0)/80.0-0.1,1);
    } else {
      gl_FragColor = vec4(mixColor.xyz,1);
    }
    }