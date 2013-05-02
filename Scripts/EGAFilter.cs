using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/EGAFilter")]
    public class EGAFilter : PostEffectsBase {
        public Shader shader;

        public float colorEnhance = 1.2f;

        private Material mMat;

        public override bool CheckResources() {
            CheckSupport(false);
            mMat = CheckShaderAndCreateMaterial(shader, mMat);

            if(!isSupported)
                ReportAutoDisable();

            return isSupported;
        }

        void OnRenderImage(RenderTexture src, RenderTexture dest) {
            if(!CheckResources()) {
                Graphics.Blit(src, dest);
                return;
            }

            mMat.SetFloat("color_enhance", colorEnhance);
            mMat.SetFloat("width", src.width);
            mMat.SetFloat("height", src.height);

            Graphics.Blit(src, dest, mMat);
        }
    }
}