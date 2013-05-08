using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

namespace M8.ImageEffects {
    [CustomEditor(typeof(Palette16Filter))]
    
    public class Palette16FilterInspector : UnityEditor.Editor {
        private bool mShow = false;

        public override void OnInspectorGUI() {

            GUI.changed = false;
                        
            base.OnInspectorGUI();

            M8.Editor.Utility.DrawSeparator();

            mShow = EditorGUILayout.Foldout(mShow, "Palettes");

            if(mShow) {
                Palette16Filter data = target as Palette16Filter;

                if(data.palettes == null || data.palettes.Length < 16)
                    data.palettes = new Color[16];

                for(int i = 0; i < data.palettes.Length; i++) {
                    data.palettes[i] = EditorGUILayout.ColorField(i.ToString(), data.palettes[i]);
                }
            }

            if(GUI.changed)
                EditorUtility.SetDirty(target);
        }
    }
}