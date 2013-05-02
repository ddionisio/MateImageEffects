using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/DotBloom")]
    public class DotBloom : PostEffectsBase {
        public Shader shader;

        public float gamma = 2.4f;
        public float shine = 0.05f;
        public float blend = 0.65f;
        public float resolution = 0.3f;

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

            mMat.SetFloat("gamma", gamma);
            mMat.SetFloat("shine", shine);
            mMat.SetFloat("blend", blend);

            mMat.SetFloat("srcW", src.width / resolution);
            mMat.SetFloat("srcH", src.height / resolution);

            Graphics.Blit(src, dest, mMat);
        }

        private void DownSample4x(RenderTexture source, RenderTexture dest) {
            float off = 1.0f;
            Graphics.BlitMultiTap(source, dest, mMat,
                new Vector2(-off, -off),
                new Vector2(-off, off),
                new Vector2(off, off),
                new Vector2(off, -off)
            );
        }
    }
}