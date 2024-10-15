//极光噪声
float AuroraHash(float n) { 
    return frac(sin(n)*758.5453); 
}

float AuroraNoise(float3 x)
{
    float3 p = floor(x);
    float3 f = frac(x);
    float n = p.x + p.y * 57.0 + p.z * 800.0;
    float res = lerp(lerp(lerp( AuroraHash(n + 0.0), AuroraHash(n + 1.0),f.x), lerp( AuroraHash(n + 57.0), AuroraHash(n + 58.0),f.x),f.y),
            lerp(lerp( AuroraHash(n + 800.0), AuroraHash(n + 801.0),f.x), lerp(AuroraHash(n + 857.0), AuroraHash(n + 858.0),f.x),f.y),f.z);
    return res;
}
//极光分型
float Aurorafbm(float3 p)
{
    float f  = 0.50000 * AuroraNoise(p); 
    p *= 2.02;
    f += 0.25000 * AuroraNoise(p); 
    p *= 2.03;
    f += 0.12500 * AuroraNoise(p); 
    p *= 2.01;
    f += 0.06250 * AuroraNoise(p); 
    p *= 2.04;
    f += 0.03125 * AuroraNoise(p);
    return f * 1.032258;
}
float GetAurora(float3 p)
{
    p+=Aurorafbm(float3(p.x, p.y, 0.0) * 0.5) * 2.25;
    float a = smoothstep(.0, .9, Aurorafbm(p * 2.) * 2.2-1.1);

    return a < 0.0 ? 0.0 : a;
}


/**************带状极光***************/

// 旋转矩阵
float2x2 RotateMatrix(float a){
    float c = cos(a);
    float s = sin(a);
    return float2x2(c, s, -s, c);
}

float tri(float x){
    return clamp(abs(frac(x) - 0.5), 0.01, 0.49);
}

float2 tri2(float2 p){
    return float2(tri(p.x) + tri(p.y), tri(p.y + tri(p.x)));
}

// 极光噪声
float SurAuroraNoise(float2 pos, float time, float speed)
{
    float intensity = 1.8;
    float size = 2.5;
    float rz = 0;
    pos = mul(RotateMatrix(pos.x * 0.06), pos);
    float2 bp = pos;
    for (int i = 0; i < 5; i++)
    {
        float2 dg = tri2(bp * 1.85) * .75;
        dg = mul(RotateMatrix(time * speed), dg); // _Time.y * _AuroraSpeed
        pos -= dg / size;

        bp *= 1.3;
        size *= .45;
        intensity *= .42;
        pos *= 1.21 + (rz - 1.0)*.02;

        rz += tri(pos.x + tri(pos.y)) * intensity;
        pos = mul(-float2x2(0.95534, 0.29552, -0.29552, 0.95534), pos);
    }
    return clamp(1.0 / pow(rz * 29., 1.3), 0, 0.55);
}

float SurHash(float2 n)
{
    return frac(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453); 
}

float4 SurAurora(float3 pos, float3 ro, float time, float speed, float colorFactor)
{
    float4 col = float4(0,0,0,0);
    float4 avgCol = float4(0,0,0,0);

    // 逐层
    for(int i = 0; i < 30; i++)
    {
        // 坐标
        float of = 0.006 * SurHash(pos.xy) * smoothstep(0,15, i);       
        float pt = ((0.8 + pow(i, 1.4) * 0.002) - ro.y) / (pos.y * 2.0 + 0.8);
        pt -= of;
        float3 bpos = ro + pt * pos;
        float2 p = bpos.zx;

        // 颜色
        float noise = SurAuroraNoise(p, time, speed);
        float4 col2 = float4(0, 0, 0, noise);
        col2.rgb = (sin(1.0 - float3(2.15, -.5, 1.2) + i * colorFactor * 0.1) * 0.8 + 0.5) * noise; // _SurAuroraColFactor
        avgCol =  lerp(avgCol, col2, 0.5);
        col += avgCol * exp2(-i * 0.065 - 2.5) * smoothstep(0., 5., i);
    }

    col *= (clamp(pos.y * 15.+.4,0.,1.));

    return col * 1.8;

}