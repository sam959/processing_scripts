#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform float col;

varying vec4 vertColor;
varying vec4 vertTexCoord;

vec4 originalColor;

vec3 hueShift(vec3 color, float hueAdjust, float saturation){
    //implemented by mairod
    vec3 kRGBToYPrime = vec3 (0.299, 0.587, 0.114);
    vec3 kRGBToI = vec3(0.596, -0.275, -0.321);
    vec3 kRGBToQ = vec3(0.212, -0.523, 0.311);
    vec3 kYIQToR = vec3(1.0, 0.956, 0.621);
    vec3 kYIQToG = vec3(1.0, -0.272, -0.647);
    vec3 kYIQToB = vec3(1.0, -1.107, 1.704);
    float YPrime = dot(color, kRGBToYPrime);
    float I = dot(color, kRGBToI);
    float Q = dot(color, kRGBToQ); 
    float hue2 = atan(Q, I);
    float chroma = sqrt(I * I + Q * Q)*saturation;
    hue2 += hueAdjust*6.28319;
    Q = chroma * sin(hue2);
    I = chroma * cos(hue2);
    vec3 yIQ = vec3(YPrime, I, Q);
    
    return vec3(dot(yIQ, kYIQToR), dot(yIQ, kYIQToG), dot(yIQ, kYIQToB));

}


void main() {

//HUESHIFT
 originalColor = texture2D(texture, vertTexCoord.xy);
  //gl_FragColor = texture2D(texture, vertTexCoord.xy) * vec4(col, col, 0.5, 1);
    gl_FragColor = texture2D(texture, vertTexCoord.xy);

  //gl_FragColor = vec4(hueShift(originalColor.xyz, col, 1.0), 1.0);

}