precision mediump float;
varying vec2 vUv;
 varying float vElevation;
 uniform sampler2D uTexture;
  uniform float uTime;
#define PI 3.1415926535897932384626433832795
 // 随机函数
float random (vec2 st) {
    return fract(sin(dot(st.xy,vec2(12.9898,78.233)))*43758.5453123);
} 

// 旋转函数
vec2 rotate(vec2 uv, float rotation, vec2 mid)
{
    return vec2(
      cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x,
      cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y
    );
}
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
          // float strength =min(abs(vUv.x - 0.5), abs(vUv.y - 0.5));
          // gl_FragColor =vec4(strength,strength,strength,1);

          // 18 取最大值
        // float strength =max(abs(vUv.x - 0.5), abs(vUv.y - 0.5))  ;
        // gl_FragColor =vec4(strength,strength,strength,1);

        // 19 step
        // float strength =step(0.2,max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)))   ;
        // gl_FragColor =vec4(strength,strength,strength,1);

        // 20 小正方形
        // float strength =1.0-step(0.2,max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)))   ;
        // gl_FragColor =vec4(strength,strength,strength,1);

         // 21 利用取整，实现条纹渐变
        // float strength = floor(vUv.x*10.0)/10.0;
        // gl_FragColor =vec4(strength,strength,strength,1);

         // 22 实现渐变格子
        // float strength = floor(vUv.x*10.0)/10.0 * floor(vUv.y*10.0)/10.0;
        // gl_FragColor =vec4(strength,strength,strength,1);
         // 23 实现渐变格子
        // float strength = ceil(vUv.x*10.0)/10.0 * ceil(vUv.y*10.0)/10.0;
        // gl_FragColor =vec4(strength,strength,strength,1);
        
        // 24随机效果
        // float strength = random(vUv);
        // gl_FragColor =vec4(strength,strength,strength,1);

        // 24随机+格子效果
        // float strength = ceil(vUv.x*10.0)/10.0*ceil(vUv.y*10.0)/10.0;
        // strength = random(vec2(strength,strength));
        // gl_FragColor =vec4(strength,strength,strength,1);

        // 25 依据length返回向量长度
        // float strength = length(vUv);
        // gl_FragColor =vec4(strength,strength,strength,1);

         // 26 根据distance技术2个向量的距离
        // float strength = distance(vUv,vec2(0.5,0.5));
        // gl_FragColor =vec4(strength,strength,strength,1);

          // 27根据相除，实现星星 
        // float strength = 0.1 / distance(vUv,vec2(0.5,0.5)) - 1.0;
        // gl_FragColor =vec4(strength,strength,strength,strength);

        // 28设置vUv水平或者竖直变量
        // float strength =0.15 / distance(vec2(vUv.x,(vUv.y-0.5)*5.0),vec2(0.5,0.5)) - 1.0;
        // gl_FragColor =vec4(strength,strength,strength,strength);

        // 29十字交叉的星星

        // float  strength = 0.15 / distance(vec2(vUv.x,(vUv.y-0.5)*5.0+0.5),vec2(0.5,0.5)) - 1.0;
        // strength *= 0.15 / distance(vec2(vUv.y,(vUv.x-0.5)*5.0+0.5),vec2(0.5,0.5)) - 1.0;
        // gl_FragColor =vec4(strength,strength,strength,strength);

        // 30  旋转
        // vec2 rotateUv = rotate(vUv,-uTime,vec2(0.5));
        // float strength = 0.15 / distance(vec2(rotateUv.x,(rotateUv.y-0.5)*5.0+0.5),vec2(0.5,0.5)) - 1.0;
        // strength += 0.15 / distance(vec2(rotateUv.y,(rotateUv.x-0.5)*5.0+0.5),vec2(0.5,0.5)) - 1.0;
        // gl_FragColor =vec4(strength,strength,strength,strength);

        // 30小日本国旗
      // float strength = step(0.5,distance(vUv,vec2(0.5))+0.25) ;
      // gl_FragColor =vec4(strength,strength,strength,1);

      // 31绘制圆
      // float strength = 1.0 - step(0.5,distance(vUv,vec2(0.5))+0.25) ;
      // gl_FragColor =vec4(strength,strength,strength,1);

       // 32绘制圆环
      // float strength = step(0.5,distance(vUv,vec2(0.5))+0.35);
      // strength *= 1.0 - step(0.5,distance(vUv,vec2(0.5))+0.25);
      // gl_FragColor =vec4(strength,strength,strength,1);

      // 34渐变环
    // float strength =  abs(distance(vUv,vec2(0.5))-0.25) ;
    // gl_FragColor =vec4(strength,strength,strength,1);

    // 35  打靶环
        // float strength = step(0.1, abs(distance(vUv,vec2(0.5)) - 0.25)) ;
        //     strength += 1.0 - step(0.1, abs(distance(vUv,vec2(0.5)) - 0.35)) ;
        // gl_FragColor =vec4(strength,strength,strength,1);

      // 36圆环
        // float strength = 1.0 - step(0.1,abs(distance(vUv,vec2(0.5))-0.25))   ;
        // gl_FragColor =vec4(strength,strength,strength,1);

        // 37波浪环
        // vec2 waveUv = vec2(
        //     vUv.x,
        //     vUv.y+sin(vUv.x*30.0)*0.1
        // );
        // float strength = 1.0 - step(0.01,abs(distance(waveUv,vec2(0.5))-0.25))   ;
        // gl_FragColor =vec4(strength,strength,strength,1);

        // 38
      // vec2 waveUv = vec2(
      //     vUv.x+sin(vUv.y*30.0)*0.1,
      //     vUv.y+sin(vUv.x*30.0)*0.1
      // );
      // float strength = 1.0 - step(0.01,abs(distance(waveUv,vec2(0.5))-0.25))   ;
      // gl_FragColor =vec4(strength,strength,strength,1);
    
    // 39
    // vec2 waveUv = vec2(
    //     vUv.x+sin(vUv.y*100.0)*0.1,
    //     vUv.y+sin(vUv.x*100.0)*0.1
    // );
    // float strength = 1.0 - step(0.01,abs(distance(waveUv,vec2(0.5))-0.25))   ;
    // gl_FragColor =vec4(strength,strength,strength,1);

      // 40 根据角度显示视图
    // float angle = atan(vUv.x,vUv.y);
    // float strength = angle;
    // gl_FragColor =vec4(strength,strength,strength,1);

     // 41 根据角度实现螺旋渐变
    // float angle = atan(vUv.x-0.5,vUv.y-0.5);
    // float strength = (angle+3.14)/6.28;
    // gl_FragColor =vec4(strength,strength,strength,1);

    // 42 实现雷达扫射
    
    // float alpha =  1.0 - step(0.5,distance(vUv,vec2(0.5)));
    // float angle = atan(vUv.x-0.5,vUv.y-0.5);
    // float strength = (angle+3.14)/6.28;
    // gl_FragColor =vec4(strength,strength,strength,alpha);

    // 43 通过时间实现动态选择
    // vec2 rotateUv = rotate(vUv,-uTime*5.0,vec2(0.5));
    // float alpha =  1.0 - step(0.5,distance(vUv,vec2(0.5)));
    // float angle = atan(rotateUv.x-0.5,rotateUv.y-0.5);
    // float strength = (angle+3.14)/6.28;
    // gl_FragColor =vec4(strength,strength,strength,alpha);

     // 44 万花筒
      // float angle = atan(vUv.x-0.5,vUv.y-0.5)/PI;
      // float strength = mod(angle*10.0,1.0);
      
      // gl_FragColor =vec4(strength,strength,strength,1);

        // 45 光芒四射
    float angle = atan(vUv.x-0.5,vUv.y-0.5)/(2.0*PI);
    float strength = sin(angle*100.0);
    gl_FragColor =vec4(strength,strength,strength,1);
    }