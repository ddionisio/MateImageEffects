using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/CrossHatchBlend")]
    public class CrossHatchBlend : PostEffectsBase {
        public Color lineColor = Color.black;
        public Color paperColor = Color.clear;
        public float fill = 0f;
        public float lineDistance = 10f;
        public float lineThickness = 1f;
        public float lumThreshold1 = 0.8f;
        public float lumThreshold2 = 0.6f;
        public float lumThreshold3 = 0.3f;
        public float lumThreshold4 = 0.15f;
        public float lumThreshold5 = 0.0f;

        public float lineStrength1 = 0.2f;
        public float lineStrength2 = 0.4f;
        public float lineStrength3 = 0.7f;
        public float lineStrength4 = 1f;

        public float kernelOffset = 1f;

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
            mMat.SetFloat("lineStrength1", lineStrength1);
            mMat.SetFloat("lineStrength2", lineStrength2);
            mMat.SetFloat("lineStrength3", lineStrength3);
            mMat.SetFloat("lineStrength4", lineStrength4);

            mMat.SetFloat("d", kernelOffset);

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