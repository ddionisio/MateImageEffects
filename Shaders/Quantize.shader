// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Quantize" {
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
	
	int levels = 16;
	
	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	}

	half quantize(half c)
	{
		int val = c*255.0;
		val = (((val * levels + 127) / 255) * 255 + levels / 2) / levels;
		return val / 255.0;
	} 
	
	half4 frag(v2f i) : COLOR 
	{
		half3 color = tex2D(_MainTex, i.uv);

		return half4(quantize(color.r), quantize(color.g), quantize(color.b), 1);
	}

	half4 frag_dithered(v2f i) : COLOR
	{
		half3 color = tex2D(_MainTex, i.uv);

		half dither = genDither(i.uv);

		return half4(quantize(color.r + dither), quantize(color.g + dither), quantize(color.b + dither), 1);
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
      #pragma fragment frag_dithered
      ENDCG
  }
  
  
}

Fallback off

}