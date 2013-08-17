using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/Tile")]
    public class Tile : PostEffectsBase {
        public float numTiles = 40.0f;

        public Shader shader;

        private Material mMat;

        /// <summary>
        /// Use with a coroutine
        /// </summary>
        public IEnumerator DoTilePulse(float minTile, float delay) {
            if(delay > 0.0f) {
                enabled = true;

                float curTime = 0.0f;
                float maxTile = Screen.height;
                WaitForFixedUpdate waitUpdate = new WaitForFixedUpdate();

                while(curTime < delay) {
                    curTime += Time.fixedDeltaTime;

                    float t = Mathf.Sin(Mathf.PI * (curTime / delay));
                    t *= t;

                    numTiles = maxTile + t * (minTile - maxTile);

                    yield return waitUpdate;
                }

                enabled = false;
            }

            yield break;
        }

        public override bool CheckResources() {
            CheckSupport(false);
            mMat = CheckShaderAndCreateMaterial(shader, mMat);

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

            mMat.SetFloat("numTiles", numTiles);

            Graphics.Blit(src, dest, mMat);
        }
    }
}