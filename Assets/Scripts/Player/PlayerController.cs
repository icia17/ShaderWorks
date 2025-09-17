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
    [SerializeField] private InputActionReference switchViewAction; // Q/E switcher
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

    private bool isMouseControlEnabled = true;
    private bool wasMouseControlEnabled;

    private void OnEnable()
    {
        moveAction.action.Enable();
        lookAction.action.Enable();
        sceneChangeAction.action.performed += HandleSceneChanging;
        escapeAction.action.performed += HandleEscapeToggle;
        switchViewAction.action.performed += HandleSwitchView; // Enable Q/E switching
    }

    private void OnDisable()
    {
        moveAction.action.Disable();
        lookAction.action.Disable();
        sceneChangeAction.action.performed -= HandleSceneChanging;
        escapeAction.action.performed -= HandleEscapeToggle;
        switchViewAction.action.performed -= HandleSwitchView;
    }

    private void Start()
    {
        rb = GetComponent<Rigidbody>();
        rb.freezeRotation = true;

        // Set initial mouse state
        isMouseControlEnabled = startWithMouseLocked;
        wasMouseControlEnabled = isMouseControlEnabled;
        UpdateCursorState();

        // Initialize rotation targets
        targetYaw = transform.eulerAngles.y;
        targetPitch = cameraTransform.localEulerAngles.x;
        currentYaw = targetYaw;
        currentPitch = targetPitch;
    }

    private void Update()
    {
        moveInput = moveAction.action.ReadValue<Vector2>();

        if (isMouseControlEnabled)
            lookInput = lookAction.action.ReadValue<Vector2>();
        else
            lookInput = Vector2.zero;

        HandleRotation();

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
        if (isMouseControlEnabled)
        {
            targetYaw += lookInput.x * lookSensitivity;
            targetPitch -= lookInput.y * lookSensitivity;
            targetPitch = Mathf.Clamp(targetPitch, minPitch, maxPitch);

            currentYaw = Mathf.LerpAngle(currentYaw, targetYaw, rotationSmooth * Time.deltaTime);
            currentPitch = Mathf.LerpAngle(currentPitch, targetPitch, rotationSmooth * Time.deltaTime);

            transform.rotation = Quaternion.Euler(0f, currentYaw, 0f);
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
        isMouseControlEnabled = !isMouseControlEnabled;
        
        UISwitcher.Instance.SwitchVisibility();
    }

    private void HandleSwitchView(InputAction.CallbackContext ctx)
    {
        int dir = Mathf.RoundToInt(ctx.ReadValue<float>()); // -1 for Q, +1 for E
        if (dir != 0)
        {
            UISwitcher.Instance.SwitchToRelative(dir);
        }
    }

    private void UpdateCursorState()
    {
        if (isMouseControlEnabled)
        {
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }
        else
        {
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;
        }
    }

    // Public API
    public void SetMouseControlEnabled(bool enabled) => isMouseControlEnabled = enabled;
    public bool IsMouseControlEnabled() => isMouseControlEnabled;
    public void ToggleMouseControl() => isMouseControlEnabled = !isMouseControlEnabled;
}
