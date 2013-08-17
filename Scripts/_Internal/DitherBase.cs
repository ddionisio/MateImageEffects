using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {

    /// <summary>
    /// Be sure to have a second Pass (index = 1) as the one processing the dither effect
    /// </summary>
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    public class DitherBase : PostEffectsBase {
        public Shader shader;

        //dither
        public bool useDither;
        public Texture2D dither;
        public float ditherAdjust = 0.0f;

        protected Material mMat;

        /// <summary>
        /// Called after material has been initialized
        /// </summary>
        protected virtual void OnInitResource() {
        }

        /// <summary>
        /// Called during render before blitting to screen
        /// </summary>
        protected virtual void OnRender() {
        }

        public override bool CheckResources() {
            CheckSupport(false);
            mMat = CheckShaderAndCreateMaterial(shader, mMat);

            if(!isSupported || mMat == null) {
                ReportAutoDisable();
            }
            else {
                OnInitResource();

                //dither
                if(useDither && dither != null) {
                    mMat.SetTexture("_DitherTex", dither);

                    mMat.SetFloat("ditherAdjustThreshold", ditherAdjust / 255.0f);
                }
            }

            return isSupported;
        }

        void OnRenderImage(RenderTexture src, RenderTexture dest) {
#if UNITY_EDITOR
            CheckResources();
#endif

            if(!isSupported) {
                Graphics.Blit(src, dest);
            }
            else {
                OnRender();

                //dither
                if(useDither && dither != null) {
                    mMat.SetFloat("ditherStepX", ((float)src.width) / dither.width);
                    mMat.SetFloat("ditherStepY", ((float)src.height) / dither.height);

                    Graphics.Blit(src, dest, mMat, 1);
                }
                else {
                    Graphics.Blit(src, dest, mMat, 0);
                }
            }
        }
    }
}