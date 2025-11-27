using UnityEngine;

/// <summary>
/// Aplica efecto de post-processing de blanco y negro a la cámara.
/// NO maneja transiciones - solo aplica el efecto según la intensidad configurada.
/// </summary>
[RequireComponent(typeof(Camera))]
public class GrayscalePostProcessing : MonoBehaviour
{
    [Header("Post-Processing Settings")]
    [Tooltip("Material con el shader de Grayscale")]
    [SerializeField] private Material grayscaleMaterial;
    
    [Header("Effect Intensity")]
    [Tooltip("Intensidad del efecto: 0 = color normal, 1 = blanco y negro completo")]
    [Range(0f, 1f)]
    [SerializeField] private float intensity = 1f;
    
    // Shader property ID (optimización)
    private static readonly int IntensityProperty = Shader.PropertyToID("_Intensity");

    #region Unity Lifecycle
    private void Start()
    {
        ValidateMaterial();
        UpdateMaterialIntensity();
    }

    private void Update()
    {
        // Actualizar el material con la intensidad actual
        UpdateMaterialIntensity();
    }

    /// <summary>
    /// OnRenderImage aplica el post-processing a la imagen de la cámara
    /// </summary>
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (grayscaleMaterial != null)
        {
            Graphics.Blit(source, destination, grayscaleMaterial);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
    #endregion

    #region Public Methods
    /// <summary>
    /// Establece la intensidad del efecto (0 = color, 1 = blanco y negro)
    /// </summary>
    public void SetIntensity(float value)
    {
        intensity = Mathf.Clamp01(value);
        UpdateMaterialIntensity();
    }

    /// <summary>
    /// Obtiene la intensidad actual del efecto
    /// </summary>
    public float GetIntensity()
    {
        return intensity;
    }
    #endregion

    #region Private Methods
    /// <summary>
    /// Actualiza la propiedad de intensidad en el material
    /// </summary>
    private void UpdateMaterialIntensity()
    {
        if (grayscaleMaterial != null)
        {
            grayscaleMaterial.SetFloat(IntensityProperty, intensity);
        }
    }

    /// <summary>
    /// Valida que el material esté asignado
    /// </summary>
    private void ValidateMaterial()
    {
        if (grayscaleMaterial == null)
        {
            Debug.LogError("Grayscale Material no asignado en " + gameObject.name);
        }
    }
    #endregion
}