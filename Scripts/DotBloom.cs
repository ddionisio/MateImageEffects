using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/DotBloom")]
    public class DotBloom : ScalerBase {
        public float gamma = 2.4f;
        public float shine = 0.05f;
        public float blend = 0.65f;
        public float tileScale = 1.0f;


        protected override void DoRender(RenderTexture src, RenderTexture dest, Material mat) {
            mat.SetFloat("gamma", gamma);
            mat.SetFloat("shine", shine);
            mat.SetFloat("blend", blend);

            mat.SetFloat("srcW", src.width * tileScale);
            mat.SetFloat("srcH", src.height * tileScale);

            Graphics.Blit(src, dest, mat);
        }
    }
}