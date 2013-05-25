Shader "Hidden/Wave" {
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
	float amplitudeX;
	float amplitudeY;
	float speedX;
	float speedY;
	float rangeX; //
	float rangeY; //rev per pixel

	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	} 
	
	half4 frag(v2f i) : COLOR 
	{
		//0.017453292
		float2 pos = half2(
			i.uv.x + sin(i.uv.y*rangeY + speedX*_Time.y)*amplitudeX,
			i.uv.y + sin(i.uv.x*rangeX + speedY*_Time.y)*amplitudeY);
		
		return tex2D(_MainTex, pos);
	}

	ENDCG 
	
Subshader {
 Pass {
	  ZTest Always Cull Off ZWrite Off
	  Fog { Mode off }      

      CGPROGRAM
      #pragma fragmentoption ARB_precision_hint_fastest 
      #pragma vertex vert
      #pragma fragment frag
      ENDCG
  }
  
}

Fallback off

}
