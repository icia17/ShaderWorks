using UnityEngine;

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
    [SerializeField] private Material waterMaterial;
    
    [Header("Foam Source")]
    [SerializeField] private Transform foamSource;
    [SerializeField] private float foamRadius = 3f;
    [SerializeField] private float heightOffset = 0f;
    
    [Header("Divine Glow")]
    [SerializeField] private bool enableGlow = true;
    [SerializeField] private float glowRadius = 5f;
    [SerializeField] private float glowIntensity = 1f;
    
    [Header("Update Settings")]
    [SerializeField] private float updateInterval = 0.05f;
    
    private float lastUpdateTime;
    
    // Shader properties
    private static readonly int FoamCenter = Shader.PropertyToID("_FoamCenter");
    private static readonly int FoamRadius = Shader.PropertyToID("_FoamRadius");
    private static readonly int GlowCenter = Shader.PropertyToID("_GlowCenter");
    private static readonly int GlowRadius = Shader.PropertyToID("_GlowRadius");
    private static readonly int GlowIntensity = Shader.PropertyToID("_GlowIntensity");

    #region Unity Lifecycle
    private void Awake()
    {
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
        
        if (foamSource == null)
        {
            GameObject boat = GameObject.FindGameObjectWithTag("Player");
            if (boat != null)
            {
                foamSource = boat.transform;
                Debug.Log("Foam/Glow source encontrado");
            }
        }
    }

    private void Update()
    {
        if (Time.time - lastUpdateTime >= updateInterval)
        {
            UpdateWaterShader();
            lastUpdateTime = Time.time;
        }
    }
    #endregion

    #region Public Methods
    /// <summary>
    /// Controla la intensidad del glow divino
    /// </summary>
    public void SetGlowIntensity(float intensity)
    {
        glowIntensity = intensity;
        if (waterMaterial != null)
        {
            waterMaterial.SetFloat(GlowIntensity, intensity);
        }
    }
    #endregion

    #region Private Methods
    private void UpdateWaterShader()
    {
        if (waterMaterial == null || foamSource == null) return;

        Vector3 position = foamSource.position + Vector3.up * heightOffset;
        
        // Actualizar foam
        waterMaterial.SetVector(FoamCenter, position);
        waterMaterial.SetFloat(FoamRadius, foamRadius);
        
        // Actualizar glow divino
        if (enableGlow)
        {
            waterMaterial.SetVector(GlowCenter, position);
            waterMaterial.SetFloat(GlowRadius, glowRadius);
            waterMaterial.SetFloat(GlowIntensity, glowIntensity);
        }
    }

    private void ValidateWaterMaterial()
    {
        if (waterMaterial == null)
        {
            GameObject waterObj = GameObject.FindGameObjectWithTag("Water");
            if (waterObj != null)
            {
                Renderer renderer = waterObj.GetComponent<Renderer>();
                if (renderer != null)
                {
                    waterMaterial = renderer.sharedMaterial;
                    Debug.Log("Water Material encontrado");
                }
            }
        }
    }
    #endregion
}