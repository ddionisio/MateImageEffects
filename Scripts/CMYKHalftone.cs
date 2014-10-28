using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/CMYKHalftone")]
    public class CMYKHalftone : PostEffectsBase {
        public Shader shader;

        [SerializeField]
        float frequency = 40.0f;

        [SerializeField]
        Vector4 rot = new Vector4(15, 75, 0, 45);

        [SerializeField]
        float uScale = 1.0f;

        [SerializeField]
        float uYrot = 45.0f;

        private Material mMat;

        public override bool CheckResources() {
            CheckSupport(false);
            mMat = CheckShaderAndCreateMaterial(shader, mMat);

            if(!isSupported)
                ReportAutoDisable();
            else {
                mMat.SetFloat("frequency", frequency);
                mMat.SetVector("rot", new Vector4(rot.x * Mathf.Deg2Rad, rot.y * Mathf.Deg2Rad, rot.z * Mathf.Deg2Rad, rot.w * Mathf.Deg2Rad));

                mMat.SetFloat("uScale", uScale);
                mMat.SetFloat("uYrot", uYrot * Mathf.Deg2Rad);
            }

            return isSupported;
        }

        void OnRenderImage(RenderTexture src, RenderTexture dest) {
#if UNITY_EDITOR
            if(!CheckResources()) {
                Graphics.Blit(src, dest);
                return;
            }
#else
            if(!isSupported) {
                Graphics.Blit(src, dest);
                    return;
            }
#endif

            Graphics.Blit(src, dest, mMat);
        }
    }
}