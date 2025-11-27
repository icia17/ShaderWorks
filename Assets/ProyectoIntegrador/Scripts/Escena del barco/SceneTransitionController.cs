using UnityEngine;

/// <summary>
/// Controla la secuencia temporal de la escena y las transiciones de efectos.
/// Maneja la transición de blanco y negro a color después de un tiempo.
/// </summary>
public class SceneTransitionController : MonoBehaviour
{
    [Header("References")] [Tooltip("Script de post-processing de la cámara")] [SerializeField]
    private GrayscalePostProcessing grayscaleEffect;

    [Header("Timeline Settings")] [Tooltip("Tiempo en segundos antes de empezar la transición")] [SerializeField]
    private float delayBeforeTransition = 3f;

    [Tooltip("Duración de la transición de B&N a color")] [SerializeField]
    private float transitionDuration = 2f;

    [Tooltip("Curva de animación para la transición")] [SerializeField]
    private AnimationCurve transitionCurve = AnimationCurve.EaseInOut(0, 0, 1, 1);

    [Header("Auto Setup")] [Tooltip("Buscar automáticamente el componente si no está asignado")] [SerializeField]
    private bool autoFindComponents = true;

    [Header("Debug")] [SerializeField] private bool showDebugInfo = true;

    // Estado de la transición
    private bool isTransitioning = false;
    private float transitionStartTime;
    private float transitionStartValue;
    private float transitionTargetValue;

    #region Unity Lifecycle

    private void Start()
    {
        // Auto-encontrar componentes si es necesario
        if (autoFindComponents && grayscaleEffect == null)
        {
            grayscaleEffect = Camera.main?.GetComponent<GrayscalePostProcessing>();

            if (grayscaleEffect == null)
            {
                Debug.LogError("No se encontró GrayscalePostProcessing en la Main Camera!");
                return;
            }
            else if (showDebugInfo)
            {
                Debug.Log("GrayscalePostProcessing encontrado automáticamente");
            }
        }

        // Iniciar la secuencia
        StartSequence();
    }

    private void Update()
    {
        // Actualizar transición si está activa
        if (isTransitioning)
        {
            UpdateTransition();
        }
    }

    #endregion

    #region Public Methods

    /// <summary>
    /// Inicia la secuencia completa de la escena
    /// </summary>
    public void StartSequence()
    {
        if (grayscaleEffect == null)
        {
            Debug.LogError("GrayscaleEffect no asignado!");
            return;
        }

        // Asegurar que empiece en blanco y negro
        grayscaleEffect.SetIntensity(1f);

        if (showDebugInfo)
            Debug.Log($"Escena iniciada en blanco y negro. Transición en {delayBeforeTransition}s");

        // Programar la transición a color
        Invoke(nameof(StartColorTransition), delayBeforeTransition);
    }

    /// <summary>
    /// Reinicia la secuencia desde el inicio
    /// </summary>
    public void RestartSequence()
    {
        CancelInvoke();
        isTransitioning = false;
        StartSequence();
    }

    /// <summary>
    /// Inicia la transición a color
    /// </summary>
    public void StartColorTransition()
    {
        if (grayscaleEffect == null) return;

        StartTransition(targetValue: 0f);

        if (showDebugInfo)
            Debug.Log($"Iniciando transición a color ({transitionDuration}s)");
    }

    /// <summary>
    /// Inicia la transición a blanco y negro
    /// </summary>
    public void StartGrayscaleTransition()
    {
        if (grayscaleEffect == null) return;

        StartTransition(targetValue: 1f);

        if (showDebugInfo)
            Debug.Log($"Iniciando transición a blanco y negro ({transitionDuration}s)");
    }

    #endregion

    #region Private Methods

    /// <summary>
    /// Inicia una transición hacia un valor objetivo
    /// </summary>
    private void StartTransition(float targetValue)
    {
        transitionStartValue = grayscaleEffect.GetIntensity();
        transitionTargetValue = Mathf.Clamp01(targetValue);
        transitionStartTime = Time.time;
        isTransitioning = true;
    }

    /// <summary>
    /// Actualiza el progreso de la transición cada frame
    /// </summary>
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

        // Interpolar entre valor inicial y objetivo
        float currentIntensity = Mathf.Lerp(transitionStartValue, transitionTargetValue, curveValue);
        grayscaleEffect.SetIntensity(currentIntensity);

        // Finalizar transición si completó
        if (normalizedTime >= 1f)
        {
            grayscaleEffect.SetIntensity(transitionTargetValue);
            isTransitioning = false;

            if (showDebugInfo)
                Debug.Log($"Transición completada. Intensidad final: {transitionTargetValue:F2}");
        }
    }

    #endregion

    #region Editor Helpers

#if UNITY_EDITOR
    /// <summary>
    /// Información de debug en pantalla
    /// </summary>
    private void OnGUI()
    {
        if (!Application.isPlaying || !showDebugInfo) return;

        // Panel de información
        GUILayout.BeginArea(new Rect(10, 10, 350, 200));
        GUILayout.Box("Scene Transition Controller", GUILayout.Width(340));

        GUILayout.Label($"Tiempo transcurrido: {Time.timeSinceLevelLoad:F1}s");
        GUILayout.Label($"Transición programada en: {delayBeforeTransition}s");
        GUILayout.Label($"Estado: {(isTransitioning ? "Transicionando" : "Esperando")}");

        if (grayscaleEffect != null)
        {
            GUILayout.Label($"Intensidad actual: {grayscaleEffect.GetIntensity():F2}");
        }

        GUILayout.Space(10);

        // Botones de control
        if (GUILayout.Button("Reiniciar Secuencia"))
        {
            RestartSequence();
        }

        if (GUILayout.Button("Transición a Color (Inmediata)"))
        {
            CancelInvoke();
            StartColorTransition();
        }

        if (GUILayout.Button("Transición a B&N (Inmediata)"))
        {
            CancelInvoke();
            StartGrayscaleTransition();
        }

        GUILayout.EndArea();
    }
}
#endif
    #endregion
