Shader "Custom/Waves" 
{
	Properties 
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		//1.3 : Amplitude
		_Amplitude ("Amplitude", Float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows vertex:vert
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input 
		{
			float2 uv_MainTex;
		};

		//1.3 : Amplitude
		float _Amplitude;

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		//1.2 : Adjusting Y
		void vert(inout appdata_full vertexData) 
		{
			float3 p = vertexData.vertex.xyz;

			//1.3 : Amplitude
			p.y = _Amplitude * sin(p.x);

			vertexData.vertex.xyz = p;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}