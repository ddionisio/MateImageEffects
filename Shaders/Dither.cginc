sampler2D _DitherTex; //make sure texture is set to repeating

float ditherStepX; //render.w/dither.w
float ditherStepY; //render.h/dither.h
float ditherMaxThreshold; //(255/value), value = highest value from dither texture + 1, e.g. 65 for 8x8 bayer

#define genDither(pos) (tex2D(_DitherTex, (pos)*float2(ditherStepX, ditherStepY)).r*ditherMaxThreshold)