#if !defined(DIRECTIONAL_FLOW_INCLUDED)
#define DIRECTIONAL_FLOW_INCLUDED

//2.4 : Sampling the flow - heavily distorted unusable result
float2 DirectionalFlowUV (float2 uv, float3 flowVectorAndSpeed, float tiling, float time, out float2x2 rotation) 
{
	float2 dir = normalize(flowVectorAndSpeed.xy);

	rotation = float2x2(dir.y, dir.x, -dir.x, dir.y);

	uv = mul(float2x2(dir.y, dir.x, -dir.x, dir.y), uv);
	uv.y -= time * flowVectorAndSpeed;

	return uv * tiling;
}

#endif