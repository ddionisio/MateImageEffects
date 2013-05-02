Shader "Hidden/Quantize" {
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
	
	int levels = 16;

	float width;
	float height;

	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	}

	//magic numbers from Bayer
	half genDither(int x, int y)
	{
		half4x4 dither = half4x4(
				 1.0, 9.0,  3.0, 11.0,
				13.0, 5.0, 15.0, 7.0,
				4.0, 12.0,  2.0, 10.0,
				16.0, 8.0, 14.0, 6.0 );

		for(int i = 0; i < 4; i++) {
			for(int j = 0; j < 4; j++) {
				if(i == x && j == y) {
					return (dither[i][j])/17.0;
				}
			}
		}
		return 0.0;
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

		int x = (int)fmod(i.uv.x * width, 4);
		int y = (int)fmod(i.uv.y * height, 4);
		
				
		half dither = genDither(x, y);

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