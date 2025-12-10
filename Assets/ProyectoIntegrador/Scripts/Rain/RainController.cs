using UnityEngine;

/// <summary>
/// Controla la intensidad del sistema de partículas de lluvia
/// </summary>
public class RainController : MonoBehaviour
{
    [Header("References")]
    [SerializeField] private ParticleSystem rainParticles;
    
    [Header("Settings")]
    [Tooltip("Tasa de emisión máxima (lluvia fuerte)")]
    [SerializeField] private float maxEmissionRate = 500f;
    
    [Tooltip("Tasa de emisión mínima (sin lluvia)")]
    [SerializeField] private float minEmissionRate = 0f;
    
    private ParticleSystem.EmissionModule emission;
    private float currentIntensity = 1f;

    private void Start()
    {
        if (rainParticles == null)
        {
            rainParticles = GetComponent<ParticleSystem>();
        }
        
        if (rainParticles != null)
        {
            emission = rainParticles.emission;
        }
        else
        {
            Debug.LogError("Rain Particle System no encontrado en " + gameObject.name);
        }
    }

    
    public void SetIntensity(float intensity)
    {
        currentIntensity = Mathf.Clamp01(intensity);
        
        if (rainParticles == null) return;

        float rate = Mathf.Lerp(minEmissionRate, maxEmissionRate, currentIntensity);
        emission.rateOverTime = rate;
        
        // Control de play/stop
        if (currentIntensity <= 0.01f)
        {
            if (rainParticles.isPlaying)
            {
                rainParticles.Stop();
            }
        }
        else
        {
            if (!rainParticles.isPlaying)
            {
                rainParticles.Play();
            }
        }
    }

    public float GetIntensity()
    {
        return currentIntensity;
    }
}
