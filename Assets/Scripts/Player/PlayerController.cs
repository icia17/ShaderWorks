using UnityEngine;
using UnityEngine.InputSystem;

[RequireComponent(typeof(Rigidbody))]
public class PlayerController : MonoBehaviour
{
    [Header("Input Actions")]
    [SerializeField] private InputActionReference moveAction;
    [SerializeField] private InputActionReference lookAction;
    [SerializeField] private InputActionReference sceneChangeAction;
    [SerializeField] private InputActionReference escapeAction;
    [SerializeField] private Transform cameraTransform;

    [Header("Movement Settings")]
    [SerializeField] private float moveSpeed = 5f;

    [Header("Rotation Settings")]
    [SerializeField] private float lookSensitivity = 2f;
    [SerializeField] private float minPitch = -80f;
    [SerializeField] private float maxPitch = 80f;
    [SerializeField] private float rotationSmooth = 10f;

    [Header("Mouse Mode Settings")]
    [SerializeField] private bool startWithMouseLocked = true;

    private Rigidbody rb;
    private Vector2 moveInput;
    private Vector2 lookInput;

    private float targetYaw;  
    private float targetPitch;

    private float currentYaw; 
    private float currentPitch;

    private bool isMouseControlEnabled = true; // Track mouse control state
    private bool wasMouseControlEnabled; // To detect state changes

    private void OnEnable()
    {
        moveAction.action.Enable();
        lookAction.action.Enable();
        sceneChangeAction.action.performed += HandleSceneChanging;
        escapeAction.action.performed += HandleEscapeToggle; // Enable ESC action
    }

    private void OnDisable()
    {
        moveAction.action.Disable();
        lookAction.action.Disable();
        sceneChangeAction.action.performed -= HandleSceneChanging;
        escapeAction.action.performed -= HandleEscapeToggle; // Disable ESC action
    }

    private void Start()
    {
        rb = GetComponent<Rigidbody>();
        rb.freezeRotation = true;
        
        // Set initial mouse state
        isMouseControlEnabled = startWithMouseLocked;
        wasMouseControlEnabled = isMouseControlEnabled;
        UpdateCursorState();

        // Initialize targets
        targetYaw = transform.eulerAngles.y;
        targetPitch = cameraTransform.localEulerAngles.x;
        currentYaw = targetYaw;
        currentPitch = targetPitch;
    }

    private void Update()
    {
        moveInput = moveAction.action.ReadValue<Vector2>();
        
        // Only read look input if mouse control is enabled
        if (isMouseControlEnabled)
        {
            lookInput = lookAction.action.ReadValue<Vector2>();
        }
        else
        {
            lookInput = Vector2.zero;
        }

        HandleRotation();
        
        // Check if we need to update cursor state
        if (wasMouseControlEnabled != isMouseControlEnabled)
        {
            UpdateCursorState();
            wasMouseControlEnabled = isMouseControlEnabled;
        }
    }

    private void FixedUpdate()
    {
        HandleMovement();
    }

    private void HandleMovement()
    {
        Vector3 moveDir = cameraTransform.right * moveInput.x + cameraTransform.forward * moveInput.y;
        rb.MovePosition(rb.position + moveDir * moveSpeed * Time.fixedDeltaTime);
    }

    private void HandleRotation()
    {
        // Only handle rotation if mouse control is enabled
        if (isMouseControlEnabled)
        {
            // Update target yaw & pitch based on input
            targetYaw += lookInput.x * lookSensitivity;
            targetPitch -= lookInput.y * lookSensitivity;
            targetPitch = Mathf.Clamp(targetPitch, minPitch, maxPitch);

            // Smoothly interpolate toward targets
            currentYaw = Mathf.LerpAngle(currentYaw, targetYaw, rotationSmooth * Time.deltaTime);
            currentPitch = Mathf.LerpAngle(currentPitch, targetPitch, rotationSmooth * Time.deltaTime);

            // Apply yaw to body
            transform.rotation = Quaternion.Euler(0f, currentYaw, 0f);

            // Apply pitch to camera
            cameraTransform.localRotation = Quaternion.Euler(currentPitch, 0f, 0f);
        }
    }

    private void HandleSceneChanging(InputAction.CallbackContext ctx)
    {
        var currentSceneChangeInput = ctx.action.ReadValue<float>();

        if (Mathf.Abs(currentSceneChangeInput) > 0.1f)
        {
            SceneManager.Instance.ChangeScene(Mathf.RoundToInt(currentSceneChangeInput));
        }
    }

    private void HandleEscapeToggle(InputAction.CallbackContext ctx)
    {
        // Toggle mouse control state
        isMouseControlEnabled = !isMouseControlEnabled;
        
        Debug.Log($"Mouse control {(isMouseControlEnabled ? "enabled" : "disabled")}");
    }

    private void UpdateCursorState()
    {
        if (isMouseControlEnabled)
        {
            // Lock cursor for game control
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }
        else
        {
            // Free cursor for UI interaction
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;
        }
    }

    // Public method to set mouse control state (useful for UI buttons)
    public void SetMouseControlEnabled(bool enabled)
    {
        isMouseControlEnabled = enabled;
    }

    // Public method to get current mouse control state
    public bool IsMouseControlEnabled()
    {
        return isMouseControlEnabled;
    }

    // Public method to toggle mouse control (can be called from UI or other scripts)
    public void ToggleMouseControl()
    {
        isMouseControlEnabled = !isMouseControlEnabled;
    }
}