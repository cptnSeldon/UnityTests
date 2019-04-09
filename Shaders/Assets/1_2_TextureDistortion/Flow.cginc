#if !defined(FLOW_INCLUDED)
#define FLOW_INCLUDED

//2.4.1 : Combining Two Distorsions
float3 FlowUVW (float2 uv, float2 flowVector, float time, bool flowB)
{
	//2.4.1 : Combining Two Distortions
	float phaseOffset = flowB ? 0.5 : 0;
	float progress = frac(time + phaseOffset);
	//2.1.2 : Blend Weight
	float3 uvw;
	//2.4.1 : Combining Two Distortions
	uvw.xy = uv - flowVector * progress + phaseOffset;
	//2.2.1 : Seesaw - black pulsing effect
	uvw.z = 1 - abs(1 - 2 * progress);
	return uvw;
}

#endif