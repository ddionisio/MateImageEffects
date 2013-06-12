using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

namespace M8.ImageEffects {
    [CustomEditor(typeof(Palette4Filter))]

    public class Palette4FilterInspector : UnityEditor.Editor {
        private bool mShow = false;

        public override void OnInspectorGUI() {

            GUI.changed = false;

            base.OnInspectorGUI();

            //M8.Editor.Utility.DrawSeparator();

            mShow = EditorGUILayout.Foldout(mShow, "Palettes");

            if(mShow) {
                Palette4Filter data = target as Palette4Filter;

                if(data.palettes == null || data.palettes.Length < 4)
                    data.palettes = new Color[4];

                for(int i = 0; i < data.palettes.Length; i++) {
                    data.palettes[i] = EditorGUILayout.ColorField(i.ToString(), data.palettes[i]);
                }
            }

            if(GUI.changed)
                EditorUtility.SetDirty(target);
        }
    }
}