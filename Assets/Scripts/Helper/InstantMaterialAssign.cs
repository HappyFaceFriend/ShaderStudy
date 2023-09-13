using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class InstantMaterialAssign : MonoBehaviour
{
    [SerializeField] Material [] _materials;
    [SerializeField] Transform _target;
    public void ChangeMaterial()
    {
        Renderer[] children;
        children = _target.GetComponentsInChildren<Renderer>();
        foreach (Renderer rend in children)
        {
            rend.sharedMaterials = _materials.Clone() as Material[];
            
        }
    }
}
[CustomEditor(typeof(InstantMaterialAssign), true)]
public class InstantMaterialAssignEditor : Editor
{
    public override void OnInspectorGUI()
    {

        InstantMaterialAssign t = (InstantMaterialAssign)target;
        DrawDefaultInspector();
        if (GUILayout.Button("Assign Materials"))
        {
            
            t.ChangeMaterial();
        }
        Repaint();
    }
}