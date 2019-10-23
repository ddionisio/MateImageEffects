// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "M8/Translucency/Invert" {
    Properties {
	}
	
    SubShader {

        // Draw ourselves after all opaque geometry
        Tags {"Queue"="Transparent+1"}

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
			    o.position = UnityObjectToClipPos(i.vertex);
			    o.projPos = ComputeGrabScreenPos(o.position);
			    return o;
			}

			half4 frag( v2f i ) : COLOR {
				float2 screenPos = i.projPos.xy/i.projPos.w;
				
				return 1 - tex2D(_GrabTexture, screenPos);
			}
			ENDCG
        }
    }

Fallback Off
} 