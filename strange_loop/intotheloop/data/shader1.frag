#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform float col;

float in1; 
float in2;
uniform float dispY;
uniform float dispX;

varying vec4 vertColor;
varying vec4 vertTexCoord;

vec4 originalColor;
vec3 invert;


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
vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {

  //NEGATIVE
	//originalColor = texture2D(texture, vertTexCoord.xy+vec2(dispX,dispY));
  originalColor = texture2D(texture, vertTexCoord.xy);

  in1 =  0.1;
  in2 = 0.1;
  invert = rgb2hsv(originalColor.xyz);


	invert.z = 1.0 - invert.z+in1;
	invert.x = 1.0 - invert.x+in2;

	gl_FragColor = vec4(invert, 1.0);

		
  // WORKS
  //gl_FragColor = vec4(hsv2rgb(invert), 1.0); // crazy color blocks
  //gl_FragColor = vec4(hueShift(originalColor.xyz, col, 1.0), 1.0);
  //gl_FragColor = originalColor;
  //gl_FragColor = originalColor* vec4(col, col, 0.5, 1);
  //gl_FragColor = texture2D(texture, vertTexCoord.xy);
}