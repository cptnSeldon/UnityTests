Shader "Custom/DistortionFlow"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		//1.3.1 : Flow Direction
		//[NoScaleOffset] _FlowMap ("Flow (RG)", 2D) = "black" {}
		//2.3.1 : Time Offset - expecting noise in the flow map
		[NoScaleOffset] _FlowMap("Flow (RG, A noise)", 2D) = "black" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows	// Physically based Standard lighting model, and enable shadows on all light types
        #pragma target 3.0	// Use shader model 3.0 target, to get nicer looking lighting

		//1.2.1 : Flowing UV 
		#include "Flow.cginc"

		//1.3.2 : Flow Direction
        sampler2D _MainTex, _FlowMap;

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
			//2.3.1 : Time Offset
			float noise = tex2D(_FlowMap, IN.uv_MainTex).a;
			float time = _Time.y + noise;
			//2.4.1 : Combining Two Distortions
			float3 uvwA = FlowUVW(IN.uv_MainTex, flowVector, time, false);
			float3 uvwB = FlowUVW(IN.uv_MainTex, flowVector, time, true);

			fixed4 texA = tex2D(_MainTex, uvwA.xy) * uvwA.z;
			fixed4 texB = tex2D(_MainTex, uvwB.xy) * uvwB.z;

			fixed4 c = (texA + texB) * _Color;

			//2.1.3 : Blend Weight
            //fixed4 c = tex2D(_MainTex, uvw.xy) * uvw.z * _Color;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
