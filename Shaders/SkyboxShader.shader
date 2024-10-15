Shader"Custom/SkyboxShader"
{
    Properties
    {
        [Header(Time)]
        _CurrentTime ("Current Time", Range(0, 24)) = 0

        [Header(Sun)]
        [HDR] _SunColor ("Sun Color", Color) = (1, 1, 1, 1)
        _SunRadius ("Sun Radius", Float) = 0.07
        _SunStrength ("Sun Strength", Float) = 50.0

        [Header(Moon)]
        [HDR] _MoonColor ("Moon Color", Color) = (1, 1, 1, 1)
        _MoonRadius ("Moon Radius", Float) = 0.07
        _MoonStrength ("Moon Strength", Float) = 50.0
        _MoonCrescenOffset("Moon Crescen Offset", Range(-0.1, 0.1)) = 0.1

        [Header(Bloom)]
        _BloomRadius ("Bloom Radius", Float) = 0.07
        _BloomStrength ("Bloom Strength", Float) = 10.0

        [Header(Bloom Color)]
        _MorningBloomColor ("Morning Bloom Color", Color) = (1, 1, 1, 1)
        _AfternoonBloomColor ("Afternoon Bloom Color", Color) = (1, 1, 1, 1)
        _DuskBloomColor ("Dusk Bloom Color", Color) = (1, 1, 1, 1)
        _NightBloomColor ("Night Bloom Color", Color) = (1, 1, 1, 1)

        [Header(Sky Morning)]
        _MorningTopColor ("Morning Top Color", Color) = (1, 1, 1, 1)
        _MorningBottomColor ("Morning Bottom Color", Color) = (1, 1, 1, 1)
        _MorningUpperThreshold ("Morning Upper Threshold", Float) = 0.3
        _MorningUpperRange ("Morning Upper Range", Float) = 0.2
        _MorningTime ("Morning Time", Vector) = (5, 7, 8, 10)

        [Header(Sky Afternoon)]
        _AfternoonTopColor ("Afternoon Top Color", Color) = (1, 1, 1, 1)
        _AfternoonBottomColor ("Afternoon Bottom Color", Color) = (1, 1, 1, 1)
        _AfternoonUpperThreshold ("Afternoon Upper Threshold", Float) = 0.3
        _AfternoonUpperRange ("Afternoon Upper Range", Float) = 0.2
        _AfternoonTime ("Afternoon Time", Vector) = (8, 10, 16, 18)

        [Header(Sky Dusk)]
        _DuskTopColor ("Dusk Top Color", Color) = (1, 1, 1, 1)
        _DuskBottomColor ("Dusk Bottom Color", Color) = (1, 1, 1, 1)
        _DuskUpperThreshold ("Dusk Upper Threshold", Float) = 0.3
        _DuskUpperRange ("Dusk Upper Range", Float) = 0.2
        _DuskTime ("Dusk Time", Vector) = (16, 18, 18, 20)

        [Header(Sky Night)]
        _NightTopColor ("Night Top Color", Color) = (1, 1, 1, 1)
        _NightBottomColor ("Night Bottom Color", Color) = (1, 1, 1, 1)
        _NightUpperThreshold ("Night Upper Threshold", Float) = 0.3
        _NightUpperRange ("Night Upper Range", Float) = 0.2
        _NightTime ("Night Time", Vector) = (18, 20, 5, 7)

        [Header(Cloud)]
        [Toggle(_USE_CLOUD)] _UseCloud ("Use Cloud", Float) = 1.0
        _CloudHeight ("Cloud Height", Float) = 1.5
        _CloudBaseNoise ("Cloud Base Noise", 2D) = "white" {}
        _CloudFirstNoise ("Cloud First Noise", 2D) = "white" {}
        _CloudSecondNoise ("Cloud Second Noise", 2D) = "white" {}
        _CloudDirection ("Cloud Direction", Vector) = (0, 0, 0, 0)
        _CloudSpeed ("Cloud Speed", Float) = 0.5
        _CloudThreshold ("Cloud Threshold", Range(0, 1)) = 0.3
        _CloudRange ("Cloud Range", Range(0, 1)) = 0.5
        _CloudTime ("Cloud Time", Vector) = (22, 23, 4, 5)

        [Header(Cloud Color)]
        _MorningCloudColor ("Morning Cloud Color", Color) = (1, 1, 1, 1)
        _AfternoonCloudColor ("Afternoon Cloud Color", Color) = (1, 1, 1, 1)
        _DuskCloudColor ("Dusk Cloud Color", Color) = (1, 1, 1, 1)
        _NightCloudColor ("Night Cloud Color", Color) = (1, 1, 1, 1)

        [Header(Cloud Fade)]
        [Toggle(_USE_CLOUD_FADE)] _UseCloudFade ("Use Cloud Fade", Float) = 1.0
        _CloudFadeDistanceThreshold ("Cloud Fade Distance Threshold", Range(0, 1)) = 0.2
        _CloudFadeDistanceRange ("Cloud Fade Distance Range", Range(0, 1)) = 0.3

        [Header(Star)]
        _StarTexture ("Star Texture", 2D) = "white" {}
        [HDR] _StarColor ("Star Color", Color) = (1, 1, 1, 1)
        _StarThreshold ("Star Threshold", Range(0, 1)) = 0.5

        [Header(Aurora)]
        [Toggle(_USE_AURORA)] _UseAurora ("Use Aurora", Float) = 1.0
        _AuroraColor ("Aurora Color", Color) = (1, 1, 1, 1)
        _AuroraColorFactor ("Aurora Color Factor", Range(0,1)) = 0.5
        _AuroraSpeed ("Aurora Speed", Range(0,1)) = 0.5
        _AuroraTime ("Aurora Time", Vector) = (22, 23, 3, 4)

    }
    SubShader
    {
        Tags {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
        }
        LOD 200
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "HLSLs/UnityNoise.hlsl"
            #include "HLSLs/AuroraUtils.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            #pragma shader_feature_local_fragment _USE_CLOUD_FADE
            #pragma shader_feature_local_fragment _USE_AURORA
            #pragma shader_feature_local_fragment _USE_CLOUD


            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 uv : TEXCOORD0;
                float3 positionWS : TEXCOORD1;
            };

            CBUFFER_START(UnityPerMaterial)
                float _CurrentTime;

                float4 _SunColor;
                float _SunRadius;
                float _SunStrength;

                float4 _MoonColor;
                float _MoonRadius;
                float _MoonStrength;
                float _MoonCrescenOffset;

                float _BloomRadius;
                float _BloomStrength;

                float4 _MorningBloomColor;
                float4 _AfternoonBloomColor;
                float4 _DuskBloomColor;
                float4 _NightBloomColor;

                float4 _MorningTopColor;
                float4 _MorningBottomColor;
                float _MorningUpperThreshold;
                float _MorningUpperRange;
                float4 _MorningTime;

                float4 _AfternoonTopColor;
                float4 _AfternoonBottomColor;
                float _AfternoonUpperThreshold;
                float _AfternoonUpperRange;
                float4 _AfternoonTime;

                float4 _DuskTopColor;
                float4 _DuskBottomColor;
                float _DuskUpperThreshold;
                float _DuskUpperRange;
                float4 _DuskTime;

                float4 _NightTopColor;
                float4 _NightBottomColor;
                float _NightUpperThreshold;
                float _NightUpperRange;
                float4 _NightTime;

                float4 _MorningCloudColor;
                float4 _AfternoonCloudColor;
                float4 _DuskCloudColor;
                float4 _NightCloudColor;

                float _CloudHeight;
                float4 _CloudBaseNoise_ST;
                float4 _CloudFirstNoise_ST;
                float4 _CloudSecondNoise_ST;
                float2 _CloudDirection;
                float _CloudSpeed;
                float _CloudThreshold;
                float _CloudRange;
                float4 _CloudTime;

                float _CloudFadeDistanceThreshold;
                float _CloudFadeDistanceRange;

                float4 _StarTexture_ST;
                float4 _StarColor;
                float _StarThreshold;

                float4 _AuroraColor;
                float _AuroraColorFactor;
                float _AuroraSpeed;
                float4 _AuroraTime;
            CBUFFER_END

            TEXTURE2D(_CloudBaseNoise);         SAMPLER(sampler_CloudBaseNoise);
            TEXTURE2D(_CloudFirstNoise);        SAMPLER(sampler_CloudFirstNoise);
            TEXTURE2D(_CloudSecondNoise);       SAMPLER(sampler_CloudSecondNoise);
            TEXTURE2D(_StarTexture);            SAMPLER(sampler_StarTexture);


            Varyings vert(Attributes input)
            {
                Varyings output = (Varyings)0;

                VertexPositionInputs positionInputs = GetVertexPositionInputs(input.positionOS);
                output.positionCS = positionInputs.positionCS;
                output.positionWS = positionInputs.positionWS;  
                output.uv = input.uv;
                
                return output;
            }

            float Remap(float value, float2 inRange, float2 outRange)
            {
                float ratio = (value - inRange.x) / (inRange.y - inRange.x);
                return ratio * (outRange.y - outRange.x) + outRange.x;
            }

            // 获取平滑过渡的lerp值
            float GetLerpValue(float time, float2 start, float2 end)
            {
                if (time < start.x || time > end.y)
                    return 0.0;
                else if (time > start.y && time < end.x)
                    return 1.0;
                else if (time >= start.x && time <= start.y)
                    return smoothstep(start.x, start.y, time);
                else return smoothstep(end.y, end.x, time);
            }

            float3 GetSkyColor(float3 topColor, float3 bottomColor, float upperThreshold, float upperRange, float height)
            {
                float skyColorRatio = 1.0 - smoothstep(upperThreshold - upperRange, upperThreshold + upperRange, height);
                float3 skyColor = lerp(topColor, bottomColor, skyColorRatio);
                return skyColor;
            }

            float4 frag(Varyings input) : SV_TARGET
            {
                Light light = GetMainLight();
                float3 lightPosWS = _MainLightPosition.xyz;

                // Sun Color
                float sunDis = distance(input.uv.xyz, lightPosWS);
                float sunRange = saturate((1.0 - sunDis / _SunRadius) * _SunStrength);
                float3 sunColor = sunRange * _SunColor.rgb;

                // Moon Color
                float moonDis = distance(input.uv.xyz, -lightPosWS);
                float moonRange = saturate((1.0 - moonDis / _MoonRadius) * _MoonStrength);
                float3 moonColor = moonRange * _MoonColor.rgb;

                float moonCrescenDis = distance(input.uv.xyz + float3(_MoonCrescenOffset, 0.0, 0.0), -lightPosWS);
                float moonCrescenRange = saturate((1.0 - moonCrescenDis / _MoonRadius) * _MoonStrength);
                moonColor = moonColor * saturate(moonRange - moonCrescenRange);

                // Sky Color
                float3 morningSkyColor = GetSkyColor(_MorningTopColor.rgb, _MorningBottomColor.rgb, _MorningUpperThreshold,  _MorningUpperRange, abs(input.uv.y));
                float3 afternoonSkyColor = GetSkyColor(_AfternoonTopColor.rgb, _AfternoonBottomColor.rgb, _AfternoonUpperThreshold,  _AfternoonUpperRange, abs(input.uv.y));
                float3 duskSkyColor = GetSkyColor(_DuskTopColor.rgb, _DuskBottomColor.rgb, _DuskUpperThreshold, _DuskUpperRange, abs(input.uv.y));
                float3 nightSkyColor = GetSkyColor(_NightTopColor.rgb, _NightBottomColor.rgb, _NightUpperThreshold, _NightUpperRange, abs(input.uv.y));

                // Sun Bloom

                float morningLerpValue = GetLerpValue(_CurrentTime, _MorningTime.xy, _MorningTime.zw);
                float afternoonLerpValue = GetLerpValue(_CurrentTime, _AfternoonTime.xy, _AfternoonTime.zw);
                float duskLerpValue = GetLerpValue(_CurrentTime, _DuskTime.xy, _DuskTime.zw);
                float nightLerpValue = 1.0 - GetLerpValue(_CurrentTime, _NightTime.zw, _NightTime.xy);

                // Sun and Moon Bloom
                float sunBloom = saturate((1.0 - sunDis / _BloomRadius) * _BloomStrength);
                float moonBloom = saturate((1.0 - moonDis / _BloomRadius) * _BloomStrength);
                float totalBloom = sunBloom + moonBloom;

                morningSkyColor = lerp(morningSkyColor, _MorningBloomColor, totalBloom);
                afternoonSkyColor = lerp(afternoonSkyColor, _AfternoonBloomColor, totalBloom);
                duskSkyColor = lerp(duskSkyColor, _DuskBloomColor, totalBloom);
                nightSkyColor = lerp(nightSkyColor, _NightBloomColor, totalBloom);

                // Star
                float starNoise = 0.0;
                float3 normalizePosWS = normalize(input.positionWS);
                float2 sphereUV = float2(atan2(normalizePosWS.x, normalizePosWS.z) / (PI * 2.0),asin(normalizePosWS.y) / PI);
                starNoise = SAMPLE_TEXTURE2D(_StarTexture, sampler_StarTexture, sphereUV * _StarTexture_ST.xy);
                starNoise = saturate(Remap(starNoise, float2(_StarThreshold, 1.0), float2(0.0, 1.0)));
                float3 starColor = starNoise * _StarColor.rgb;
                nightSkyColor += starColor;

                float3 finalSkyColor = morningSkyColor * morningLerpValue \
                                    + afternoonSkyColor * afternoonLerpValue \
                                    + duskSkyColor * duskLerpValue \
                                    + nightSkyColor * nightLerpValue;

                finalSkyColor += (sunColor + moonColor);

                // Aurora
                #ifdef _USE_AURORA
                    float4 surAuroraCol = smoothstep(0.0, 1.5, SurAurora(float3(input.uv.x,abs(input.uv.y),input.uv.z),float3(0, 0, -6.7), _Time.y, _AuroraSpeed, _AuroraColorFactor));

                    float3 aurora = float3(_AuroraColor.rgb * GetAurora(float3(input.uv.xy * float2(1.2,1.0), _Time.y * _AuroraSpeed * 0.22)) * 0.9 +
                                            _AuroraColor.rgb * GetAurora(float3(input.uv.xy * float2(1.0,0.7), _Time.y * _AuroraSpeed * 0.27)) * 0.9 +
                                            _AuroraColor.rgb * GetAurora(float3(input.uv.xy * float2(0.8,0.6), _Time.y * _AuroraSpeed * 0.29)) * 0.5 +
                                            _AuroraColor.rgb * GetAurora(float3(input.uv.xy * float2(0.9,0.5), _Time.y * _AuroraSpeed * 0.20)) * 0.57);
                    float4 auroraCol = float4(aurora, 0.1354);
                    float3 auroraColor = lerp(finalSkyColor, surAuroraCol.rgb, surAuroraCol.a);
                    auroraColor = lerp(auroraColor, auroraCol.rgb, auroraCol.a);
                    float auroraLerpValue = 1.0 - GetLerpValue(_CurrentTime, _AuroraTime.zw, _AuroraTime.xy);
                    finalSkyColor = lerp(finalSkyColor, auroraColor, auroraLerpValue);
                #endif

                float3 finalColor = finalSkyColor;

                #ifdef _USE_CLOUD
                    // Cloud
                    float2 skyUV = input.positionWS.xz / input.positionWS.y * _CloudHeight;
                    float2 cloudScrollSpeed = _CloudSpeed * _Time.y * normalize(_CloudDirection);
                    float baseNoise = SAMPLE_TEXTURE2D(_CloudBaseNoise, sampler_CloudBaseNoise, skyUV * _CloudBaseNoise_ST.xy - cloudScrollSpeed);
                    float noise1 = SAMPLE_TEXTURE2D(_CloudFirstNoise, sampler_CloudFirstNoise, (skyUV + baseNoise) * _CloudFirstNoise_ST.xy - cloudScrollSpeed);
                    float noise2 = SAMPLE_TEXTURE2D(_CloudSecondNoise, sampler_CloudSecondNoise, (skyUV + noise1) * _CloudSecondNoise_ST.xy - cloudScrollSpeed);
                    float finalNoise = saturate(noise1 * noise2) * saturate(input.positionWS.y);
                    finalNoise = saturate(smoothstep(_CloudThreshold, _CloudThreshold + _CloudRange, finalNoise));
                    #ifdef _USE_CLOUD_FADE
                        float fadeDist = distance(input.uv.xz, float2(0.0, 0.0));
                        fadeDist = smoothstep(_CloudFadeDistanceThreshold, _CloudFadeDistanceThreshold + _CloudFadeDistanceRange, 1.0 - saturate(fadeDist));
                        finalNoise *= fadeDist;
                    #endif
                    float3 finalCloudColor = _MorningCloudColor * morningLerpValue \
                                    + _AfternoonCloudColor * afternoonLerpValue \
                                    + _DuskCloudColor * duskLerpValue \
                                    + _NightCloudColor * nightLerpValue;
                    float3 cloudSkyColor = lerp(finalSkyColor, finalCloudColor, finalNoise);
                    float cloudLerpValue = 0.0;
                    if(_CloudTime.x < _CloudTime.z)
                        cloudLerpValue = GetLerpValue(_CurrentTime, _CloudTime.xy, _CloudTime.zw);
                    else
                        cloudLerpValue = 1.0 - GetLerpValue(_CurrentTime, _CloudTime.zw, _CloudTime.xy);
                    finalColor = lerp(finalColor, cloudSkyColor, cloudLerpValue);
                #endif

                return float4(finalColor, 1.0);
            }

            ENDHLSL
        }
    }
}
