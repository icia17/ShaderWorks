using UnityEngine;

/// <summary>
/// Controla la secuencia cinematográfica completa de la escena:
/// - Estado inicial: B&N + Niebla densa + Lluvia fuerte + Faro tenue
/// - Transición: Todo se despeja gradualmente
/// - Estado final: Color + Despejado + Sol brillante + Faro brillante + Divine Glow
/// </summary>
public class SceneTransitionController : MonoBehaviour
{
    [Header("References")]
    [Tooltip("Script de post-processing de la cámara")]
    [SerializeField] private GrayscalePostProcessing grayscaleEffect;
    
    [Tooltip("Luz direccional (el sol)")]
    [SerializeField] private Light directionalLight;
    
    [Tooltip("Luz del faro")]
    [SerializeField] private LighthouseRotation lighthouseLight;
    
    [Tooltip("Controlador de lluvia")]
    [SerializeField] private RainController rainController;
    
    [Header("Timeline Settings")]
    [Tooltip("Tiempo en segundos antes de empezar la transición")]
    [SerializeField] private float delayBeforeTransition = 3f;
    
    [Tooltip("Duración de la transición principal")]
    [SerializeField] private float transitionDuration = 4f;
    
    [Tooltip("Curva de animación para la transición")]
    [SerializeField] private AnimationCurve transitionCurve = AnimationCurve.EaseInOut(0, 0, 1, 1);
    
    [Header("Fog Settings")]
    [SerializeField] private bool controlFog = true;
    [Tooltip("Densidad de niebla al inicio (tormenta)")]
    [SerializeField] private float fogDensityStart = 0.08f;
    [Tooltip("Densidad de niebla al final (despejado)")]
    [SerializeField] private float fogDensityEnd = 0.001f;
    [SerializeField] private Color fogColor = new Color(0.5f, 0.5f, 0.5f, 1f);
    
    [Header("Light Settings")]
    [SerializeField] private bool controlLight = true;
    [Tooltip("Intensidad del sol al inicio (tormenta oscura)")]
    [SerializeField] private float lightIntensityStart = 0.2f;
    [Tooltip("Intensidad del sol al final (día brillante)")]
    [SerializeField] private float lightIntensityEnd = 1.8f;
    [SerializeField] private Color lightColorStart = new Color(0.6f, 0.65f, 0.75f); // Frío/tormenta
    [SerializeField] private Color lightColorEnd = new Color(1f, 0.95f, 0.8f); // Cálido/sol
    
    [Header("Rain Settings")]
    [SerializeField] private bool controlRain = true;
    [Tooltip("Intensidad de lluvia al inicio (tormenta)")]
    [SerializeField] private float rainIntensityStart = 1f;
    [Tooltip("Intensidad de lluvia al final (sin lluvia)")]
    [SerializeField] private float rainIntensityEnd = 0f;
    
    [Header("Lighthouse Settings")]
    [SerializeField] private bool controlLighthouse = true;
    [Tooltip("Intensidad del faro al inicio (tenue por tormenta)")]
    [SerializeField] private float lighthouseIntensityStart = 1.5f;
    [Tooltip("Intensidad del faro al final (brillante)")]
    [SerializeField] private float lighthouseIntensityEnd = 3f;
    
    [Header("Divine Glow Settings")]
    [SerializeField] private bool controlDivineGlow = true;
    [Tooltip("Intensidad del aura divina al inicio (apagado)")]
    [SerializeField] private float glowIntensityStart = 0f;
    [Tooltip("Intensidad del aura divina al final (brillante)")]
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
    
    // Estado actual de cada efecto
    private float currentFogDensity;
    private float currentLightIntensity;
    private float currentRainIntensity;
    private float currentLighthouseIntensity;
    private float currentGlowIntensity;

    #region Unity Lifecycle
    private void Start()
    {
        // Auto-encontrar componentes si no están asignados
        if (autoFindComponents)
        {
            if (grayscaleEffect == null)
                grayscaleEffect = Camera.main?.GetComponent<GrayscalePostProcessing>();
            
            if (directionalLight == null)
                directionalLight = FindObjectOfType<Light>();
            
            if (lighthouseLight == null)
                lighthouseLight = FindObjectOfType<LighthouseRotation>();
            
            if (rainController == null)
                rainController = FindObjectOfType<RainController>();
        }
        
        // Configurar fog inicial
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
    /// <summary>
    /// Inicia la secuencia completa desde el estado de tormenta
    /// </summary>
    public void StartSequence()
    {
        if (grayscaleEffect == null)
        {
            Debug.LogError("GrayscaleEffect no asignado!");
            return;
        }
        
        // ====== ESTADO INICIAL: TORMENTA ======
        
        // Blanco y negro
        grayscaleEffect.SetIntensity(1f);
        
        // Niebla densa
        if (controlFog)
        {
            SetFogDensity(fogDensityStart);
        }
        
        // Luz baja (tormenta oscura)
        if (controlLight && directionalLight != null)
        {
            directionalLight.intensity = lightIntensityStart;
            directionalLight.color = lightColorStart;
            currentLightIntensity = lightIntensityStart;
        }
        
        // Lluvia fuerte (sincronizada con niebla)
        if (controlRain && rainController != null)
        {
            rainController.SetIntensity(rainIntensityStart);
            currentRainIntensity = rainIntensityStart;
        }
        
        // Faro tenue
        if (controlLighthouse && lighthouseLight != null)
        {
            lighthouseLight.SetLightIntensity(lighthouseIntensityStart);
            currentLighthouseIntensity = lighthouseIntensityStart;
        }
        
        // Divine Glow apagado
        if (controlDivineGlow)
        {
            WaterFoamManager.Instance.SetGlowIntensity(glowIntensityStart);
            currentGlowIntensity = glowIntensityStart;
        }
        
        if (showDebugInfo)
        {
            Debug.Log($"=== ESCENA INICIADA: ESTADO TORMENTA ===");
            Debug.Log($"Transición programada en {delayBeforeTransition}s");
        }
        
        // Programar la transición a día soleado
        Invoke(nameof(StartColorTransition), delayBeforeTransition);
    }

    /// <summary>
    /// Reinicia la secuencia completa
    /// </summary>
    public void RestartSequence()
    {
        CancelInvoke();
        isTransitioning = false;
        StartSequence();
    }

    /// <summary>
    /// Inicia la transición de tormenta a día soleado
    /// </summary>
    public void StartColorTransition()
    {
        if (grayscaleEffect == null) return;
        
        StartTransition(targetValue: 0f);
        
        if (showDebugInfo)
            Debug.Log($"=== INICIANDO TRANSICIÓN A DÍA SOLEADO ({transitionDuration}s) ===");
    }

    /// <summary>
    /// Transición inversa (de día a tormenta)
    /// </summary>
    public void StartGrayscaleTransition()
    {
        if (grayscaleEffect == null) return;
        
        StartTransition(targetValue: 1f);
        
        if (showDebugInfo)
            Debug.Log($"=== INICIANDO TRANSICIÓN A TORMENTA ({transitionDuration}s) ===");
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
        
        // Actualizar todos los efectos sincronizados
        if (controlFog)
            UpdateFogDensity(curveValue);
        
        if (controlRain)
            UpdateRain(curveValue);
        
        if (controlLight)
            UpdateLight(curveValue);
        
        if (controlLighthouse)
            UpdateLighthouse(curveValue);
        
        if (controlDivineGlow)
            UpdateDivineGlow(curveValue);
        
        // Finalizar transición
        if (normalizedTime >= 1f)
        {
            grayscaleEffect.SetIntensity(transitionTargetValue);
            isTransitioning = false;
            
            if (showDebugInfo)
                Debug.Log($"=== TRANSICIÓN COMPLETADA ===");
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
            // Transición a color: niebla se despeja (tormenta → día)
            fogIntensity = Mathf.Lerp(fogDensityStart, fogDensityEnd, curveValue);
        }
        else
        {
            // Transición a B&N: niebla aumenta (día → tormenta)
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

    #region Private Methods - Rain
    private void UpdateRain(float curveValue)
    {
        if (rainController == null) return;
        
        if (transitionTargetValue < transitionStartValue)
        {
            // Transición a color: lluvia disminuye (sincronizada con niebla)
            currentRainIntensity = Mathf.Lerp(rainIntensityStart, rainIntensityEnd, curveValue);
        }
        else
        {
            // Transición a B&N: lluvia aumenta
            currentRainIntensity = Mathf.Lerp(rainIntensityEnd, rainIntensityStart, curveValue);
        }
        
        rainController.SetIntensity(currentRainIntensity);
    }
    #endregion

    #region Private Methods - Light
    private void UpdateLight(float curveValue)
    {
        if (directionalLight == null) return;
        
        if (transitionTargetValue < transitionStartValue)
        {
            // Transición a color: sol sale (aumenta intensidad y calidez)
            currentLightIntensity = Mathf.Lerp(lightIntensityStart, lightIntensityEnd, curveValue);
            directionalLight.intensity = currentLightIntensity;
            directionalLight.color = Color.Lerp(lightColorStart, lightColorEnd, curveValue);
        }
        else
        {
            // Transición a B&N: sol se oculta
            currentLightIntensity = Mathf.Lerp(lightIntensityEnd, lightIntensityStart, curveValue);
            directionalLight.intensity = currentLightIntensity;
            directionalLight.color = Color.Lerp(lightColorEnd, lightColorStart, curveValue);
        }
    }
    #endregion

    #region Private Methods - Lighthouse
    private void UpdateLighthouse(float curveValue)
    {
        if (lighthouseLight == null) return;
        
        if (transitionTargetValue < transitionStartValue)
        {
            // Transición a color: faro más brillante (sale el sol, faro destaca más)
            currentLighthouseIntensity = Mathf.Lerp(lighthouseIntensityStart, lighthouseIntensityEnd, curveValue);
        }
        else
        {
            // Transición a B&N: faro más tenue (tormenta lo atenúa)
            currentLighthouseIntensity = Mathf.Lerp(lighthouseIntensityEnd, lighthouseIntensityStart, curveValue);
        }
        
        lighthouseLight.SetLightIntensity(currentLighthouseIntensity);
    }
    #endregion

    #region Private Methods - Divine Glow
    private void UpdateDivineGlow(float curveValue)
    {
        if (transitionTargetValue < transitionStartValue)
        {
            // Transición a color: aura divina aparece (barco "elegido" cuando sale el sol)
            currentGlowIntensity = Mathf.Lerp(glowIntensityStart, glowIntensityEnd, curveValue);
        }
        else
        {
            // Transición a B&N: aura desaparece
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
        
        GUILayout.BeginArea(new Rect(10, 10, 480, 450));
        GUILayout.Box("=== CONTROL DE ESCENA CINEMATOGRÁFICA ===", GUILayout.Width(470));
        
        GUILayout.Label($"Tiempo transcurrido: {Time.timeSinceLevelLoad:F1}s");
        GUILayout.Label($"Estado: {(isTransitioning ? "⚡ TRANSICIONANDO" : "⏸ Esperando")}");
        
        if (isTransitioning)
        {
            float progress = Mathf.Clamp01((Time.time - transitionStartTime) / transitionDuration);
            GUILayout.Label($"Progreso: {progress * 100:F0}%");
        }
        
        GUILayout.Space(10);
        GUILayout.Label("=== ESTADO ACTUAL ===");
        
        if (grayscaleEffect != null)
            GUILayout.Label($"🎨 Blanco y Negro: {grayscaleEffect.GetIntensity():F2}");
        
        if (controlFog)
            GUILayout.Label($"🌫 Niebla: {currentFogDensity:F4}");
        
        if (controlRain && rainController != null)
            GUILayout.Label($"🌧 Lluvia: {currentRainIntensity:F2}");
        
        if (controlLight && directionalLight != null)
            GUILayout.Label($"☀ Luz Solar: {currentLightIntensity:F2}");
        
        if (controlLighthouse && lighthouseLight != null)
            GUILayout.Label($"🔦 Faro: {currentLighthouseIntensity:F2}");
        
        if (controlDivineGlow)
            GUILayout.Label($"✨ Aura Divina: {currentGlowIntensity:F2}");
        
        GUILayout.Space(15);
        GUILayout.Label("=== CONTROLES MANUALES ===");
        
        if (GUILayout.Button("🔄 Reiniciar Secuencia Completa", GUILayout.Height(30)))
            RestartSequence();
        
        if (GUILayout.Button("☀ Transición: TORMENTA → DÍA SOLEADO", GUILayout.Height(30)))
        {
            CancelInvoke();
            StartColorTransition();
        }
        
        if (GUILayout.Button("⛈ Transición: DÍA SOLEADO → TORMENTA", GUILayout.Height(30)))
        {
            CancelInvoke();
            StartGrayscaleTransition();
        }
        
        GUILayout.EndArea();
    }
#endif
    #endregion
}