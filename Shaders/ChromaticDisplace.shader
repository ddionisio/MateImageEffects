// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/ChromaticDisplace" {
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
	uniform float4 _MainTex_TexelSize;
	
	half displace;

	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	} 
	
	half4 frag(v2f i) : COLOR 
	{
		half2 pos = (i.uv - 0.5)*2.0;
		half magSq = dot(pos, pos);
		half2 ofs = displace*magSq*pos;
		half2 uvR = i.uv - _MainTex_TexelSize.xy*ofs;
		half2 uvB = i.uv + _MainTex_TexelSize.xy*ofs;
		half4 clr = half4(tex2D(_MainTex, uvR).r,tex2D(_MainTex, i.uv).g,tex2D(_MainTex, uvB).b,1);
		return clr;
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
