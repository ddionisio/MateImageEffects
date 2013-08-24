using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("")]
    public class ScalerBase : PostEffectsBase {
        public enum ScaleType {
            None,
            DownSample,
            Scale,
            Resolution
        }

        public Shader shader;

        public ScaleType type = ScaleType.DownSample;
        public Vector2 resolution = new Vector2(320, 180); //default for 16:9 resolution
        public float scale = 1.0f;
        public int downSample = 4;
        public FilterMode filterDown = FilterMode.Bilinear;
        public FilterMode filter = FilterMode.Point;

        protected Material mMat;

        public override bool CheckResources() {
            CheckSupport(false);
            mMat = CheckShaderAndCreateMaterial(shader, mMat);

            if(!isSupported)
                ReportAutoDisable();

            return isSupported;
        }

        protected virtual void DoRender(RenderTexture src, RenderTexture dest) {
            Graphics.Blit(src, dest);
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

            int w = src.width, h = src.height;

            switch(type) {
                case ScaleType.DownSample:
                    if(downSample > 1) {
                        w /= downSample;
                        h /= downSample;
                    }
                    break;

                case ScaleType.Scale:
                    if(scale > 0.0f) {
                        w = Mathf.RoundToInt(w * scale);
                        h = Mathf.RoundToInt(h * scale);
                    }
                    break;

                case ScaleType.Resolution:
                    w = Mathf.RoundToInt(resolution.x);
                    h = Mathf.RoundToInt(resolution.y);
                    break;
            }

            if(w != src.width || h != src.height) {
                RenderTexture buffer = RenderTexture.GetTemporary(w, h, 0);

                src.filterMode = filterDown;
                Graphics.Blit(src, buffer);

                buffer.filterMode = filter;
                DoRender(buffer, dest);

                RenderTexture.ReleaseTemporary(buffer);
            }
            else {
                DoRender(src, dest);
            }
        }
    }
}