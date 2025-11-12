using UnityEngine;

/// <summary>
/// Interface for any component that uses a material that can be controlled by DynamicMaterialUI
/// </summary>
public interface IMaterialUser
{
    /// <summary>
    /// Gets the material instance being used
    /// </summary>
    Material GetMaterial();
    
    /// <summary>
    /// Sets the material instance
    /// </summary>
    void SetMaterial(Material material);
    
    /// <summary>
    /// Gets a unique identifier for this material user (for debug/logging)
    /// </summary>
    string GetIdentifier();
    
    /// <summary>
    /// Gets the GameObject this material user is attached to
    /// </summary>
    GameObject GetGameObject();
}