Shader "M8/Translucency/Wave" {
    Properties {
    	ampX("Amplitude X", Float) = 0
    	ampY("Amplitude Y", Float) = 0.01
    	spdX("Speed X", Float) = 0
    	spdY("Speed Y", Float) = 1
    	rngX("Range X", Float) = 64
    	rngY("Range Y", Float) = 0
    	overlay("Overlay", Float) = 0.25
	}
	
    SubShader {

        // Draw ourselves after all opaque geometry
        Tags { "Queue" = "Transparent" }

        // Grab the screen behind the object into _GrabTexture
        GrabPass { }

        // Render the object with the texture generated above
        Pass {
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag 
			//#pragma target 3.0

            sampler2D _GrabTexture : register(s0);
            float ampX; //strength of wave, usu. in fraction
            float ampY; //strength of wave, usu. in fraction
			float spdX; //degree per second
			float spdY; //degree per second
			float rngX; //rev per pixel
			float rngY; //rev per pixel
			float overlay;

			struct data {
			    float4 vertex : POSITION;
			    float3 normal : NORMAL;
			};

			struct v2f {
			    float4 position : POSITION;
			    float4 projPos : TEXCOORD0;
			};

			 v2f vert(data i) {
			    v2f o;
			    o.position = mul(UNITY_MATRIX_MVP, i.vertex);
			    o.projPos = ComputeGrabScreenPos(o.position);
			    return o;
			}

			half4 frag( v2f i ) : COLOR {
				float2 screenPos = i.projPos.xy/i.projPos.w;
				float2 wavePos = half2(
					screenPos.x + sin(screenPos.y*rngY + spdX*_Time.y)*ampX,
					screenPos.y + sin(screenPos.x*rngX + spdY*_Time.y)*ampY);
				
				return lerp(tex2D(_GrabTexture, screenPos), tex2D(_GrabTexture, wavePos), overlay);
			}
			ENDCG
        }
    }

Fallback Off
} 