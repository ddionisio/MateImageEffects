// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/WaveRGB" {
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
	
	float2 amplitudeR; //strength of wave, usu. in fraction
	float2 speedR; //degree per second
	float2 rangeR; //rev per pixel
	
	float2 amplitudeG; //strength of wave, usu. in fraction
	float2 speedG; //degree per second
	float2 rangeG; //rev per pixel
	
	float2 amplitudeB; //strength of wave, usu. in fraction
	float2 speedB; //degree per second
	float2 rangeB; //rev per pixel
	

	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	}
	
	float2 sinPos(float2 uv, float2 amp, float2 spd, float2 rng) {
		return float2(
			(uv).x + sin((uv).y*(rng).y + (spd).x*_Time.y)*(amp).x,
			(uv).y + sin((uv).x*(rng).x + (spd).y*_Time.y)*(amp).y);
	}
	
	half4 frag(v2f i) : COLOR 
	{
		//0.017453292
		float2 posR = sinPos(i.uv, amplitudeR, speedR, rangeR);
		float2 posG = sinPos(i.uv, amplitudeG, speedG, rangeG);
		float2 posB = sinPos(i.uv, amplitudeB, speedB, rangeB);
		
		return half4(tex2D(_MainTex, posR).r, tex2D(_MainTex, posG).g, tex2D(_MainTex, posB).b, 1);
	}

	ENDCG 
	
Subshader {
 Pass {
	  ZTest Always Cull Off ZWrite Off
	  Fog { Mode off }      

      CGPROGRAM
      #pragma fragmentoption ARB_precision_hint_fastest 
	  #pragma target 3.0
      #pragma vertex vert
      #pragma fragment frag
      ENDCG
  }
  
}

Fallback off

}
