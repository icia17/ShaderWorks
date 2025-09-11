using UnityEngine;
using UnityEngine.InputSystem;

[RequireComponent(typeof(Rigidbody))]
public class PlayerController : MonoBehaviour
{
    [Header("Input Actions")]
    [SerializeField] private InputActionReference moveAction;
    [SerializeField] private InputActionReference lookAction;
    [SerializeField] private InputActionReference sceneChangeAction;
    [SerializeField] private Transform cameraTransform;

    [Header("Movement Settings")]
    [SerializeField] private float moveSpeed = 5f;

    [Header("Rotation Settings")]
    [SerializeField] private float lookSensitivity = 2f;
    [SerializeField] private float minPitch = -80f;
    [SerializeField] private float maxPitch = 80f;
    [SerializeField] private float rotationSmooth = 10f;

    private Rigidbody rb;
    private Vector2 moveInput;
    private Vector2 lookInput;

    private float targetYaw;  
    private float targetPitch;

    private float currentYaw; 
    private float currentPitch; 

    private void OnEnable()
    {
        moveAction.action.Enable();
        lookAction.action.Enable();
        sceneChangeAction.action.performed += HandleSceneChanging;
    }

    private void OnDisable()
    {
        moveAction.action.Disable();
        lookAction.action.Disable();
        sceneChangeAction.action.performed -= HandleSceneChanging;
    }

    private void Start()
    {
        rb = GetComponent<Rigidbody>();
        rb.freezeRotation = true;
        Cursor.lockState = CursorLockMode.Locked;

        // Initialize targets
        targetYaw = transform.eulerAngles.y;
        targetPitch = cameraTransform.localEulerAngles.x;
        currentYaw = targetYaw;
        currentPitch = targetPitch;
    }

    private void Update()
    {
        moveInput = moveAction.action.ReadValue<Vector2>();
        lookInput = lookAction.action.ReadValue<Vector2>();

        HandleRotation();
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

    private void HandleSceneChanging(InputAction.CallbackContext ctx)
    {
        var currentSceneChangeInput = ctx.action.ReadValue<float>();

        if (Mathf.Abs(currentSceneChangeInput) > 0.1f)
        {
            SceneManager.Instance.ChangeScene(Mathf.RoundToInt(currentSceneChangeInput));
        }
    }
}
