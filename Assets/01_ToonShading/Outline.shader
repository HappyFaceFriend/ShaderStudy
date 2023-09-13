// This shader fills the mesh shape with a color predefined in the code.
Shader "ToonShading/Outline"
{
    // The properties block of the Unity shader. In this example this block is empty
    // because the output color is predefined in the fragment shader code.
    Properties
    { 
		_OutlineWeight("Outline Weight", Float) = 0.1
		_OutlineColor("Outline Color", Color) = (1,1,1,1)
    }

    // The SubShader block containing the Shader code.
    SubShader
    {
        // SubShader Tags define when and under which conditions a SubShader block or
        // a pass is executed.
        
        Pass
        {
        Tags {  "Queue"="Transparent - 1" "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }
            Name "Outline"
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Front
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct VertexAttribues
            {
                float4 position   : POSITION;
                half3 normal : NORMAL;
            };

            struct VertexOutput
            {
                float4 position  : SV_POSITION;
            };

            half4 _OutlineColor;
            half _OutlineWeight;

            VertexOutput vert(VertexAttribues v)
            {
                VertexOutput o;
                v.position += float4(v.normal,0) * _OutlineWeight;
                o.position = TransformObjectToHClip(v.position.xyz);
                // Returning the output.
                return o;
            }

            // The fragment shader definition.
            half4 frag(VertexOutput o) : SV_Target
            {
                // Defining the color variable and returning it.
                half4 color = _OutlineColor;
                return color;
            }
            ENDHLSL
        }

    }
}