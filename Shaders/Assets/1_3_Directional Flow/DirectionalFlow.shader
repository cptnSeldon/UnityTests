Shader "Custom/DirectionalFlow" 
{
	Properties 
	{
		_Color ("Color", Color) = (1,1,1,1)
		[NoScaleOffset] _MainTex ("Deriv (AG) Height (B)", 2D) = "black" {}
		[NoScaleOffset] _FlowMap ("Flow (RG)", 2D) = "black" {}
		_Tiling ("Tiling", Float) = 1
		_GridResolution ("Grid Resolution", Float) = 10
		_Speed ("Speed", Float) = 1
		_FlowStrength ("Flow Strength", Float) = 1
		_HeightScale ("Height Scale, Constant", Float) = 0.25
		_HeightScaleModulated ("Height Scale, Modulated", Float) = 0.75
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0
		
		#include "DirectionalFlow.cginc"

		sampler2D _MainTex, _FlowMap;
		float _Tiling, _GridResolution, _Speed, _FlowStrength;
		float _HeightScale, _HeightScaleModulated;

		struct Input 
		{
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		float3 UnpackDerivativeHeight (float4 textureData) 
		{
			float3 dh = textureData.agb;
			dh.xy = dh.xy * 2 - 1;
			return dh;
		}

		//3.2 : Blending cells
		float3 FlowCell (float2 uv, float2 offset, float time) {
		    float2x2 derivRotation;
			float2 uvTiled = floor(uv * _GridResolution + offset) / _GridResolution;
			float3 flow = tex2D(_FlowMap, uvTiled).rgb;
			flow.xy = flow.xy * 2 - 1;
			flow.z *= _FlowStrength;
			float2 uvFlow = DirectionalFlowUV(uv, flow, _Tiling, time, derivRotation);
			float3 dh = UnpackDerivativeHeight(tex2D(_MainTex, uvFlow));
			dh.xy = mul(derivRotation, dh.xy);
			return dh;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			float time = _Time.y * _Speed;

			//3.2 : Blending cells
			float2 uv = IN.uv_MainTex;
			
			float3 dhA = FlowCell(uv, float2(0, 0), time);
			float3 dhB = FlowCell(uv, float2(1, 0), time);

			float t = frac(uv.x * _GridResolution);

			float3 dh = dhA * 0.5 + dhB * 0.5;

			fixed4 c = dh.z * dh.z * _Color;

			o.Albedo = t; //c.rgb;
			o.Normal = normalize(float3(-dh.xy, 1));
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}