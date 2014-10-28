using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/ChromaticDisplace")]
    public class ChromaticDisplace : PostEffectsBase {
        public float displace = 8.0f;

        public Shader shader;

        private Material mMat;
        private int mDisplaceId;

        public override bool CheckResources() {
            CheckSupport(false);

            mMat = CheckShaderAndCreateMaterial(shader, mMat);
            mDisplaceId = Shader.PropertyToID("displace");

            if(!isSupported)
                ReportAutoDisable();

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

            mMat.SetFloat(mDisplaceId, displace);

            Graphics.Blit(src, dest, mMat);
        }
    }
}