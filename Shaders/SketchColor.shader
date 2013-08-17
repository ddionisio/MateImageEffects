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

  The shader tries to make a "colored sketch" of the screen that is currently being
  drawn.

*/

Shader "Hidden/SketchColor" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
	}
	// Shader code pasted into all further CGPROGRAM blocks
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	struct VERTEX_STUFF0
	{
	  float4  coord : POSITION;
	  float2  CT   : TEXCOORD0;
	  float4  t1   : TEXCOORD1;
	  float4  t2   : TEXCOORD2;
	  float4  t3   : TEXCOORD3;
	  float4  t4   : TEXCOORD4;
	};
	
	sampler2D _MainTex;
	
	float2 ps; //size of one texel = (1.0/texture.width, 1.0/texture.height)
	half3 pap = half3(0.83, 0.79, 0.63);
	
	VERTEX_STUFF0 vert( appdata_img v ) 
	{
		VERTEX_STUFF0 o;
		
		float dx = ps.x*0.5;
	    float dy = ps.y*0.5;
		
		o.coord = mul(UNITY_MATRIX_MVP, v.vertex);
		o.CT = v.texcoord.xy;
		o.t1.xy = v.texcoord.xy + float2(-dx, 0);
		o.t2.xy = v.texcoord.xy + float2( dx, 0);
		o.t3.xy = v.texcoord.xy + float2( 0,-dy);
		o.t4.xy = v.texcoord.xy + float2( 0, dy);
		o.t1.zw = v.texcoord.xy + float2(-dx,-dy);
		o.t2.zw = v.texcoord.xy + float2(-dx, dy);
		o.t3.zw = v.texcoord.xy + float2( dx,-dy);
		o.t4.zw = v.texcoord.xy + float2( dx, dy);

		return o;
	} 
	
	half4 frag(VERTEX_STUFF0 VAR) : COLOR 
	{
	    half3 c00 = tex2D(_MainTex, VAR.t1.zw).xyz; 
	    half3 c10 = tex2D(_MainTex, VAR.t3.xy).xyz; 
	    half3 c20 = tex2D(_MainTex, VAR.t3.zw).xyz; 
	    half3 c01 = tex2D(_MainTex, VAR.t1.xy).xyz; 
	    half3 c11 = tex2D(_MainTex, VAR.CT).xyz; 
	    half3 c21 = tex2D(_MainTex, VAR.t2.xy).xyz; 
	    half3 c02 = tex2D(_MainTex, VAR.t2.zw).xyz; 
	    half3 c12 = tex2D(_MainTex, VAR.t4.xy).xyz; 
	    half3 c22 = tex2D(_MainTex, VAR.t4.zw).xyz; 
	   
	    float3 dt = float3(1,1,1);

	    half d1=dot(abs(c00-c22),dt);
	    half d2=dot(abs(c20-c02),dt);
	    half hl=dot(abs(c01-c21),dt);
	    half vl=dot(abs(c10-c12),dt);

	    half d = 0.55*(d1+d2+hl+vl)/(dot(c11+c10+c02+c22,dt)+0.3); 
	    d +=  0.5*pow(d,0.5);
	    c11 *= (1.0-0.6*d); d+=0.1;
	    d = pow(d,1.25-1.25*min(2.0*d,1.0));
	    return half4 (d*c11 + (1.1-d)*pap,1);
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