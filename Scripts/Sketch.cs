using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/Sketch")]
    public class Sketch : PostEffectsBase {
        public Shader shader;

        [SerializeField]
        Color paper = new Color(0.82f, 0.77f, 0.61f);

        [SerializeField]
        Color ink = new Color(0.28f, 0.32f, 0.32f);

        private Material mMat;

        public override bool CheckResources() {
            CheckSupport(false);
            mMat = CheckShaderAndCreateMaterial(shader, mMat);

            if(!isSupported)
                ReportAutoDisable();
            else {
                mMat.SetColor("pap", paper);
                mMat.SetColor("ink", ink);
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