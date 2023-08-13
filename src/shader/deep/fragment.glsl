precision mediump float;
varying vec2 vUv;
 varying float vElevation;
 uniform sampler2D uTexture;
    void main() {
      // 渐变---x  -->
      // float strength = vUv.x;
      // gl_FragColor = vec4(strength, strength, strength, 1.0);
     

     // 渐变---x  <--
      // float strength = 1.0 - vUv.x;
      // gl_FragColor = vec4(strength, strength, strength, 1.0);

     // 渐变---y  上到下
      // float strength = vUv.y;
      // gl_FragColor = vec4(strength, strength, strength, 1.0);

      // 渐变---y  下到上
      // float strength = 1.0 - vUv.y;
      // gl_FragColor = vec4(strength, strength, strength, 1.0);

      // 利用uv实现短范围内渐变
      //  float strength = vUv.y * 10.0;
      //   gl_FragColor =vec4(strength,strength,strength,1);

      //利用通过取模达到反复效果
      float strength = mod(vUv.y * 10.0 , 1.0);
      gl_FragColor =vec4(strength,strength,strength,1);
    }