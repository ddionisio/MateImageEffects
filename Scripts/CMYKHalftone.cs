using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/CMYKHalftone")]
    public class CMYKHalftone : PostEffectsBase {
        public Shader shader;

        public float frequency = 40.0f;
        public Vector4 rot = new Vector4(15, 75, 0, 45);

        public float uScale = 1.0f;
        public float uYrot = 45.0f;

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

            mMat.SetFloat("frequency", frequency);
            mMat.SetVector("rot", new Vector4(rot.x * Mathf.Deg2Rad, rot.y * Mathf.Deg2Rad, rot.z * Mathf.Deg2Rad, rot.w * Mathf.Deg2Rad));

            mMat.SetFloat("uScale", uScale);
            mMat.SetFloat("uYrot", uYrot * Mathf.Deg2Rad);

            mMat.SetFloat("srcW", src.width);
            mMat.SetFloat("srcH", src.height);

            Graphics.Blit(src, dest, mMat);
        }
    }
}