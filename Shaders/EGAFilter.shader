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

	// Color lookup table (RGBI palette with brown fix)
	const half3 rgbi_palette[16] = {
	  half3(0.0,     0.0,     0.0),
	  half3(0.0,     0.0,     0.66667),
	  half3(0.0,     0.66667, 0.0),
	  half3(0.0,     0.66667, 0.66667),
	  half3(0.66667, 0.0,     0.0),
	  half3(0.66667, 0.0,     0.66667),
	  half3(0.66667, 0.33333, 0.0),
	  half3(0.66667, 0.66667, 0.66667),
	  half3(0.33333, 0.33333, 0.33333),
	  half3(0.33333, 0.33333, 1.0),
	  half3(0.33333, 1.0,     0.33333),
	  half3(0.33333, 1.0,     1.0),
	  half3(1.0,     0.33333, 0.33333),
	  half3(1.0,     0.33333, 1.0),
	  half3(1.0,     1.0,     0.33333),
	  half3(1.0,     1.0,     1.0)
	};

	// Compare vector distances and return nearest RGBI color
	half3 nearest_rgbi (half3 original) {
	  half dst;
	  half min_dst = 2.0;
	  
	  half3 ret;

	  for (int i=0; i<16; i++) {
		dst = distance(original, rgbi_palette[i]);
		if (dst < min_dst) {
		  min_dst = dst;
		  ret = rgbi_palette[i];
		}
	  }
	  
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
		return half4(nearest_rgbi(fragcolor*color_enhance), 1);
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
