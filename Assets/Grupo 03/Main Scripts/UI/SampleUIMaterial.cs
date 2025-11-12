using System;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Image))]
public class SampleUIMaterial : MonoBehaviour, IMaterialUser
{
    [SerializeField] private Material _material;
    private Image _image;

    private void Awake()
    {
        _image = GetComponent<Image>();

        // Assign cloned instance so we don’t modify shared material
        if (_material != null)
        {
            _material = new Material(_material);
            _image.material = _material;
        }
        else
        {
            _material = _image.material;
        }
    }

    // IMaterialUser implementation
    public Material GetMaterial()
    {
        return _material;
    }

    public void SetMaterial(Material material)
    {
        _material = material;
        if (_image != null)
            _image.material = _material;
    }

    public string GetIdentifier()
    {
        return $"UI Material on Image: {gameObject.name}";
    }

    public GameObject GetGameObject()
    {
        return gameObject;
    }

    // Optional property for direct access
    public Material Material
    {
        get => _material;
        set
        {
            _material = value;
            if (_image != null)
                _image.material = _material;
        }
    }
}