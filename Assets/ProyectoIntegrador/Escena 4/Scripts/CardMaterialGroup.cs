using UnityEngine;
using System.Collections.Generic;

public class CardMaterialGroup : MonoBehaviour
{
    [System.Serializable]
    public class RendererEntry
    {
        public Renderer renderer;
        public string label; // Frame, Window, World, etc.
    }

    [Header("Renderers de esta carta")]
    [SerializeField] private RendererEntry[] renderers;

    // label → materiales instanciados
    private Dictionary<string, Material[]> runtimeMaterials =
        new Dictionary<string, Material[]>();

    public Dictionary<string, Material[]> RuntimeMaterials => runtimeMaterials;

    void Awake()
    {
        runtimeMaterials.Clear();

        foreach (var entry in renderers)
        {
            if (entry.renderer == null)
            {
                Debug.LogWarning($"{name}: Renderer vacío en CardMaterialGroup");
                continue;
            }

            Material[] originalMaterials = entry.renderer.sharedMaterials;
            Material[] instancedMaterials = new Material[originalMaterials.Length];

            for (int i = 0; i < originalMaterials.Length; i++)
            {
                instancedMaterials[i] = new Material(originalMaterials[i]);
            }

            // Reasignar los materiales instanciados al renderer
            entry.renderer.materials = instancedMaterials;

            runtimeMaterials.Add(entry.label, instancedMaterials);
        }
    }
}
