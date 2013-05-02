using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/EGAFilter")]
    public class EGAFilter : PostEffectsBase {
        public Shader shader;

        public Texture2D dither;

        public float colorEnhance = 1.2f;
        public float ditherMaxThreshold = 1.0f;

        private Material mMat;

        public override bool CheckResources() {
            CheckSupport(false);
            mMat = CheckShaderAndCreateMaterial(shader, mMat);

            if(!isSupported)
                ReportAutoDisable();

            return isSupported;
        }

        void OnRenderImage(RenderTexture src, RenderTexture dest) {
            if(!CheckResources() || dither == null) {
                Graphics.Blit(src, dest);
                return;
            }

            mMat.SetTexture("_DitherTex", dither);
            mMat.SetFloat("ditherStepX", ((float)src.width) / dither.width);
            mMat.SetFloat("ditherStepY", ((float)src.height) / dither.height);

            mMat.SetFloat("ditherMaxThreshold", 255.0f / ditherMaxThreshold);

            mMat.SetFloat("color_enhance", colorEnhance);

            Graphics.Blit(src, dest, mMat);
        }
    }
}