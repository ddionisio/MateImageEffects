//TODO: figure out luminance image so it's only one value
Shader "Hidden/Dither" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
		_DitherTex("Base (RGB)", 2D) = "" {}
	}
	// Shader code pasted into all further CGPROGRAM blocks
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
	};
	
	sampler2D _MainTex;
	sampler2D _DitherTex;

	int levels = 64;
	
	//float strength; //make sure it is in uniform value [0, 1]
	int strength = 50;
	float ditherSizeW = 1.0; //make sure it is in uniform value [0, 1] based in screen size: e.g. [16/1280, 16/720]
	float ditherSizeH = 1.0;

	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	}

	int ditherValue(float2 loc) {
		int v = tex2D(_DitherTex, fmod(loc, float2(ditherSizeW, ditherSizeH))).r*255.0;
		return (v*strength + 127) / 255;
	}

	half doIt(half clr, int dither) {
		int c = (clr*255.0) + dither;

		c = (((c * levels + 127) / 255) * 255 + levels / 2) / levels;

		return c / 255.0;
	}

	half4 frag(v2f i) : COLOR 
	{
		half4 color = tex2D(_MainTex, i.uv);
		int ditherVal = ditherValue(i.uv);

		return half4(clamp(doIt(color.r, ditherVal), 0.0, 1.0), clamp(doIt(color.g, ditherVal), 0.0, 1.0), clamp(doIt(color.b, ditherVal), 0.0, 1.0), 1.0);
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