#include "Test.hlsli"

float smoothstep(float edge0, float edge1, float x){
    x = saturate((x - edge0) / (edge1 - edge0));
    return x * x * (3 - 2 * x);
}

Texture2D<float32_t4> gTexture : register(t0);
Texture2D<float32_t> gMaskTexture : register(t1);
SamplerState gSampler : register(s0);

struct PixelShaderOutput
{
    float32_t4 color : SV_TARGET0;
};

PixelShaderOutput main(VertexShaderOutput input)
{
    PixelShaderOutput output;
    float32_t mask = gMaskTexture.Sample(gSampler, input.texcoord);
    // maskの値が0.5(閾値)以下の場合はdiscardして抜く
    if (mask <= 0.5f){
        discard;
    }
    // Edgeっぽさを算出
    //float32_t edge = 1.0f - smoothstep(0.5f, 0.53f, mask);
    output.color = gTexture.Sample(gSampler, input.texcoord);
    // Edgeっぽいほど指定した色を加算
    //output.color.rgb += edge * float32_t3(1.0f, 0.4f, 0.3f);
	return output;
}