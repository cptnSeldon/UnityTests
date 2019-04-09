Shader "Custom/DistortionFlow"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		//1.3.1 : Flow Direction
		[NoScaleOffset] _FlowMap ("Flow (RG)", 2D) = "black" {}
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
			//1.3.2 : Flow Direction
			float2 flowVector = tex2D(_FlowMap, IN.uv_MainTex).rg;
            //1.2.2 : Flowing UV
			float2 uv = FlowUV(IN.uv_MainTex, _Time.y);
            fixed4 c = tex2D (_MainTex, uv) * _Color;
            o.Albedo = c.rgb;
			//1.3.3 : Flow Direction
			o.Albedo = float3(flowVector, 0);
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
