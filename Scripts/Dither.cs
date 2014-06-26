using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {

    /// <summary>
    /// Just dither things
    /// </summary>
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/Dither")]
    public class Dither : PostEffectsBase {
        public Shader shader;

        //dither
        public Texture2D dither;
        public float ditherAdjust = 0.0f;

        protected Material mMat;

        public override bool CheckResources() {
            CheckSupport(false);
            mMat = CheckShaderAndCreateMaterial(shader, mMat);

            if(!isSupported || mMat == null) {
                ReportAutoDisable();
            }
            else {
                //dither
                if(dither != null) {
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
                //dither
                if(dither != null) {
                    mMat.SetFloat("ditherStepX", ((float)src.width) / dither.width);
                    mMat.SetFloat("ditherStepY", ((float)src.height) / dither.height);

                    Graphics.Blit(src, dest, mMat);
                }
                else {
                    Graphics.Blit(src, dest);
                }
            }
        }
    }
}