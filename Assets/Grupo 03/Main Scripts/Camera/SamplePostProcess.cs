using System;
using Unity.VisualScripting;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class SamplePostProcess : MonoBehaviour, IMaterialUser
{
    [SerializeField] private Material _material;
    
    // IMaterialUser implementation
    public Material GetMaterial()
    {
        return _material;
    }

    public void SetMaterial(Material material)
    {
        _material = material;
    }

    public string GetIdentifier()
    {
        return $"PostProcess on Camera: {gameObject.name}";
    }

    public GameObject GetGameObject()
    {
        return gameObject;
    }

    // Optional: Public property for direct access
    public Material Material
    {
        get => _material;
        set => _material = value;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (_material != null)
        {
            Graphics.Blit(source, destination, _material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}