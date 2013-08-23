using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/Wave")]
    public class Wave : PostEffectsBase {
        public Shader shader;

        [SerializeField]
        Vector2 _amplitude; //usu. in fraction

        [SerializeField]
        Vector2 _speed; //degree per sec

        [SerializeField]
        Vector2 _range; //

        public TextureWrapMode wrapMode = TextureWrapMode.Clamp;

        private Material mMat;

        public Vector2 range {
            get { return _range; }
            set {
                if(mMat == null) CheckResources();
                if(isSupported) {
                    _range = value;

                    Vector4 r = new Vector4(
                    _range.x == 0.0f ? 0.0f : (2.0f * Mathf.PI) / _range.x,
                    _range.y == 0.0f ? 0.0f : (2.0f * Mathf.PI) / _range.y);
                    mMat.SetVector("range", r);
                }
            }
        }

        public Vector2 speed {
            get { return _speed; }
            set {
                if(mMat == null) CheckResources();
                if(isSupported) {
                    _speed = value;
                    mMat.SetVector("speed", new Vector4(_speed.x * Mathf.Deg2Rad, _speed.y * Mathf.Deg2Rad));
                }
            }
        }

        public Vector2 amplitude {
            get { return _amplitude; }
            set {
                if(mMat == null) CheckResources();
                if(isSupported) {
                    _amplitude = value;
                    mMat.SetVector("amplitude", _amplitude);
                }
            }
        }

        public override bool CheckResources() {
            CheckSupport(false);
            mMat = CheckShaderAndCreateMaterial(shader, mMat);

            if(!isSupported) {
                ReportAutoDisable();
            }
            else {
                amplitude = _amplitude;
                speed = _speed;
                range = _range;
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