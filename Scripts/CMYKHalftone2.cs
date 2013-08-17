using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/CMYKHalftone2")]
    public class CMYKHalftone2 : PostEffectsBase {
        public Shader shader;

        [SerializeField]
        float dotSize = 1.48f;

        [SerializeField]
        float rotation = 0.0f;

        [SerializeField]
        float scale = 2.5f;

        [SerializeField]
        Vector4 cmykRotation = new Vector4(15, 75, 0, 45);

        private Material mMat;

        public override bool CheckResources() {
            CheckSupport(false);
            mMat = CheckShaderAndCreateMaterial(shader, mMat);

            if(!isSupported)
                ReportAutoDisable();
            else {
                mMat.SetFloat("dotSize", dotSize);
                mMat.SetFloat("_s", scale);
                mMat.SetFloat("_r", rotation * Mathf.Deg2Rad);
                mMat.SetVector("_clrR", cmykRotation * Mathf.Deg2Rad);
            }

            return isSupported;
        }

        void OnRenderImage(RenderTexture src, RenderTexture dest) {
#if UNITY_EDITOR
            CheckResources();
#endif
            if(!isSupported) {
                Graphics.Blit(src, dest);
                return;
            }

            Graphics.Blit(src, dest, mMat);
        }
    }
}