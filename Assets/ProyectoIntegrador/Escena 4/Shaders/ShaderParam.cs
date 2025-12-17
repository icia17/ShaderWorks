using UnityEngine;

public enum ParamType { Float, Range, Color, Toggle }

[System.Serializable]
public class ShaderParam
{
    public string label;
    public string property;
    public ParamType type;
    public float min = 0f;
    public float max = 1f;
}
