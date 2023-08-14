precision mediump float;
varying vec2 vUv;
 varying float vElevation;
 uniform sampler2D uTexture;
  uniform float uTime;
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
      // float strength = mod(vUv.y * 10.0 , 1.0);
      // gl_FragColor =vec4(strength,strength,strength,1);

      // float strength = mod(vUv.x * 10.0 , 1.0);
      // gl_FragColor =vec4(strength,strength,strength,1);

      //利用step(edge, x)如果x < edge，返回0.0，否则返回1.0
      // float strength =  mod(vUv.y * 10.0 , 1.0);
      // strength = step(0.6,strength);
      // gl_FragColor =vec4(strength,strength,strength,1);

       //10利用step(edge, x)如果x < edge，返回0.0，否则返回1.0
      // float strength =  mod(vUv.x * 10.0 , 1.0);
      // strength = step(0.8,strength);
      // gl_FragColor =vec4(strength,strength,strength,1);
       
        // 11条纹相加   方格
      //  float strength = step(0.8, mod(vUv.x * 10.0 , 1.0)) ;
      //   strength += step(0.8, mod(vUv.y * 10.0 , 1.0)) ;
      //   gl_FragColor =vec4(strength,strength,strength,1);

        // 12条纹相乘
        // float strength = step(0.8, mod(vUv.x * 10.0 , 1.0));
        // strength *= step(0.8, mod(vUv.y * 10.0 , 1.0));
        // gl_FragColor =vec4(strength,strength,strength,1);

         // 12条纹相减
        // float strength = step(0.8, mod(vUv.x * 10.0 , 1.0));
        // strength -= step(0.8, mod(vUv.y * 10.0 , 1.0));
        // gl_FragColor =vec4(strength,strength,strength,1);

         // 13方块图形
        // float strength = step(0.2, mod(vUv.x * 10.0 , 1.0));
        // strength *= step(0.2, mod(vUv.y * 10.0 , 1.0));
        // gl_FragColor =vec4(strength,strength,strength,1);

        // 14T型图
        // float barX = step(0.4, mod((vUv.x+uTime*0.1) * 10.0 , 1.0))*step(0.8, mod(vUv.y * 10.0 , 1.0)) ;
        // float barX = step(0.4, mod(vUv.x * 10.0 - 0.2 , 1.0))*step(0.8, mod(vUv.y * 10.0 , 1.0)) ;
        // float barY = step(0.4, mod(vUv.y * 10.0 , 1.0))*step(0.8, mod(vUv.x * 10.0 , 1.0));
        // float strength = barX+barY;

        // gl_FragColor =vec4(strength,strength,strength,1);
        // gl_FragColor = vec4(vUv,1,strength);

        //  16 利用绝对值
        // float strength = abs(vUv.x - 0.5) ;
        // gl_FragColor =vec4(strength,strength,strength,1);

        // 17 取2个值的最小值
          float strength =min(abs(vUv.x - 0.5), abs(vUv.y - 0.5));
          gl_FragColor =vec4(strength,strength,strength,1);

          // 18 取最大值
        float strength =max(abs(vUv.x - 0.5), abs(vUv.y - 0.5))  ;
        gl_FragColor =vec4(strength,strength,strength,1);
    }