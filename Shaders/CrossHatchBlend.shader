Shader "Hidden/CrossHatchBlend" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
	}
	// Shader code pasted into all further CGPROGRAM blocks
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
		float2 screenPos : TEXCOORD1;
	};
	
	sampler2D _MainTex;
	uniform float4 _MainTex_TexelSize;
	
	half4 lineColor;
	half4 paperColor;
	half fill;
	half lineDist;//10
	half lineThickness; //1
	half lumThreshold1; //1
	half lumThreshold2; //0.7
	half lumThreshold3; //0.5
	half lumThreshold4; //0.3
	half lumThreshold5; //0
	
	half mod(half x, half y) {
		return x - y*floor(x/y);
	}

	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		float4 sp = ComputeScreenPos(o.pos);
		o.screenPos = _ScreenParams.xy*(sp.xy/sp.w);
		return o;
	} 
	
	half4 frag(v2f i) : COLOR 
	{
		half3 tc = tex2D(_MainTex, i.uv).rgb;
		
		half lum = tc.r*0.2126 + tc.g*0.7152 + tc.b*0.0722;
		tc = half3(1,1,1);
		half ld2 = lineDist*2;
		float2 pix = i.screenPos;
		
		if(lum < lumThreshold1) {
			if(mod(pix.x + pix.y, 10) <= 1)
				tc = half4(lerp(tc, lineColor.rgb, lineColor.a), 1);
		}
		if(lum < lumThreshold2) {
			if(mod(pix.x - pix.y, 10) <= 1)
				tc = half4(lerp(tc, lineColor.rgb, lineColor.a), 1);
		}
		if(lum < lumThreshold3) {
			if(mod(pix.x + pix.y - 5, 10) <= 1)
				tc = half4(lerp(tc, lineColor.rgb, lineColor.a), 1);
		}
		if(lum < lumThreshold4) {
			if(mod(pix.x - pix.y - 5, 10) <= 1)
				tc = half4(lerp(tc, lineColor.rgb, lineColor.a), 1);
		}
		
		
		return half4(tc,1);
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
