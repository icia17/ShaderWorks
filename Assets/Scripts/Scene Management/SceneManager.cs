using UnityEngine;
using SceneManagerUnity = UnityEngine.SceneManagement.SceneManager;

public class SceneManager : MonoBehaviour
{
    public static SceneManager Instance { get; private set; }

    private int currentScene;

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        Instance = this;
        DontDestroyOnLoad(gameObject);

        // Initialize with active scene index
        currentScene = SceneManagerUnity.GetActiveScene().buildIndex;
    }

    public void ChangeScene(int direction)
    {
        int totalScenes = SceneManagerUnity.sceneCountInBuildSettings;

        // Update index
        currentScene += direction;

        // Wrap around if needed
        if (currentScene < 0)
            currentScene = totalScenes - 1;
        else if (currentScene >= totalScenes)
            currentScene = 0;

        // Load new scene
        SceneManagerUnity.LoadScene(currentScene);
    }
}
