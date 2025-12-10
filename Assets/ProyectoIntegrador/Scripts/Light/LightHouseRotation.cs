using UnityEngine;

/// <summary>
/// Controla la rotación y la intensidad de la luz del faro
/// </summary>
public class LighthouseRotation : MonoBehaviour
{
    [Header("Rotation Settings")]
    [Tooltip("Velocidad de rotación en grados por segundo")]
    [SerializeField] private float rotationSpeed = 30f;
    
    [Tooltip("Eje de rotación (normalmente Y para horizontal)")]
    [SerializeField] private Vector3 rotationAxis = Vector3.up;
    
    [Header("Light Pulse (Opcional)")]
    [Tooltip("Activar pulso de intensidad")]
    [SerializeField] private bool enablePulse = false;
    
    [SerializeField] private float pulseSpeed = 2f;
    [SerializeField] private float pulseAmount = 0.3f;
    
    private Light spotLight;
    private float baseIntensity;

    private void Start()
    {
        spotLight = GetComponent<Light>();
        if (spotLight != null)
        {
            baseIntensity = spotLight.intensity;
        }
    }

    private void Update()
    {
        // Rotación continua
        transform.Rotate(rotationAxis, rotationSpeed * Time.deltaTime);
        
        // Pulso opcional
        if (enablePulse && spotLight != null)
        {
            float pulse = Mathf.Sin(Time.time * pulseSpeed) * pulseAmount;
            spotLight.intensity = baseIntensity + pulse;
        }
    }

    /// <summary>
    /// Controla la intensidad de la luz desde el SceneTransitionController
    /// </summary>
    public void SetLightIntensity(float intensity)
    {
        baseIntensity = intensity;
        
        if (spotLight != null)
        {
            spotLight.intensity = intensity;
        }
    }

    public void SetRotationSpeed(float speed)
    {
        rotationSpeed = speed;
    }
}