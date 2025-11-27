using UnityEngine;

/// <summary>
/// Controla la secuencia completa de la escena:
/// - Blanco y negro → Color
/// - Niebla densa → Clara
/// - Luz baja → Luz solar fuerte
/// - Divine Glow (aura divina en el agua)
/// </summary>
public class SceneTransitionController : MonoBehaviour
{
    [Header("References")]
    [Tooltip("Script de post-processing de la cámara")]
    [SerializeField] private GrayscalePostProcessing grayscaleEffect;
    
    [Tooltip("Luz direccional (el sol)")]
    [SerializeField] private Light directionalLight;
    
    [Header("Timeline Settings")]
    [Tooltip("Tiempo en segundos antes de empezar la transición")]
    [SerializeField] private float delayBeforeTransition = 3f;
    
    [Tooltip("Duración de la transición")]
    [SerializeField] private float transitionDuration = 2f;
    
    [Tooltip("Curva de animación para la transición")]
    [SerializeField] private AnimationCurve transitionCurve = AnimationCurve.EaseInOut(0, 0, 1, 1);
    
    [Header("Fog Settings")]
    [SerializeField] private bool controlFog = true;
    [SerializeField] private float fogDensityStart = 0.05f;
    [SerializeField] private float fogDensityEnd = 0.001f;
    [SerializeField] private Color fogColor = new Color(0.5f, 0.5f, 0.5f, 1f);
    
    [Header("Light Settings")]
    [SerializeField] private bool controlLight = true;
    [SerializeField] private float lightIntensityStart = 0.3f;
    [SerializeField] private float lightIntensityEnd = 1.5f;
    [SerializeField] private Color lightColorStart = new Color(0.7f, 0.7f, 0.8f); // Frío
    [SerializeField] private Color lightColorEnd = new Color(1f, 0.95f, 0.8f); // Cálido
    
    [Header("Divine Glow Settings")]
    [SerializeField] private bool controlDivineGlow = true;
    [SerializeField] private float glowIntensityStart = 0f;
    [SerializeField] private float glowIntensityEnd = 1f;
    
    [Header("Auto Setup")]
    [SerializeField] private bool autoFindComponents = true;
    
    [Header("Debug")]
    [SerializeField] private bool showDebugInfo = true;
    
    // Estado de la transición
    private bool isTransitioning = false;
    private float transitionStartTime;
    private float transitionStartValue;
    private float transitionTargetValue;
    
    // Estado actual
    private float currentFogDensity;
    private float currentLightIntensity;
    private float currentGlowIntensity;

    #region Unity Lifecycle
    private void Start()
    {
        // Auto-encontrar componentes
        if (autoFindComponents)
        {
            if (grayscaleEffect == null)
                grayscaleEffect = Camera.main?.GetComponent<GrayscalePostProcessing>();
            
            if (directionalLight == null)
                directionalLight = FindObjectOfType<Light>();
        }
        
        // Configurar fog
        if (controlFog)
        {
            SetupFog();
        }
        
        // Iniciar la secuencia
        StartSequence();
    }

    private void Update()
    {
        if (isTransitioning)
        {
            UpdateTransition();
        }
    }
    #endregion

    #region Public Methods
    public void StartSequence()
    {
        if (grayscaleEffect == null)
        {
            Debug.LogError("GrayscaleEffect no asignado!");
            return;
        }
        
        // Estado inicial: B&N
        grayscaleEffect.SetIntensity(1f);
        
        // Estado inicial: Fog denso
        if (controlFog)
            SetFogDensity(fogDensityStart);
        
        // Estado inicial: Luz baja
        if (controlLight && directionalLight != null)
        {
            directionalLight.intensity = lightIntensityStart;
            directionalLight.color = lightColorStart;
        }
        
        // Estado inicial: Divine Glow apagado
        if (controlDivineGlow)
        {
            WaterFoamManager.Instance.SetGlowIntensity(glowIntensityStart);
            currentGlowIntensity = glowIntensityStart;
        }
        
        if (showDebugInfo)
            Debug.Log($"Escena iniciada. Transición en {delayBeforeTransition}s");
        
        // Programar la transición
        Invoke(nameof(StartColorTransition), delayBeforeTransition);
    }

    public void RestartSequence()
    {
        CancelInvoke();
        isTransitioning = false;
        StartSequence();
    }

    public void StartColorTransition()
    {
        if (grayscaleEffect == null) return;
        
        StartTransition(targetValue: 0f);
        
        if (showDebugInfo)
            Debug.Log($"Iniciando transición completa ({transitionDuration}s)");
    }

    public void StartGrayscaleTransition()
    {
        if (grayscaleEffect == null) return;
        
        StartTransition(targetValue: 1f);
        
        if (showDebugInfo)
            Debug.Log($"Iniciando transición a B&N ({transitionDuration}s)");
    }
    #endregion

    #region Private Methods - Transition
    private void StartTransition(float targetValue)
    {
        transitionStartValue = grayscaleEffect.GetIntensity();
        transitionTargetValue = Mathf.Clamp01(targetValue);
        transitionStartTime = Time.time;
        isTransitioning = true;
    }

    private void UpdateTransition()
    {
        if (grayscaleEffect == null)
        {
            isTransitioning = false;
            return;
        }

        float elapsed = Time.time - transitionStartTime;
        float normalizedTime = Mathf.Clamp01(elapsed / transitionDuration);
        
        // Aplicar curva de animación
        float curveValue = transitionCurve.Evaluate(normalizedTime);
        
        // Actualizar B&N
        float currentIntensity = Mathf.Lerp(transitionStartValue, transitionTargetValue, curveValue);
        grayscaleEffect.SetIntensity(currentIntensity);
        
        // Actualizar todos los efectos con la misma curva
        if (controlFog)
            UpdateFogDensity(curveValue);
        
        if (controlLight)
            UpdateLight(curveValue);
        
        if (controlDivineGlow)
            UpdateDivineGlow(curveValue);
        
        // Finalizar transición
        if (normalizedTime >= 1f)
        {
            grayscaleEffect.SetIntensity(transitionTargetValue);
            isTransitioning = false;
            
            if (showDebugInfo)
                Debug.Log($"Transición completada");
        }
    }
    #endregion

    #region Private Methods - Fog
    private void SetupFog()
    {
        RenderSettings.fog = true;
        RenderSettings.fogColor = fogColor;
        RenderSettings.fogMode = FogMode.Exponential;
        RenderSettings.fogDensity = fogDensityStart;
        currentFogDensity = fogDensityStart;
    }

    private void UpdateFogDensity(float curveValue)
    {
        float fogIntensity;
        if (transitionTargetValue < transitionStartValue)
        {
            // Transición a color: fog disminuye
            fogIntensity = Mathf.Lerp(fogDensityStart, fogDensityEnd, curveValue);
        }
        else
        {
            // Transición a B&N: fog aumenta
            fogIntensity = Mathf.Lerp(fogDensityEnd, fogDensityStart, curveValue);
        }
        
        SetFogDensity(fogIntensity);
    }

    private void SetFogDensity(float density)
    {
        currentFogDensity = density;
        RenderSettings.fogDensity = density;
    }
    #endregion

    #region Private Methods - Light
    private void UpdateLight(float curveValue)
    {
        if (directionalLight == null) return;
        
        if (transitionTargetValue < transitionStartValue)
        {
            // Transición a color: luz aumenta
            currentLightIntensity = Mathf.Lerp(lightIntensityStart, lightIntensityEnd, curveValue);
            directionalLight.intensity = currentLightIntensity;
            directionalLight.color = Color.Lerp(lightColorStart, lightColorEnd, curveValue);
        }
        else
        {
            // Transición a B&N: luz disminuye
            currentLightIntensity = Mathf.Lerp(lightIntensityEnd, lightIntensityStart, curveValue);
            directionalLight.intensity = currentLightIntensity;
            directionalLight.color = Color.Lerp(lightColorEnd, lightColorStart, curveValue);
        }
    }
    #endregion

    #region Private Methods - Divine Glow
    private void UpdateDivineGlow(float curveValue)
    {
        if (transitionTargetValue < transitionStartValue)
        {
            // Transición a color: glow aparece
            currentGlowIntensity = Mathf.Lerp(glowIntensityStart, glowIntensityEnd, curveValue);
        }
        else
        {
            // Transición a B&N: glow desaparece
            currentGlowIntensity = Mathf.Lerp(glowIntensityEnd, glowIntensityStart, curveValue);
        }
    
        WaterFoamManager.Instance.SetGlowIntensity(currentGlowIntensity);
    }
    #endregion

    #region Editor Helpers
#if UNITY_EDITOR
    private void OnGUI()
    {
        if (!Application.isPlaying || !showDebugInfo) return;
        
        GUILayout.BeginArea(new Rect(10, 10, 450, 380));
        GUILayout.Box("Scene Transition Controller - COMPLETO", GUILayout.Width(440));
        
        GUILayout.Label($"Tiempo: {Time.timeSinceLevelLoad:F1}s");
        GUILayout.Label($"Estado: {(isTransitioning ? "Transicionando" : "Esperando")}");
        
        GUILayout.Space(5);
        
        if (grayscaleEffect != null)
            GUILayout.Label($"B&N: {grayscaleEffect.GetIntensity():F2}");
        
        if (controlFog)
            GUILayout.Label($"Fog: {currentFogDensity:F4}");
        
        if (controlLight && directionalLight != null)
            GUILayout.Label($"Luz: {currentLightIntensity:F2}");
        
        if (controlDivineGlow)
            GUILayout.Label($"Divine Glow: {currentGlowIntensity:F2}");
        
        GUILayout.Space(10);
        
        if (GUILayout.Button("Reiniciar Secuencia"))
            RestartSequence();
        
        if (GUILayout.Button("Transición a Color + Sol + Glow"))
        {
            CancelInvoke();
            StartColorTransition();
        }
        
        if (GUILayout.Button("Transición a B&N + Oscuro"))
        {
            CancelInvoke();
            StartGrayscaleTransition();
        }
        
        GUILayout.EndArea();
    }
#endif
    #endregion
}
