using UnityEngine;

[RequireComponent(typeof(Collider))]
public class WaveImpactCollision : MonoBehaviour
{
    [Header("Referencias")]
    [SerializeField] private Material waveMaterial;
    
    [Header("Configuración")]
    [SerializeField] private LayerMask impactLayers = -1;
    [SerializeField] private string impactPointPropertyName = "_ImpactPoint";
    [SerializeField] private float minimumImpactVelocity = 0.1f;
    
    [Header("Opciones de Material")]
    [Tooltip("Usar material compartido (afecta a todos los objetos con ese material)")]
    [SerializeField] private bool useSharedMaterial = true;
    
    [Header("Debug")]
    [SerializeField] private bool showDebugLogs = true;
    [SerializeField] private bool showImpactGizmo = true;
    
    private int impactPointID;
    private Vector3 currentImpactPoint;
    private bool hasActiveImpact;
    private float lastImpactTime;
    private Material targetMaterial;
    
    private void Awake()
    {
        impactPointID = Shader.PropertyToID(impactPointPropertyName);
    }
    
    private void Start()
    {
        if (waveMaterial == null)
        {
            // Intentar obtener el material del renderer
            Renderer rend = GetComponent<Renderer>();
            if (rend != null)
            {
                waveMaterial = useSharedMaterial ? rend.sharedMaterial : rend.material;
                Debug.Log($"[WaveImpact] Material obtenido del Renderer: {waveMaterial.name}");
            }
            else
            {
                Debug.LogError($"[WaveImpact] ¡No se asignó Wave Material y no se pudo obtener del Renderer!");
                enabled = false;
                return;
            }
        }
        
        // Usar el material apropiado
        targetMaterial = waveMaterial;
        
        // Verificar que tiene la propiedad
        if (!targetMaterial.HasProperty(impactPointID))
        {
            Debug.LogError($"[WaveImpact] El material '{targetMaterial.name}' NO tiene la propiedad '{impactPointPropertyName}'");
            
            // Intentar con nombre alternativo
            int altID = Shader.PropertyToID("_impactPoint");
            if (targetMaterial.HasProperty(altID))
            {
                Debug.LogWarning($"[WaveImpact] Pero SÍ tiene '_impactPoint' (minúscula). Usando ese.");
                impactPointID = altID;
            }
            else
            {
                enabled = false;
                return;
            }
        }
        
        // Inicializar
        currentImpactPoint = new Vector3(0, -1000, 0);
        targetMaterial.SetVector(impactPointID, currentImpactPoint);
        
        if (showDebugLogs)
        {
            Debug.Log($"[WaveImpact] ✓ Inicializado");
            Debug.Log($"[WaveImpact] Material: {targetMaterial.name}");
            Debug.Log($"[WaveImpact] Propiedad: {impactPointPropertyName} (ID: {impactPointID})");
        }
    }
    
    private void OnCollisionEnter(Collision collision)
    {
        if (showDebugLogs)
        {
            Debug.Log($"[WaveImpact] ¡Colisión con {collision.gameObject.name}!");
        }
        
        // Verificar capa
        if (((1 << collision.gameObject.layer) & impactLayers) == 0)
        {
            if (showDebugLogs)
                Debug.LogWarning($"[WaveImpact] Capa no coincide");
            return;
        }
        
        // Verificar velocidad
        float velocity = collision.relativeVelocity.magnitude;
        if (showDebugLogs)
            Debug.Log($"[WaveImpact] Velocidad: {velocity:F2}");
        
        if (velocity < minimumImpactVelocity)
        {
            if (showDebugLogs)
                Debug.LogWarning($"[WaveImpact] Muy lento");
            return;
        }
        
        // Registrar
        if (collision.contacts.Length > 0)
        {
            Vector3 point = collision.contacts[0].point;
            RegisterImpact(point);
        }
    }
    
    private void RegisterImpact(Vector3 point)
    {
        currentImpactPoint = point;
        lastImpactTime = Time.time;
        hasActiveImpact = true;
        
        // ENVIAR AL SHADER
        targetMaterial.SetVector(impactPointID, currentImpactPoint);
        
        if (showDebugLogs)
        {
            Debug.Log($"[WaveImpact] ✓✓✓ IMPACTO EN: {point} ✓✓✓");
            Vector4 valor = targetMaterial.GetVector(impactPointID);
            Debug.Log($"[WaveImpact] Verificación - Valor en shader: {valor}");
        }
    }
    
    private void OnDrawGizmos()
    {
        if (!showImpactGizmo || !hasActiveImpact)
            return;
        
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(currentImpactPoint, 0.5f);
        Gizmos.DrawSphere(currentImpactPoint, 0.15f);
        
        Gizmos.color = Color.yellow;
        Gizmos.DrawLine(currentImpactPoint, currentImpactPoint + Vector3.up * 2f);
    }
}