Shader "Custom/DistortionFlow"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		//2.3.1 : Time Offset - expecting noise in the flow map
		[NoScaleOffset] _FlowMap("Flow (RG, A noise)", 2D) = "black" {}
		//4.3.1 : Derivative Map -> cheaper to compute than normal maps
		[NoScaleOffset] _DerivHeightMap ("Deriv (AG) Height (B)", 2D) = "black" {}
		//2.5.2: Jump
		_UJump ("U jump per phase", Range(-0.25, 0.25)) = 0.25
		_VJump ("V jump per phase", Range(-0.25, 0.25)) = -0.25
		//3.1.3 : Tiling
		_Tiling ("Tiling", Float) = 1
		//3.2.1 : Animation Speed
		_Speed ("Speed", Float) = 1
		//3.3.1 : Flow Strength
		_FlowStrength ("Flow Strength", Float) = 1
		//3.4.2 : Flow Offset
		_FlowOffset ("Flow Offset", Float) = 0
		//4.4.1 : Height Scale
		_HeightScale ("Height Scale", Float) = 1

        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

		//1.2.1 : Flowing UV 
		#include "Flow.cginc"

		//4.3.1 : Derivative Map
        sampler2D _MainTex, _FlowMap, _DerivHeightMap;
		
		//4.4.2 : Height Scale
		float _UJump, _VJump, _Tiling, _Speed, _FlowStrength, _FlowOffset, _HeightScale;

		//4.3.2 : Derivative Map
		float3 UnpackDerivativeHeight (float4 textureData) 
		{
			float3 dh = textureData.agb;
			dh.xy = dh.xy * 2 - 1;
			return dh;
		}

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			//1.3.2 : Flow Direction, 1.4.2 : Directed Sliding
			float2 flowVector = tex2D(_FlowMap, IN.uv_MainTex).rg * 2 - 1;

			//3.3.2 : Flow Strength
			flowVector *= _FlowStrength;

			//2.3.1 : Time Offset
			float noise = tex2D(_FlowMap, IN.uv_MainTex).a;
			//3.2.3 : Animation Speed
			float time = _Time.y *_Speed + noise;

			//2.5.4: Jump
			float2 jump = float2(_UJump, _VJump);

			//3.4.3 : Flow Offset
			float3 uvwA = FlowUVW(IN.uv_MainTex, flowVector, jump, _FlowOffset, _Tiling, time, false);
			float3 uvwB = FlowUVW(IN.uv_MainTex, flowVector, jump, _FlowOffset, _Tiling, time, true);

			//4.4.2 : Height Scale
			float3 dhA = UnpackDerivativeHeight(tex2D(_DerivHeightMap, uvwA.xy)) * (uvwA.z * _HeightScale);
			float3 dhB = UnpackDerivativeHeight(tex2D(_DerivHeightMap, uvwB.xy)) * (uvwB.z * _HeightScale);
			o.Normal = normalize(float3(-(dhA.xy + dhB.xy), 1));

			fixed4 texA = tex2D(_MainTex, uvwA.xy) * uvwA.z;
			fixed4 texB = tex2D(_MainTex, uvwB.xy) * uvwB.z;

			fixed4 c = (texA + texB) * _Color;

            o.Albedo = c.rgb;
			//4.3.4 : Derivative Map
			//o.Albedo = dhA.z + dhB.z;
			o.Albedo = pow(dhA.z + dhB.z, 2);

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
