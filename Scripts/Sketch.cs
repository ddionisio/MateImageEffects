using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/Sketch")]
    public class Sketch : PostEffectsBase {
        public Shader shader;

        public Color paper = new Color(0.82f, 0.77f, 0.61f);
        public Color ink = new Color(0.28f, 0.32f, 0.32f);

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

            Graphics.Blit(src, dest, mMat);
        }
    }
}