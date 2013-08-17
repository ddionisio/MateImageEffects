using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/SketchColor")]
    public class SketchColor : PostEffectsBase {
        public Shader shader;

        public Color paper = new Color(0.83f, 0.79f, 0.63f);

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

            Graphics.Blit(src, dest, mMat);
        }
    }
}