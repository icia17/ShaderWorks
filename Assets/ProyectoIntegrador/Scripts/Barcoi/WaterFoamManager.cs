using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Gestor singleton que coordina la espuma dinámica en el agua
/// Implementa el patrón Singleton para acceso global
/// </summary>
public class WaterFoamManager : MonoBehaviour
{
    #region Singleton
    private static WaterFoamManager _instance;
    public static WaterFoamManager Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = FindObjectOfType<WaterFoamManager>();
                
                if (_instance == null)
                {
                    GameObject go = new GameObject("WaterFoamManager");
                    _instance = go.AddComponent<WaterFoamManager>();
                }
            }
            return _instance;
        }
    }
    #endregion

    [Header("Water Settings")]
    [Tooltip("Material del agua que recibirá las posiciones de espuma")]
    [SerializeField] private Material waterMaterial;
    
    [Header("Update Settings")]
    [Tooltip("Frecuencia de actualización del shader (menor = más FPS)")]
    [SerializeField] private float updateInterval = 0.1f;
    
    // Lista de generadores de espuma registrados
    private List<IFoamGenerator> foamGenerators = new List<IFoamGenerator>();
    
    // Control de tiempo para optimización
    private float lastUpdateTime;
    
    // Nombres de propiedades del shader (optimización)
    private static readonly int FoamObjectPos = Shader.PropertyToID("_FoamObjectPos");
    private static readonly int FoamRadius = Shader.PropertyToID("_FoamRadius");

    #region Unity Lifecycle
    private void Awake()
    {
        // Patrón Singleton: asegurar una sola instancia
        if (_instance != null && _instance != this)
        {
            Destroy(gameObject);
            return;
        }
        
        _instance = this;
        DontDestroyOnLoad(gameObject);
    }

    private void Start()
    {
        ValidateWaterMaterial();
    }

    private void Update()
    {
        // Optimización: actualizar solo cada X segundos
        if (Time.time - lastUpdateTime >= updateInterval)
        {
            UpdateWaterShader();
            lastUpdateTime = Time.time;
        }
    }
    #endregion

    #region Public Methods
    /// <summary>
    /// Registra un nuevo generador de espuma
    /// </summary>
    public void RegisterFoamGenerator(IFoamGenerator generator)
    {
        if (generator != null && !foamGenerators.Contains(generator))
        {
            foamGenerators.Add(generator);
            Debug.Log($"Foam generator registered. Total generators: {foamGenerators.Count}");
        }
    }

    /// <summary>
    /// Desregistra un generador de espuma
    /// </summary>
    public void UnregisterFoamGenerator(IFoamGenerator generator)
    {
        if (foamGenerators.Contains(generator))
        {
            foamGenerators.Remove(generator);
            Debug.Log($"Foam generator unregistered. Total generators: {foamGenerators.Count}");
        }
    }
    #endregion

    #region Private Methods
    /// <summary>
    /// Actualiza el shader del agua con la posición del generador más cercano/activo
    /// </summary>
    private void UpdateWaterShader()
    {
        if (waterMaterial == null)
        {
            return;
        }

        // Limpiar generadores inactivos o nulos
        foamGenerators.RemoveAll(g => g == null || !g.IsActive());

        if (foamGenerators.Count > 0)
        {
            // Por ahora tomamos el primer generador activo
            // Puedes expandir esto para manejar múltiples generadores
            IFoamGenerator activeGenerator = foamGenerators[0];
            
            Vector3 foamPos = activeGenerator.GetFoamPosition();
            float foamRadius = activeGenerator.GetFoamRadius();
            
            // Actualizar shader
            waterMaterial.SetVector(FoamObjectPos, foamPos);
            waterMaterial.SetFloat(FoamRadius, foamRadius);
        }
        else
        {
            // Sin generadores, poner posición fuera del rango visible
            waterMaterial.SetVector(FoamObjectPos, new Vector4(0, -1000, 0, 0));
        }
    }

    /// <summary>
    /// Valida que el material del agua esté asignado
    /// </summary>
    private void ValidateWaterMaterial()
    {
        if (waterMaterial == null)
        {
            Debug.LogWarning("Water Material no asignado en WaterFoamManager. Buscando automáticamente...");
            
            // Intentar encontrar el material automáticamente
            Renderer waterRenderer = FindObjectOfType<Renderer>();
            if (waterRenderer != null)
            {
                waterMaterial = waterRenderer.sharedMaterial;
                Debug.Log("Water Material encontrado automáticamente.");
            }
            else
            {
                Debug.LogError("No se pudo encontrar el Water Material. Asígnalo manualmente en el Inspector.");
            }
        }
    }
    #endregion
}