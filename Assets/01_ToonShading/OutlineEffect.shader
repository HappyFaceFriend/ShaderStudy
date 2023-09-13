Shader "Hidden/OutlineEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct VertexAttribues
            {
                float4 position   : POSITION;
                half3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 position  : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 texcoordStereo : TEXCOORD1;
                float3 viewSpaceDir  : TEXCOORD2;
            };

            half4 _OutlineColor;
            half _OutlineWeight;
            float4x4 _ClipToView;
            
            float2 TransformTriangleVertexToUV(float2 vertex)
            {
                float2 uv = (vertex + 1.0) * 0.5;
                return uv;
            }

            float2 TransformStereoScreenSpaceTex(float2 uv, float w)
            {
                float4 scaleOffset = unity_StereoScaleOffset[unity_StereoEyeIndex];
                return uv.xy * scaleOffset.xy + scaleOffset.zw * w;
            }

            VertexOutput vert(VertexAttribues v)
            {
                VertexOutput o;
                o.position = TransformObjectToHClip(v.position.xyz);
                o.uv = v.uv;
                
                //o.position = float4(v.position.xy, 0.0, 1.0);
                //o.uv = TransformTriangleVertexToUV(v.position.xy);
#if UNITY_UV_STARTS_AT_TOP
	            //o.uv = o.uv * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
	            //o.texcoordStereo = TransformStereoScreenSpaceTex(o.uv, 1.0);
                
                o.viewSpaceDir = mul(_ClipToView, o.position.xyz).xyz;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _CameraDepthTexture;
            sampler2D _CameraNormalsTexture;
            float2 _MainTex_TexelSize;
            float _Scale;
            float _DepthThreshold;

            
            // The fragment shader definition.
            half4 frag(VertexOutput i) : SV_Target
            {
                float halfScaleFloor = floor(_Scale * 0.5);
                float halfScaleCeil = ceil(_Scale * 0.5);
                
                float2 UV_bottomLeft = i.uv - float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y) * halfScaleFloor;
                float2 UV_topRight = i.uv + float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y) * halfScaleCeil;
                float2 UV_bottomRight = i.uv + float2(_MainTex_TexelSize.x * halfScaleCeil, -_MainTex_TexelSize.y * halfScaleFloor);
                float2 UV_topLeft = i.uv + float2(-_MainTex_TexelSize.x * halfScaleFloor, _MainTex_TexelSize.y * halfScaleCeil);


                float depth0 = tex2D(_CameraDepthTexture, UV_bottomLeft).r;
                float depth1 = tex2D(_CameraDepthTexture, UV_topRight).r;
                float depth2 = tex2D(_CameraDepthTexture, UV_bottomRight).r;
                float depth3 = tex2D(_CameraDepthTexture, UV_topLeft).r;

                float depthDiff0 = depth1 - depth0;
                float depthDiff1 = depth3 - depth2;

                float depthEdge = sqrt(pow(depthDiff0,2) + pow(depthDiff1,2)) * 100;
                float modifiedDepthThreshold = _DepthThreshold * depth0;
                depthEdge = depthEdge > modifiedDepthThreshold ? 1 : 0;


                

                float3 normal0 = tex2D(_CameraNormalsTexture, UV_bottomLeft).rgb;

                float3 viewNormal = normal0 * 2 - 1;
                float NdotV = 1 - dot(viewNormal, -i.viewSpaceDir);

                return depthEdge;
            }
            ENDHLSL
        }
    }
}
