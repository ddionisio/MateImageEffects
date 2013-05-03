using UnityEngine;
using System.Collections;

namespace M8.ImageEffects {

    /// <summary>
    /// Be sure to have a second Pass (index = 1) as the one processing the dither effect
    /// </summary>
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("M8/Image Effects/Palette16Filter")]
    public class Palette16Filter : DitherBase {
        public float colorEnhance = 1.0f;

        [HideInInspector]
        public Color[] palettes;

        public void RefreshPalettes() {
            if(palettes != null) {
                for(int i = 0; i < palettes.Length; i++) {
                    //palettes
                    mMat.SetColor("palette" + i, palettes[i]);
                }
            }
        }

        protected override void OnInitResource() {
            RefreshPalettes();

            mMat.SetFloat("color_enhance", colorEnhance);
        }
    }
}