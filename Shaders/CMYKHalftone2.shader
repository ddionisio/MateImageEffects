Shader "Hidden/CMYKHalftone2" {
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
	
	//float sst;//0.888
	//float ssq;//0.288
	#define sst 0.888
	#define ssq 0.288
	
	float dotSize; //1.48
	float _s; //scale
	float _r; //rotate (radians)
	float4 _clrR; //rotation of each color (c,m,y,k) default: (15,75,0,45) convert these to radians!
	
	float4 rgb2cmyki(float4 c)
	{
		float k = max(max(c.r,c.g),c.b);
		return min(float4(c.rgb/k,k),float4(1.0,1.0,1.0,1.0));
	}

	float4 cmyki2rgb(float4 c)
	{
		return float4(c.rgb*c.a,1.0);
	}

	float2 grid(float2 px, float dotS)
	{
		//return px-fmod(px,dotS);
		return floor(px/dotS)*dotS; // alternate
	}

	float4 ss(float4 v)
	{
		return smoothstep(sst-ssq,sst+ssq,v);
	}

	float4 halftone(float2 fc,float2x2 m)
	{
		float dotS = _s/_ScreenParams.y;
		
		float2 smp = mul(grid(mul(m,fc),dotS)+0.5*dotS, m);
		float s = min(length(fc-smp)/(dotSize*0.5*dotS),1.0);
		float4 c = rgb2cmyki(tex2D(_MainTex,smp+float2(0.5,0.5)));
		return c+s;
	}

	float2x2 rotm(float r)
	{
		float cr = cos(r);
		float sr = sin(r);
		return float2x2(
			cr,-sr,
			sr,cr
		);
	}
	
	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	} 
	
	float4 frag(v2f i) : COLOR 
	{
		float2 fc = i.uv-float2(0.5,0.5);
		
		float2x2 mc = rotm(_r+_clrR.x);
		float2x2 mm = rotm(_r+_clrR.y);
		float2x2 my = rotm(_r+_clrR.z);
		float2x2 mk = rotm(_r+_clrR.w);
		
		//float k = halftone(fc,mk).a;
		
		return cmyki2rgb(ss(float4(
			halftone(fc,mc).r,
			halftone(fc,mm).g,
			halftone(fc,my).b,
			halftone(fc,mk).a
		)));
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
