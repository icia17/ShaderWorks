using UnityEngine;

/// <summary>
/// Componente que hace que un barco genere espuma en el agua
/// Implementa IFoamGenerator para integrarse con el WaterFoamManager
/// </summary>
[RequireComponent(typeof(Collider))]
public class BoatFoamGenerator : MonoBehaviour, IFoamGenerator
{
    [Header("Foam Settings")]
    [Tooltip("Radio de espuma alrededor del barco")]
    [SerializeField] private float foamRadius = 3f;
    
    [Tooltip("Offset vertical para la posición de espuma (ajustar según la profundidad del barco)")]
    [SerializeField] private float verticalOffset = -0.5f;
    
    [Header("Detection Settings")]
    [Tooltip("Tag del agua para detectar colisión")]
    [SerializeField] private string waterTag = "Water";
    
    [Tooltip("Layer del agua (alternativa al tag)")]
    [SerializeField] private LayerMask waterLayer;
    
    [Header("Debug")]
    [SerializeField] private bool showDebugGizmos = true;
    [SerializeField] private Color gizmoColor = new Color(0, 1, 1, 0.3f);
    
    // Estado interno
    private bool isOnWater = false;
    private Vector3 foamPosition;
    private Collider boatCollider;

    #region Unity Lifecycle
    private void Awake()
    {
        boatCollider = GetComponent<Collider>();
        
        // Asegurar que el collider es trigger
        if (!boatCollider.isTrigger)
        {
            Debug.LogWarning($"El Collider de {gameObject.name} no es Trigger. " +
                           "Cambiándolo a Trigger para detectar agua correctamente.");
            boatCollider.isTrigger = true;
        }
    }

    private void Start()
    {
        // Registrarse con el manager
        WaterFoamManager.Instance.RegisterFoamGenerator(this);
        Debug.Log($"{gameObject.name} registrado como generador de espuma");
    }

    private void Update()
    {
        // Actualizar posición de espuma basada en la posición actual del barco
        if (isOnWater)
        {
            UpdateFoamPosition();
        }
    }

    private void OnDestroy()
    {
        // Desregistrarse al destruirse
        if (WaterFoamManager.Instance != null)
        {
            WaterFoamManager.Instance.UnregisterFoamGenerator(this);
        }
    }
    #endregion

    #region Collision Detection
    private void OnTriggerEnter(Collider other)
    {
        if (IsWater(other))
        {
            isOnWater = true;
            Debug.Log($"{gameObject.name} entró al agua");
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (IsWater(other))
        {
            isOnWater = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (IsWater(other))
        {
            isOnWater = false;
            Debug.Log($"{gameObject.name} salió del agua");
        }
    }

    /// <summary>
    /// Verifica si un collider es agua
    /// </summary>
    private bool IsWater(Collider other)
    {
        // Verificar por tag
        if (!string.IsNullOrEmpty(waterTag) && other.CompareTag(waterTag))
        {
            return true;
        }
        
        // Verificar por layer
        if (waterLayer == (waterLayer | (1 << other.gameObject.layer)))
        {
            return true;
        }
        
        return false;
    }
    #endregion

    #region IFoamGenerator Implementation
    public Vector3 GetFoamPosition()
    {
        return foamPosition;
    }

    public bool IsActive()
    {
        return isOnWater && gameObject.activeInHierarchy;
    }

    public float GetFoamRadius()
    {
        return foamRadius;
    }
    #endregion

    #region Private Methods
    /// <summary>
    /// Actualiza la posición donde se genera la espuma
    /// </summary>
    private void UpdateFoamPosition()
    {
        // Usar la posición inferior del barco como punto de espuma
        foamPosition = transform.position + Vector3.up * verticalOffset;
    }
    #endregion

    #region Debug
    private void OnDrawGizmos()
    {
        if (!showDebugGizmos) return;

        // Visualizar el radio de espuma
        Gizmos.color = gizmoColor;
        Vector3 debugPos = Application.isPlaying ? foamPosition : (transform.position + Vector3.up * verticalOffset);
        Gizmos.DrawWireSphere(debugPos, foamRadius);
        
        // Línea desde el centro del barco hasta el punto de espuma
        Gizmos.color = Color.cyan;
        Gizmos.DrawLine(transform.position, debugPos);
    }
    #endregion
}