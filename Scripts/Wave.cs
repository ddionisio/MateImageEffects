using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/Wave")]
    public class Wave : PostEffectsBase {
        public Shader shader;

        public float amplitudeX = 1.0f;
        public float amplitudeY = 1.0f;
        public float speedX; //degree per sec
        public float speedY; //degree per sec
        public float rangeX = 1.0f; //
        public float rangeY = 1.0f; //rev per pixel

        public TextureWrapMode wrapMode = TextureWrapMode.Clamp;

        private Material mMat;

        public override bool CheckResources() {
            CheckSupport(false);
            mMat = CheckShaderAndCreateMaterial(shader, mMat);

            if(!isSupported) {
                ReportAutoDisable();
            }

            return isSupported;
        }

        void OnRenderImage(RenderTexture src, RenderTexture dest) {
            if(!CheckResources()) {
                Graphics.Blit(src, dest);
                return;
            }

            src.wrapMode = wrapMode;
            
            mMat.SetFloat("amplitudeX", amplitudeX);
            mMat.SetFloat("amplitudeY", amplitudeY);

            if(rangeX != 0.0f) {
                mMat.SetFloat("rangeX", (2.0f * Mathf.PI) / rangeX);
            }
            else {
                mMat.SetFloat("rangeX", 0.0f);
            }

            if(rangeY != 0.0f) {
                mMat.SetFloat("rangeY", (2.0f * Mathf.PI) / rangeY);
            }
            else {
                mMat.SetFloat("rangeY", 0.0f);
            }

            mMat.SetFloat("speedX", speedX * Mathf.Deg2Rad);
            mMat.SetFloat("speedY", speedY * Mathf.Deg2Rad);

            Graphics.Blit(src, dest, mMat);
        }
    }
}