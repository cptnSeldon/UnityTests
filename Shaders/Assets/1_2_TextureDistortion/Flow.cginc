#if !defined(FLOW_INCLUDED)
#define FLOW_INCLUDED

//2.1.1 : Blend Weight
float3 FlowUVW (float2 uv, float2 flowVector, float time)
{
	//1.4.4 : Directed Sliding
	float progress = frac(time);
	//2.1.2 : Blend Weight
	float3 uvw;
	uvw.xy = uv - flowVector * progress;
	//uvw.z = 1;
	//2.2.1 : Seesaw - black pulsing effect
	uvw.z = 1 - abs(1 - 2 * progress);
	return uvw;
}

#endif