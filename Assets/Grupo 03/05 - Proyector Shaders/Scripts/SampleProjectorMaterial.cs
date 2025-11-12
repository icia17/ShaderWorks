using System;
using UnityEngine;

[RequireComponent(typeof(Projector))]
public class SampleProjectorMaterial : MonoBehaviour, IMaterialUser
{
    [SerializeField] private Material _material;
    private Projector _projector;

    private void Awake()
    {
        _projector = GetComponent<Projector>();

        // Assign cloned instance so we don’t modify shared material
        if (_material != null)
        {
            _material = new Material(_material);
            _projector.material = _material;
        }
        else
        {
            _material = _projector.material;
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
        if (_projector != null)
            _projector.material = _material;
    }

    public string GetIdentifier()
    {
        return $"Projector Material: {gameObject.name}";
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
            if (_projector != null)
                _projector.material = _material;
        }
    }
}