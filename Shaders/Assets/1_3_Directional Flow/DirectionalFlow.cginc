#if !defined(DIRECTIONAL_FLOW_INCLUDED)
#define DIRECTIONAL_FLOW_INCLUDED

//2.3 : Rotating Derivatives
float2 DirectionalFlowUV (float2 uv, float2 flowVector, float tiling, float time, out float2x2 rotation) 
{
	float2 dir = normalize(flowVector.xy);

	rotation = float2x2(dir.y, dir.x, -dir.x, dir.y);

	uv = mul(float2x2(dir.y, dir.x, -dir.x, dir.y), uv);
	uv.y -= time;

	return uv * tiling;
}

float3 DirectionalFlowUVW (float2 uv, float2 flowVector, float tiling, float time, out float2x2 rotation) 
{
	float2 dir = normalize(flowVector.xy);

	rotation = float2x2(dir.y, dir.x, -dir.x, dir.y);

	float3 uvw;
	uvw.xy = mul(float2x2(dir.y, -dir.x, dir.x, dir.y), uv);
	uvw.z = 1;

	return uvw;
}

#endif