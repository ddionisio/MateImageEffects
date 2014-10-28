using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/CrossHatchBlend")]
    public class CrossHatchBlend : PostEffectsBase {
        public Color lineColor = Color.black;
        public Color paperColor = Color.clear;
        public float fill = 0;
        public float lineDistance = 10;
        public float lineThickness = 1;
        public float lumThreshold1 = 1;
        public float lumThreshold2 = 0.7f;
        public float lumThreshold3 = 0.5f;
        public float lumThreshold4 = 0.3f;
        public float lumThreshold5 = 0.0f;

        public Shader shader;

        private Material mMat;

        public override bool CheckResources() {
            CheckSupport(false);

            mMat = CheckShaderAndCreateMaterial(shader, mMat);

            mMat.SetColor("lineColor", lineColor);
            mMat.SetColor("paperColor", paperColor);
            mMat.SetFloat("fill", fill);
            mMat.SetFloat("lineDist", lineDistance);
            mMat.SetFloat("lineThickness", lineThickness);
            mMat.SetFloat("lumThreshold1", lumThreshold1);
            mMat.SetFloat("lumThreshold2", lumThreshold2);
            mMat.SetFloat("lumThreshold3", lumThreshold3);
            mMat.SetFloat("lumThreshold4", lumThreshold4);
            mMat.SetFloat("lumThreshold5", lumThreshold5);

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

            Graphics.Blit(src, dest, mMat);
        }
    }
}