#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform float frequency;
uniform float angularVelocity;

void main() {
  float pos =  (vertTexCoord.x + vertTexCoord.y) * frequency;

  //float sine = sin(mod((pos + angularVelocity), 1.0)* 6.283);
  float dx = (6.283 / 50) * 1;

  float sine = sin(angularVelocity);
  gl_FragColor = vec4(vertTexCoord.x + sine,0.0,0.0,1.0);

}