using UnityEngine;

public class CameraMovement : MonoBehaviour
{
    [Header("Movement Settings")]
    public float moveSpeed = 5f;
    public float sprintMultiplier = 2f;
    public float lookSpeed = 2f;
    
    [Header("Mouse Settings")]
    public bool invertY = false;
    
    private float rotationX = 0f;
    private float rotationY = 0f;

    void Start()
    {
        // Opcional: Bloquear y ocultar cursor
        // Cursor.lockState = CursorLockMode.Locked;
        // Cursor.visible = false;
        
        // Inicializar rotación
        rotationY = transform.localEulerAngles.y;
    }

    void Update()
    {
        // === MOVIMIENTO ===
        float speed = moveSpeed;
        
        // Sprint con Shift
        if (Input.GetKey(KeyCode.LeftShift))
        {
            speed *= sprintMultiplier;
        }
        
        // WASD Movement
        float horizontal = Input.GetAxis("Horizontal"); // A/D
        float vertical = Input.GetAxis("Vertical");     // W/S
        
        // Subir/Bajar con E/Q
        float upDown = 0f;
        if (Input.GetKey(KeyCode.E)) upDown = 1f;
        if (Input.GetKey(KeyCode.Q)) upDown = -1f;
        
        Vector3 direction = transform.forward * vertical 
                          + transform.right * horizontal
                          + Vector3.up * upDown;
        
        transform.position += direction * speed * Time.deltaTime;

        // === ROTACIÓN CON MOUSE ===
        // Solo rotar si mantienes clic derecho (o siempre, si prefieres)
        if (Input.GetMouseButton(1) || Input.GetKey(KeyCode.LeftAlt))
        {
            float mouseX = Input.GetAxis("Mouse X") * lookSpeed;
            float mouseY = Input.GetAxis("Mouse Y") * lookSpeed;

            if (invertY) mouseY = -mouseY;

            rotationY += mouseX;
            rotationX -= mouseY;
            rotationX = Mathf.Clamp(rotationX, -90f, 90f);

            transform.localRotation = Quaternion.Euler(rotationX, rotationY, 0f);
        }
        
        // Desbloquear cursor con ESC
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;
        }
    }
}
