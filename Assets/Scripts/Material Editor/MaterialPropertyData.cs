using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class MaterialPropertyData
{
    public string propertyName;
    public string displayName;
    public MaterialPropertyType propertyType;
    public Vector2 floatRange = new Vector2(0f, 1f);
    public bool isSlider = false;
}
