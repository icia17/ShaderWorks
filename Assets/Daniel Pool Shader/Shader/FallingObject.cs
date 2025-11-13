using UnityEngine;


[RequireComponent(typeof(Rigidbody))]
[RequireComponent(typeof(Collider))]
public class FallingObject : MonoBehaviour
{
    [Header("Configuración")]
    [Tooltip("Altura inicial al resetear")]
    [SerializeField] private float resetHeight = 5f;
    
    [Tooltip("Auto-resetear después de X segundos")]
    [SerializeField] private bool autoReset = true;
    
    [SerializeField] private float resetDelay = 3f;
    
    [Header("Control de Posición de Spawn")]
    [Tooltip("Permitir mover la posición de spawn")]
    [SerializeField] private bool allowMoveSpawn = true;
    
    [Tooltip("Velocidad de movimiento de la posición de spawn")]
    [SerializeField] private float spawnMoveSpeed = 5f;
    
    [Tooltip("Límites de movimiento en X")]
    [SerializeField] private Vector2 xLimits = new Vector2(-10f, 10f);
    
    [Tooltip("Límites de movimiento en Z")]
    [SerializeField] private Vector2 zLimits = new Vector2(-10f, 10f);
    
    [Header("Teclas")]
    [Tooltip("Tecla para resetear manualmente")]
    [SerializeField] private KeyCode resetKey = KeyCode.R;
    
    [Tooltip("Modo de edición de spawn (mantener presionada)")]
    [SerializeField] private KeyCode editSpawnKey = KeyCode.LeftShift;
    
    [Tooltip("Guardar nueva posición de spawn")]
    [SerializeField] private KeyCode saveSpawnKey = KeyCode.S;
    
    private Rigidbody rb;
    private Vector3 spawnPosition; 
    private Quaternion initialRotation;
    private float impactTime;
    private bool hasImpacted;
    private bool isEditingSpawn;
    
    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
        
        
        spawnPosition = transform.position;
        initialRotation = transform.rotation;
    }
    
    private void Start()
    {
     
        if (rb != null)
        {
            rb.useGravity = true;
            rb.mass = 1f;
        }
    }
    
    private void Update()
    {
       
        isEditingSpawn = Input.GetKey(editSpawnKey);
        
      
        if (allowMoveSpawn && isEditingSpawn)
        {
            MoveSpawnPosition();
        }
        
      
        if (Input.GetKeyDown(saveSpawnKey) && isEditingSpawn)
        {
            SaveCurrentAsSpawn();
        }
        
        
        if (Input.GetKeyDown(resetKey))
        {
            ResetPosition();
        }
        
     
        if (autoReset && hasImpacted && Time.time - impactTime > resetDelay)
        {
            ResetPosition();
        }
    }
    
  
    private void MoveSpawnPosition()
    {
        float moveX = 0f;
        float moveZ = 0f;
        
     
        if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.LeftArrow))
            moveX = -1f;
        else if (Input.GetKey(KeyCode.D) || Input.GetKey(KeyCode.RightArrow))
            moveX = 1f;
        
       
        if (Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.UpArrow))
            moveZ = 1f;
        else if (Input.GetKey(KeyCode.S) || Input.GetKey(KeyCode.DownArrow))
            moveZ = -1f;
        
   
        if (moveX != 0f || moveZ != 0f)
        {
            Vector3 movement = new Vector3(moveX, 0f, moveZ) * spawnMoveSpeed * Time.deltaTime;
            spawnPosition += movement;
            
            
            spawnPosition.x = Mathf.Clamp(spawnPosition.x, xLimits.x, xLimits.y);
            spawnPosition.z = Mathf.Clamp(spawnPosition.z, zLimits.x, zLimits.y);
            
            Debug.Log($"Nueva posición de spawn: {spawnPosition}");
        }
    }
    
    
    private void SaveCurrentAsSpawn()
    {
        spawnPosition = transform.position;
        spawnPosition.y = transform.position.y; 
        
        Debug.Log($"✓ Posición de spawn guardada: {spawnPosition}");
    }
    
    private void OnCollisionEnter(Collision collision)
    {
        
        if (!hasImpacted)
        {
            hasImpacted = true;
            impactTime = Time.time;
        }
    }
    
 
    public void ResetPosition()
    {
    
        transform.position = spawnPosition + Vector3.up * resetHeight;
        transform.rotation = initialRotation;
        

        if (rb != null)
        {
            rb.velocity = Vector3.zero;
            rb.angularVelocity = Vector3.zero;
        }
        
        hasImpacted = false;
        
        Debug.Log($"Objeto reseteado a: {transform.position}");
    }
    
 
    public void SetSpawnPosition(Vector3 newPosition)
    {
        spawnPosition = newPosition;
    }
    
   
    public Vector3 GetSpawnPosition()
    {
        return spawnPosition;
    }
    

    private void OnDrawGizmos()
    {
  
        Gizmos.color = isEditingSpawn ? Color.yellow : Color.green;
        
      
        Vector3 spawnPos = Application.isPlaying ? spawnPosition : transform.position;
        Vector3 spawnWithHeight = spawnPos + Vector3.up * resetHeight;
        
        
        Gizmos.DrawWireSphere(spawnWithHeight, 0.5f);
        
    
        Gizmos.DrawLine(spawnWithHeight, spawnPos);
        
      
        float crossSize = 0.5f;
        Gizmos.DrawLine(spawnPos + Vector3.left * crossSize, spawnPos + Vector3.right * crossSize);
        Gizmos.DrawLine(spawnPos + Vector3.forward * crossSize, spawnPos + Vector3.back * crossSize);
        
      
        Gizmos.color = Color.cyan;
        Vector3 center = new Vector3((xLimits.x + xLimits.y) / 2f, spawnPos.y, (zLimits.x + zLimits.y) / 2f);
        Vector3 size = new Vector3(xLimits.y - xLimits.x, 0.1f, zLimits.y - zLimits.x);
        Gizmos.DrawWireCube(center, size);
    }
    
    private void OnDrawGizmosSelected()
    {
        
        Gizmos.color = Color.red;
        Vector3 spawnPos = Application.isPlaying ? spawnPosition : transform.position;
        
        
        Gizmos.DrawRay(spawnPos + Vector3.up * resetHeight, Vector3.down * resetHeight);
    }
}