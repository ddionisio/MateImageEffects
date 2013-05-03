using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/Quantize")]
    public class Quantize : DitherBase {
        public int levels = 16;

        //protected override void OnInitResource() {
        //}

        protected override void OnRender() {
            mMat.SetFloat("levels", levels);
        }
    }
}
