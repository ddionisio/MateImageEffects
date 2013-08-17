using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/EGAFilter")]
    public class EGAFilter : DitherBase {
        public float colorEnhance = 1.2f;

        protected override void OnInitResource() {
            mMat.SetFloat("color_enhance", colorEnhance);
        }
    }
}