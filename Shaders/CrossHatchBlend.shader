// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

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
	half lineDist;//10
	half lineThickness; //1
	half lumThreshold1; //1
	half lumThreshold2; //0.7
	half lumThreshold3; //0.5
	half lumThreshold4; //0.3
	
	half lineStrength1; //1
	half lineStrength2; //0.7
	half lineStrength3; //0.5
	half lineStrength4; //0.3
	
	float d; //1
	
	half lookup(float2 p, float dx, float dy) {
		float2 uv = (p.xy + float2(dx*d, dy*d)) / _ScreenParams.xy;
		float4 c = tex2D(_MainTex, uv);
		return c.r*0.2126 + c.g*0.7152 + c.b*0.0722;
	}
	
	half mod(half x, half y) {
		return x - y*floor(x/y);
	}

	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		float4 sp = ComputeScreenPos(o.pos);
		o.screenPos = _ScreenParams.xy*(sp.xy/sp.w);
		return o;
	} 
	
	half4 frag(v2f i) : COLOR 
	{
		half3 tc = tex2D(_MainTex, i.uv).rgb;
		
		half lum = tc.r*0.2126 + tc.g*0.7152 + tc.b*0.0722;
		
		half hld = lineDist*0.5;
		float2 pix = i.screenPos;
		half linePixel = 0;
		
		if(lum < lumThreshold1) {
			if(mod(pix.x + pix.y, lineDist) <= lineThickness)
				linePixel = lineStrength1;
		}
		if(lum < lumThreshold2) {
			if(mod(pix.x - pix.y, lineDist) <= lineThickness)
				linePixel = lineStrength2;
		}
		if(lum < lumThreshold3) {
			if(mod(pix.x + pix.y - hld, lineDist) <= lineThickness)
				linePixel = lineStrength3;
		}
		if(lum < lumThreshold4) {
			if(mod(pix.x - pix.y - hld, lineDist) <= lineThickness)
				linePixel = lineStrength4;
		}
		
		//sobel edge detect
		half gx = 0;
		gx += -1 * lookup(pix, -1, -1);
		gx += -2 * lookup(pix, -1,  0);
		gx += -1 * lookup(pix, -1,  1);
		gx +=  1 * lookup(pix,  1, -1);
		gx +=  2 * lookup(pix,  1,  0);
		gx +=  1 * lookup(pix,  1,  1);
		
		half gy = 0;
		gy += -1 * lookup(pix, -1, -1);
		gy += -2 * lookup(pix,  0, -1);
		gy += -1 * lookup(pix,  1, -1);
		gy +=  1 * lookup(pix, -1,  1);
		gy +=  2 * lookup(pix,  0,  1);
		gy +=  1 * lookup(pix,  1,  1);
		
		half g = gx*gx + gy*gy;
		linePixel = min(linePixel+g, 1);
		
		half3 lc = lerp(tc, lineColor.rgb, lineColor.a);
		half3 pc = lerp(tc, paperColor.rgb, paperColor.a);
		half4 clr = half4(lerp(pc, lc, linePixel), 1);
		
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
