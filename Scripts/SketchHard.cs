using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/SketchHard")]
    public class SketchHard : PostEffectsBase {
        public Shader shader;

        public Color paper = new Color(0.10f, 0.02f, 0.00f);
        public Color ink = new Color(0.10f, 0.82f, 0.05f);
        public float threshold = 0.14f;
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

            mMat.SetFloat("psx", 1.0f / src.width);
            mMat.SetFloat("psy", 1.0f / src.height);
            mMat.SetColor("pap", paper);
            mMat.SetColor("ink", ink);
            mMat.SetFloat("threshold", threshold);

            Graphics.Blit(src, dest, mMat);
        }
    }
}