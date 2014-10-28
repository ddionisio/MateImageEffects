/*
   Copyright (C) 2006 guest(r) - guest.r@gmail.com

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version 2
   of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/

/*

  The shader tries to make a "BW sketch" of the screen that is currently being
  drawn.

*/

Shader "Hidden/Sketch" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
	}
	// Shader code pasted into all further CGPROGRAM blocks
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	struct VERTEX_STUFF3
	{
	  float4  coord : POSITION;
	  float2  C    : TEXCOORD0;
	  float2  L    : TEXCOORD1;
	  float2  R    : TEXCOORD2;
	  float2  U    : TEXCOORD3;
	  float2  D    : TEXCOORD4;
	};
	
	sampler2D _MainTex;
	uniform float4 _MainTex_TexelSize;
	
	float3 pap = float3(0.82, 0.77, 0.61);
	float3 ink = float3(0.28, 0.32, 0.32);
	
	VERTEX_STUFF3 vert( appdata_img v ) 
	{
		VERTEX_STUFF3 o;
		
		float dx = _MainTex_TexelSize.x*0.5;
	    float dy = _MainTex_TexelSize.y*0.5;
		
		o.coord = mul(UNITY_MATRIX_MVP, v.vertex);
		o.C = v.texcoord.xy;
		o.L = v.texcoord.xy + float2(-dx, 0);
		o.R = v.texcoord.xy + float2( dx, 0);
		o.U = v.texcoord.xy + float2( 0,-dy);
		o.D = v.texcoord.xy + float2( 0, dy);
		return o;
	} 
	
	float4 frag(VERTEX_STUFF3 VAR) : COLOR 
	{
		float3 c11 = tex2D(_MainTex, VAR.C).xyz;
		float3 c01 = tex2D(_MainTex, VAR.L).xyz;
		float3 c21 = tex2D(_MainTex, VAR.R).xyz;
		float3 c10 = tex2D(_MainTex, VAR.U).xyz;
		float3 c12 = tex2D(_MainTex, VAR.D).xyz;
		  
		float3 dt = float3(1,1,1);
			  
		float lum_ct = dot(c11,dt)*0.5 + 0.5;
		float lum_x  = dot(c01+c21,dt)*0.2 + lum_ct;
		float lum_y  = dot(c10+c12,dt)*0.2 + lum_ct;

		float d = dot(abs(c01-c21),dt)/lum_x + dot(abs(c10-c12),dt)/lum_y;
		float a = max(0.0, 3.0*d-0.15);

		return float4((1.0-a)*pap + a*ink,1);
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
