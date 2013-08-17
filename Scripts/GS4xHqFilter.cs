using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/GS4xHqFilter")]
    public class GS4xHqFilter : ScalerBase {

        protected override void DoRender(RenderTexture src, RenderTexture dest, Material mat) {
            mat.SetFloat("psx", 1.0f / src.width);
            mat.SetFloat("psy", 1.0f / src.height);

            Graphics.Blit(src, dest, mat);
        }
    }
}