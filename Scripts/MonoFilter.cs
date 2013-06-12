using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {

    /// <summary>
    /// Be sure to have a second Pass (index = 1) as the one processing the dither effect
    /// </summary>
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/MonoFilter")]
    public class MonoFilter : DitherBase {
        public float colorEnhance = 1.0f;

        protected override void OnInitResource() {
            mMat.SetFloat("color_enhance", colorEnhance);
        }
    }
}