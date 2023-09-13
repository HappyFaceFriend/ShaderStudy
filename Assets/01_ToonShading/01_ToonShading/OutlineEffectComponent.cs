using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;


[Serializable, VolumeComponentMenuForRenderPipeline("Custom/OutlineEffect", typeof(UniversalRenderPipeline))]
public class OutlineEffectComponent : VolumeComponent, IPostProcessComponent
{

    public MinFloatParameter outlineWeight = new MinFloatParameter(value: 0.1f, min: 0, overrideState: true);
    public NoInterpColorParameter outlineColor = new NoInterpColorParameter(Color.cyan);
    public IntParameter scale = new IntParameter(value: 1);
    public MinFloatParameter depthThreshold = new MinFloatParameter(value: 0.1f, min: 0, overrideState: true);

    public bool IsActive() => outlineWeight.value > 0;

    public bool IsTileCompatible() => true;

}