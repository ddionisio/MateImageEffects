using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/Quantize")]
    public class Quantize : PostEffectsBase {
        public int levels = 16;
        public bool dithered = false;

        public Shader shader;

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

            mMat.SetFloat("levels", levels);

            int pass;

            if(dithered) {
                mMat.SetFloat("width", src.width);
                mMat.SetFloat("height", src.height);

                pass = 1;
            }
            else {
                pass = 0;
            }

            Graphics.Blit(src, dest, mMat, pass);
        }
    }
}