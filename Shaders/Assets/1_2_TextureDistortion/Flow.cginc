#if !defined(FLOW_INCLUDED)
#define FLOW_INCLUDED

//3.1.1 : Tiling
float3 FlowUVW (float2 uv, float2 flowVector, float2 jump, float tiling, float time, bool flowB)
{
	float phaseOffset = flowB ? 0.5 : 0;
	float progress = frac(time + phaseOffset);
	float3 uvw;
	//3.1.2 : Tiling
	uvw.xy = uv - flowVector * progress;
	uvw.xy *= tiling;
	uvw.xy += phaseOffset;

	uvw.xy += (time - progress) * jump;
	uvw.z = 1 - abs(1 - 2 * progress);
	return uvw;
}

#endif