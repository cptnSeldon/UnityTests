#if !defined(DIRECTIONAL_FLOW_INCLUDED)
#define DIRECTIONAL_FLOW_INCLUDED

//2.2 : Texture Rotation - a bit confusing in the original thread
float2 DirectionalFlowUV (float2 uv, float2 flowVector, float tiling, float time) 
{
	float2 dir = normalize(flowVector.xy);

	uv = mul(float2x2(dir.y, dir.x, -dir.x, dir.y), uv);
	uv.y -= time;

	return uv * tiling;
}

float3 DirectionalFlowUVW (float2 uv, float2 flowVector, float tiling, float time) 
{
	float2 dir = normalize(flowVector.xy);

	float3 uvw;
	uvw.xy = mul(float2x2(dir.y, -dir.x, dir.x, dir.y), uv);
	uvw.z = 1;

	return uvw;
}

#endif