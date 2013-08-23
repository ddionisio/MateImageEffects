using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/Wave")]
    public class WaveRGB : PostEffectsBase {
        public Shader shader;

        [SerializeField]
        Vector2 _amplitudeR; //usu. in fraction
        [SerializeField]
        Vector2 _amplitudeG;
        [SerializeField]
        Vector2 _amplitudeB;

        [SerializeField]
        Vector2 _speedR; //degree per sec
        [SerializeField]
        Vector2 _speedG;
        [SerializeField]
        Vector2 _speedB;

        [SerializeField]
        Vector2 _rangeR; //
        [SerializeField]
        Vector2 _rangeG;
        [SerializeField]
        Vector2 _rangeB;

        public TextureWrapMode wrapMode = TextureWrapMode.Clamp;

        private Material mMat;

        public Vector2 rangeR { get { return _rangeR; } set { ApplyRange("rangeR", _rangeR = value); } }
        public Vector2 rangeG { get { return _rangeG; } set { ApplyRange("rangeG", _rangeG = value); } }
        public Vector2 rangeB { get { return _rangeB; } set { ApplyRange("rangeB", _rangeB = value); } }

        public Vector2 speedR { get { return _speedR; } set { ApplySpeed("speedR", _speedR = value); } }
        public Vector2 speedG { get { return _speedG; } set { ApplySpeed("speedG", _speedG = value); } }
        public Vector2 speedB { get { return _speedB; } set { ApplySpeed("speedB", _speedB = value); } }

        public Vector2 amplitudeR { get { return _amplitudeR; } set { ApplySpeed("amplitudeR", _amplitudeR = value); } }
        public Vector2 amplitudeG { get { return _amplitudeG; } set { ApplySpeed("amplitudeG", _amplitudeG = value); } }
        public Vector2 amplitudeB { get { return _amplitudeB; } set { ApplySpeed("amplitudeB", _amplitudeB = value); } }

        void ApplyRange(string key, Vector2 val) {
            if(mMat == null) CheckResources();
            if(isSupported) {
                mMat.SetVector(key, new Vector4(
                val.x == 0.0f ? 0.0f : (2.0f * Mathf.PI) / val.x,
                val.y == 0.0f ? 0.0f : (2.0f * Mathf.PI) / val.y));
            }
        }

        void ApplySpeed(string key, Vector2 val) {
            if(mMat == null) CheckResources();
            if(isSupported) {
                mMat.SetVector(key, new Vector4(val.x * Mathf.Deg2Rad, val.y * Mathf.Deg2Rad));
            }
        }

        void ApplyAmp(string key, Vector2 val) {
            if(mMat == null) CheckResources();
            if(isSupported) {
                mMat.SetVector(key, val);
            }
        }

        public override bool CheckResources() {
            CheckSupport(false);
            mMat = CheckShaderAndCreateMaterial(shader, mMat);

            if(!isSupported) {
                ReportAutoDisable();
            }
            else {
                amplitudeR = _amplitudeR;
                amplitudeG = _amplitudeG;
                amplitudeB = _amplitudeB;

                speedR = _speedR;
                speedG = _speedG;
                speedB = _speedB;

                rangeR = _rangeR;
                rangeG = _rangeG;
                rangeB = _rangeB;
            }

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

            src.wrapMode = wrapMode;

            Graphics.Blit(src, dest, mMat);
        }
    }
}