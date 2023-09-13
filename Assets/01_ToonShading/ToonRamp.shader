// This shader fills the mesh shape with a color predefined in the code.
Shader "ToonShading/ToonRamp"
{
    // The properties block of the Unity shader. In this example this block is empty
    // because the output color is predefined in the fragment shader code.
    Properties
    { 
        _MainTex("Main Texture", 2D) = "white"
    }

    // The SubShader block containing the Shader code.
    SubShader
    {
        // SubShader Tags define when and under which conditions a SubShader block or
        // a pass is executed.
        Pass
        {
        Tags {  "Queue"="Transparent" "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }
            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct VertexAttribues
            {
                float4 position   : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 position  : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;

            VertexOutput vert(VertexAttribues v)
            {
                // Declaring the output object (OUT) with the Varyings struct.
                VertexOutput o;
                // The TransformObjectToHClip function transforms vertex positions
                // from object space to homogenous clip space.
                
                o.position = TransformObjectToHClip(v.position.xyz);
                o.uv = v.uv;
                // Returning the output.
                return o;
            }

            // The fragment shader definition.
            half4 frag(VertexOutput o) : SV_Target
            {
                // Defining the color variable and returning it.
                half4 color;
				color = tex2D(_MainTex, o.uv);
                return color;
            }
            ENDHLSL
        }

    }
}