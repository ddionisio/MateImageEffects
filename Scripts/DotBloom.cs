using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/DotBloom")]
    public class DotBloom : ScalerBase {
        public float gamma = 2.4f;
        public float shine = 0.05f;
        public float blend = 0.65f;
        public float tileScale = 1.0f;

        public override bool CheckResources() {
            bool ret = base.CheckResources();
            if(ret) {
                mMat.SetFloat("gamma", gamma);
                mMat.SetFloat("shine", shine);
                mMat.SetFloat("blend", blend);
            }

            return ret;
        }


        protected override void DoRender(RenderTexture src, RenderTexture dest) {
            float w = src.width * tileScale, h = src.height * tileScale;
            mMat.SetVector("srcSize", new Vector4(w, h, 1.0f / w, 1.0f / h));

            Graphics.Blit(src, dest, mMat);
        }
    }
}