/*
   Downsamples to 16 colors using quantization.
   Uses 4-bit RGBI values for an "EGA"/"Tandy" look
   
   Author: VileR
   License: public domain
*/

Shader "Hidden/EGAFilter" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
	}
	// Shader code pasted into all further CGPROGRAM blocks
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
	};
	
	sampler2D _MainTex;
	
	// 1.0 is the 'proper' value, 1.2 seems to give better results but brighter
	// colors may clip.
	float color_enhance = 1.2;
	float width;
	float height;
	
	//magic numbers from Bayer
	half genDither(int x, int y)
	{
		half4x4 dither = half4x4(
				 1.0, 33.0,  9.0, 41.0,
				49.0, 17.0, 57.0, 25.0,
				13.0, 45.0,  5.0, 37.0,
				61.0, 29.0, 53.0, 21.0 );

		for(int i = 0; i < 4; i++) {
			for(int j = 0; j < 4; j++) {
				if(i == x && j == y) {
					return (dither[i][j])/64.0;
				}
			}
		}
		return 0.0;
	}

	float dist_sq(half3 a, half3 b) {
		half3 delta = a - b;
		return dot(delta, delta);
	}
	
	// Compare vector distances and return nearest RGBI color
	// fuck cg shader coding
	half3 nearest_rgbi (half3 original) {
	  half min_dst = 4.0;	  
	  half3 ret = half3(1,1,1);
	  
	  half3 pal = half3(0.0,     0.0,     0.0);
	  half dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  pal = half3(0.0,     0.0,     0.66667);
	  dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  pal = half3(0.0,     0.66667, 0.0);
	  dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  pal = half3(0.0,     0.66667, 0.66667);
	  dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  pal = half3(0.66667, 0.0,     0.0);
	  dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  pal = half3(0.66667, 0.0,     0.66667);
	  dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  pal = half3(0.66667, 0.33333, 0.0);
	  dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  pal = half3(0.66667, 0.66667, 0.66667);
	  dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  pal = half3(0.33333, 0.33333, 0.33333);
	  dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  pal = half3(0.33333, 0.33333, 1.0);
	  dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  pal = half3(0.33333, 1.0,     0.33333);
	  dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  pal = half3(0.33333, 1.0,     1.0);
	  dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  pal = half3(1.0,     0.33333, 0.33333);
	  dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  pal = half3(1.0,     0.33333, 1.0);
	  dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  pal = half3(1.0,     1.0,     0.33333);
	  dst = dist_sq(original, pal);
	  if(dst < min_dst) { min_dst = dst; ret = pal; }
	  
	  return ret;
	}

	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	} 
	
	half4 frag(v2f i) : COLOR 
	{
		half3 fragcolor = tex2D(_MainTex, i.uv).rgb;
		
		int x = (int)fmod(i.uv.x * width, 4);
		int y = (int)fmod(i.uv.y * height, 4);
		
		half dither = genDither(x, y);
		
		fragcolor.r = (fragcolor.r + dither)*color_enhance;
		fragcolor.g = (fragcolor.g + dither)*color_enhance;
		fragcolor.b = (fragcolor.b + dither)*color_enhance;
		
		/*fragcolor.r = clamp(fragcolor.r + dither, 0, 1);
		fragcolor.g = clamp(fragcolor.g + dither, 0, 1);
		fragcolor.b = clamp(fragcolor.b + dither, 0, 1);*/
		
		return half4(nearest_rgbi(fragcolor), 1);
	}

	ENDCG 
	
Subshader {
 Pass {
	  ZTest Always Cull Off ZWrite Off
	  Fog { Mode off }      

      CGPROGRAM
	  #pragma target 3.0
      #pragma fragmentoption ARB_precision_hint_fastest 
      #pragma vertex vert
      #pragma fragment frag
      ENDCG
  }
  
}

Fallback off

}
