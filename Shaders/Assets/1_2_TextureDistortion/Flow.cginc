#if !defined(FLOW_INCLUDED)
#define FLOW_INCLUDED

//1.4.1 : Directed Sliding
float2 FlowUV (float2 uv, float2 flowVector, float time)
{
	//1.4.4 : Directed Sliding
	float progress = frac(time);
	return uv - flowVector * progress;
}

#endif