using UnityEngine;

public class UISwitcher : MonoBehaviour
{
    public static UISwitcher Instance { get; private set; }

    [SerializeField] private GameObject[] panels;
    private int currentIndex = 0;

    private CanvasGroup _canvasGroup;
    private bool visible = false;
    
    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;

        _canvasGroup = GetComponent<CanvasGroup>();
    }

    private void Start()
    {
        // Start by showing only the first panel
        SwitchTo(0);
    }

    public void SwitchVisibility()
    {
        visible = !visible;
        
        _canvasGroup.alpha = visible ? 1f : 0f;
        _canvasGroup.interactable = visible;
        
        Canvas.ForceUpdateCanvases();
    }
    
    public void SwitchTo(int index)
    {
        if (index < 0 || index >= panels.Length) return;

        for (int i = 0; i < panels.Length; i++)
        {
            panels[i].SetActive(i == index);
        }

        currentIndex = index;
    }

    public void SwitchToRelative(int direction)
    {
        int newIndex = (currentIndex + direction + panels.Length) % panels.Length;
        SwitchTo(newIndex);
    }
}