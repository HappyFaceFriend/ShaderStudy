using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;


public class OutlinePostProcessRenderer : ScriptableRendererFeature
{
    [SerializeField] Material outlineEffectMaterial;
    OutlinePostProcessPass outlinePass;
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        renderer.EnqueuePass(outlinePass);
    }

    public override void Create()
    {
        outlinePass = new OutlinePostProcessPass(outlineEffectMaterial);
    }
}