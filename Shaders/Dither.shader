//Bayer Ordered Ultimate Hadoken dithering
Shader "Hidden/Dither" {
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

	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	}

	half nearest(int x, int y, half color) {
		half4x4 dither = {{1.0, 33.0, 9.0, 41.0},
						  {49.0, 17.0, 57.0, 25.0},
						  {13.0, 45.0, 5.0, 37.0},
						  {61.0, 29.0, 53.0, 21.0}};

		half limit = 0.0;

		for(int i = 0; i < 4; i++) {
			for(int j = 0; j < 4; j++) {
				if(x == i && y == j) {
					limit = (dither[i][j]+1.0)/64.0;
					break;
				}
			}
		}

		/*if(color < limit) {
			limit = 0.0;
		}
		else {
			limit = 1.0;
		}*/

		return color + limit;
	}

	half4 frag(v2f i) : COLOR 
	{
		half4 color = tex2D(_MainTex, i.uv);

		int x = (int)fmod(i.uv.x, 4.0);
		int y = (int)fmod(i.uv.y, 4.0);
		
		return half4(
			nearest(x, y, color.r), 
			nearest(x, y, color.g), 
			nearest(x, y, color.b), 1.0);
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