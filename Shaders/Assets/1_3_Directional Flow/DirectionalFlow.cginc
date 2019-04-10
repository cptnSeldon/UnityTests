#if !defined(DIRECTIONAL_FLOW_INCLUDED)
#define DIRECTIONAL_FLOW_INCLUDED

float2 DirectionalFlowUV (float2 uv, float2 flowVector, float tiling, float time) 
{
	uv.y -= time;
	return uv * tiling;
}

#endif