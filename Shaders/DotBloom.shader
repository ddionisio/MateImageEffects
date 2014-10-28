/*
 *    Dot 'n bloom shader
 *    Author: Themaister
 *    License: Public domain
 *
 *    Direct3D port by gulikoza at users.sourceforge.net
 *
 */
Shader "Hidden/DotBloom" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
	}
	// Shader code pasted into all further CGPROGRAM blocks
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
		float2 pixel_no	: TEXCOORD1;
		float2 pixel_s	: TEXCOORD2;
	};
	
	sampler2D _MainTex;
	uniform float4 _MainTex_TexelSize;
	
	float gamma = 2.4;
	float shine = 0.05;
	float blend = 0.65;

	float dist(float2 coord, float2 source)
    {
        float2 delta = coord - source;
        return sqrt(dot(delta, delta));
    }

    float color_bloom(float3 color)
    {
        const float3 gray_coeff = float3(0.30, 0.59, 0.11);
        float bright = dot(color, gray_coeff);
        return lerp(1.0 + shine, 1.0 - shine, bright);
    }

    float3 lookup(float2 offset, float2 coord, float2 pixel_no)
    {
        float3 color = tex2D(_MainTex, coord).rgb;
        float delta = dist(frac(pixel_no), offset + float2(0.5, 0.5));
        return color * exp(-gamma * delta * color_bloom(color));
    }

	#define OFFSET(c)		c, i.uv + (c * i.pixel_s), i.pixel_no
	
	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		o.pixel_no = v.texcoord * _MainTex_TexelSize.zw;
		o.pixel_s = _MainTex_TexelSize.xy;
		return o;
	} 
	
	half4 frag(v2f i) : COLOR 
	{
		float3 color = float3(0.0, 0.0, 0.0);
        float3 mid_color = lookup(OFFSET(float2(0.0, 0.0)));

        color += lookup(OFFSET(float2(-1.0, -1.0)));
        color += lookup(OFFSET(float2( 0.0, -1.0)));
        color += lookup(OFFSET(float2( 1.0, -1.0)));
        color += lookup(OFFSET(float2(-1.0,  0.0)));
        color += mid_color;
        color += lookup(OFFSET(float2( 1.0,  0.0)));
        color += lookup(OFFSET(float2(-1.0,  1.0)));
        color += lookup(OFFSET(float2( 0.0,  1.0)));
        color += lookup(OFFSET(float2( 1.0,  1.0)));

        float3 out_color = lerp(1.2 * mid_color, color, blend);

		return half4(out_color, 1.0);
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
