using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/SketchHard")]
    public class SketchHard : PostEffectsBase {
        public Shader shader;

        [SerializeField]
        Color paper = new Color(0.10f, 0.02f, 0.00f);
        [SerializeField]
        Color ink = new Color(0.10f, 0.82f, 0.05f);
        [SerializeField]
        float threshold = 0.14f;

        private Material mMat;

        public override bool CheckResources() {
            CheckSupport(false);
            mMat = CheckShaderAndCreateMaterial(shader, mMat);

            if(!isSupported)
                ReportAutoDisable();
            else {
                mMat.SetColor("pap", paper);
                mMat.SetColor("ink", ink);
                mMat.SetFloat("threshold", threshold);
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

            mMat.SetVector("ps", new Vector4(1.0f / src.width, 1.0f / src.height));
            
            Graphics.Blit(src, dest, mMat);
        }
    }
}