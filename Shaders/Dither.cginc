sampler2D _DitherTex; //make sure texture is set to repeating and point sample

float ditherStepX; //render.w/dither.w
float ditherStepY; //render.h/dither.h
half ditherAdjustThreshold; //value/255

#define genDither(pos) (tex2D(_DitherTex, (pos)*float2(ditherStepX, ditherStepY)).r + ditherAdjustThreshold)