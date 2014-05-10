
precision highp float;

uniform sampler2D positionTexture;
uniform sampler2D octreeTexture;
uniform float size;
uniform float slicesPerRow;
uniform float numRows;
uniform float lod;

attribute vec2 coords;

varying vec3 vColor;

vec2 computeSliceOffset(float slice, vec2 sliceSize) {
  return sliceSize * vec2(mod(slice, slicesPerRow),
                          floor(slice / slicesPerRow));
}

vec2 getCellCoords(vec3 texCoord) {
  texCoord = (texCoord + 1.) * .5;
  float slice   = texCoord.z * size;
  float sliceZ  = floor(slice);                         // slice we need

  vec2 sliceSize = vec2(1.0 / slicesPerRow,             // u space of 1 slice
                      1.0 / numRows);                 // v space of 1 slice

  vec2 slice0Offset = computeSliceOffset(sliceZ, sliceSize);

  vec2 slicePixelSize = sliceSize / size;               // space of 1 pixel
  vec2 sliceInnerSize = slicePixelSize * (size - 1.0);  // space of size pixels

  vec2 uv = slicePixelSize * 0.5 + texCoord.xy * sliceInnerSize;
  return slice0Offset + uv;
}

vec4 sampleOctree(vec3 position) {
  return vec4(0.);
}

void main() {
  vec3 pos = texture2D(positionTexture, coords).xyz;
  vec2 oCoords = getCellCoords(pos);
  vColor = texture2DLod(octreeTexture, oCoords, lod).xyz;
  // vColor = pos;
  gl_PointSize = 4.;
  // gl_Position = vec4(coords * 2. - 1., 0.0, 1.0);
  gl_Position = vec4(pos, 1.0);
}
