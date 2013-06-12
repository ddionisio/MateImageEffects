Shader "Hidden/MonoFilter" {
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

	// 1.0 is the 'proper' value, 1.2 seems to give better results but brighter
	// colors may clip.
	float color_enhance = 1.2;
	
	// Compare vector distances and return nearest RGBI color
	half3 to_mono (half3 original) {
	  //magic
	  half val = floor((0.2125*original.r + 0.7154*original.g + 0.0721*original.b) + 0.5);
	  
	  return val.xxx;
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
		
		return half4(to_mono(fragcolor*color_enhance), 1);
	}

	half4 frag_dither(v2f i) : COLOR 
	{			
		half dither = genDither(i.uv);

		half3 fragcolor = tex2D(_MainTex, i.uv).rgb*color_enhance + dither.xxx;
		
		/*fragcolor.r = clamp(fragcolor.r + dither, 0, 1);
		fragcolor.g = clamp(fragcolor.g + dither, 0, 1);
		fragcolor.b = clamp(fragcolor.b + dither, 0, 1);*/
		
		return half4(to_mono(fragcolor), 1);
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
