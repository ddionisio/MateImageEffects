using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/SketchColor")]
    public class SketchColor : PostEffectsBase {
        public Shader shader;

        [SerializeField]
        Color paper = new Color(0.83f, 0.79f, 0.63f);
        [SerializeField]
        float threshold = 1.25f;

        private Material mMat;

        public override bool CheckResources() {
            CheckSupport(false);
            mMat = CheckShaderAndCreateMaterial(shader, mMat);

            if(!isSupported)
                ReportAutoDisable();
            else {
                mMat.SetColor("pap", paper);
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