Shader "Hidden/Palette16Filter" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
	}
	// Shader code pasted into all further CGPROGRAM blocks
	CGINCLUDE
	
	#include "UnityCG.cginc"
	#include "Dither.cginc"
	
	struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
	};
	
	sampler2D _MainTex;

	half3 palette0;
	half3 palette1;
	half3 palette2;
	half3 palette3;
	half3 palette4;
	half3 palette5;
	half3 palette6;
	half3 palette7;
	half3 palette8;
	half3 palette9;
	half3 palette10;
	half3 palette11;
	half3 palette12;
	half3 palette13;
	half3 palette14;
	half3 palette15;

	// 1.0 is the 'proper' value, 1.2 seems to give better results but brighter
	// colors may clip.
	float color_enhance = 1.2;

	float dist_sq(half3 a, half3 b) {
		half3 delta = a - b;
		return dot(delta, delta);
	}
	
	// Compare vector distances and return nearest RGBI color
	half3 nearest_rgbi (half3 original) {
	  half min_dst = 4.0;	  
	  half3 ret = palette0;
	  
	  half dst = dist_sq(original, palette1);
	  if(dst < min_dst) { min_dst = dst; ret = palette1; }
	  
	  dst = dist_sq(original, palette2);
	  if(dst < min_dst) { min_dst = dst; ret = palette2; }

	  dst = dist_sq(original, palette3);
	  if(dst < min_dst) { min_dst = dst; ret = palette3; }

	  dst = dist_sq(original, palette4);
	  if(dst < min_dst) { min_dst = dst; ret = palette4; }

	  dst = dist_sq(original, palette5);
	  if(dst < min_dst) { min_dst = dst; ret = palette5; }

	  dst = dist_sq(original, palette6);
	  if(dst < min_dst) { min_dst = dst; ret = palette6; }

	  dst = dist_sq(original, palette7);
	  if(dst < min_dst) { min_dst = dst; ret = palette7; }

	  dst = dist_sq(original, palette8);
	  if(dst < min_dst) { min_dst = dst; ret = palette8; }

	  dst = dist_sq(original, palette9);
	  if(dst < min_dst) { min_dst = dst; ret = palette9; }

	  dst = dist_sq(original, palette10);
	  if(dst < min_dst) { min_dst = dst; ret = palette10; }

	  dst = dist_sq(original, palette11);
	  if(dst < min_dst) { min_dst = dst; ret = palette11; }

	  dst = dist_sq(original, palette12);
	  if(dst < min_dst) { min_dst = dst; ret = palette12; }

	  dst = dist_sq(original, palette13);
	  if(dst < min_dst) { min_dst = dst; ret = palette13; }

	  dst = dist_sq(original, palette14);
	  if(dst < min_dst) { min_dst = dst; ret = palette14; }

	  dst = dist_sq(original, palette15);
	  if(dst < min_dst) { min_dst = dst; ret = palette15; }
	  
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

	half4 frag_dither(v2f i) : COLOR 
	{			
		half dither = genDither(i.uv);

		half3 fragcolor = tex2D(_MainTex, i.uv).rgb*color_enhance + dither.xxx;
		
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

  Pass {
	  ZTest Always Cull Off ZWrite Off
	  Fog { Mode off }      

      CGPROGRAM
	  #pragma target 3.0
      #pragma fragmentoption ARB_precision_hint_fastest 
      #pragma vertex vert
      #pragma fragment frag_dither
      ENDCG
  }
}

Fallback off

}
