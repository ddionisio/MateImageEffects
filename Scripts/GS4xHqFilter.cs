using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/GS4xHqFilter")]
    public class GS4xHqFilter : ScalerBase {

        protected override void DoRender(RenderTexture src, RenderTexture dest) {
            Graphics.Blit(src, dest, mMat);
        }
    }
}