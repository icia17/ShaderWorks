using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class DynamicMaterialUI : MonoBehaviour
{
    [Header("Target Material")]
    public Material targetMaterial;
    public Renderer targetRenderer; // Optional: for material instances
    
    [Header("UI Setup")]
    public Transform uiContainer;
    public GameObject floatPrefab;
    public GameObject sliderPrefab;
    public GameObject vector2Prefab;
    public GameObject vector3Prefab;
    public GameObject vector4Prefab;
    public GameObject texturePrefab;
    
    [Header("Material Properties Configuration")]
    public List<MaterialPropertyData> materialProperties = new List<MaterialPropertyData>();
    
    private Material materialInstance;
    private Dictionary<string, GameObject> propertyUIElements = new Dictionary<string, GameObject>();
    
    void Start()
    {
        SetupMaterialInstance();
        CreateDynamicUI();
    }
    
    void SetupMaterialInstance()
    {
        if (targetRenderer != null)
        {
            // Create material instance for this specific object
            materialInstance = targetRenderer.material;
        }
        else if (targetMaterial != null)
        {
            // Create instance of the original material
            materialInstance = new Material(targetMaterial);
        }
        else
        {
            Debug.LogError("No material or renderer assigned!");
            return;
        }
    }
    
    void CreateDynamicUI()
    {
        if (materialInstance == null) return;
        
        // Clear existing UI
        foreach (Transform child in uiContainer)
        {
            DestroyImmediate(child.gameObject);
        }
        propertyUIElements.Clear();
        
        // Create UI for each configured property
        foreach (var propData in materialProperties)
        {
            CreateUIForProperty(propData);
        }
        
        LayoutRebuilder.ForceRebuildLayoutImmediate(uiContainer.GetComponent<RectTransform>());
    }
    
    void CreateUIForProperty(MaterialPropertyData propData)
    {
        GameObject uiElement = null;
        
        switch (propData.propertyType)
        {
            case MaterialPropertyType.Float:
                if (propData.isSlider)
                    uiElement = CreateSliderUI(propData);
                else
                    uiElement = CreateFloatUI(propData);
                break;
            case MaterialPropertyType.Vector2:
                uiElement = CreateVector2UI(propData);
                break;
            case MaterialPropertyType.Vector3:
                uiElement = CreateVector3UI(propData);
                break;
            case MaterialPropertyType.Vector4:
                uiElement = CreateVector4UI(propData);
                break;
            case MaterialPropertyType.Texture:
                uiElement = CreateTextureUI(propData);
                break;
        }
        
        if (uiElement != null)
        {
            propertyUIElements[propData.propertyName] = uiElement;
        }
    }
    
    GameObject CreateFloatUI(MaterialPropertyData propData)
    {
        GameObject floatObj = Instantiate(floatPrefab, uiContainer);
        
        // Set label
        TextMeshProUGUI label = floatObj.transform.Find("Label").GetComponent<TextMeshProUGUI>();
        label.text = propData.displayName;
        
        // Setup input field
        TMP_InputField inputField = floatObj.transform.Find("InputField").GetComponent<TMP_InputField>();
        inputField.text = materialInstance.GetFloat(propData.propertyName).ToString("F2");
        
        inputField.onEndEdit.AddListener(value =>
        {
            if (float.TryParse(value, out float result))
            {
                materialInstance.SetFloat(propData.propertyName, result);
            }
        });
        
        return floatObj;
    }
    
    GameObject CreateSliderUI(MaterialPropertyData propData)
    {
        GameObject sliderObj = Instantiate(sliderPrefab, uiContainer);
        
        // Set label
        TextMeshProUGUI label = sliderObj.transform.Find("Label").GetComponent<TextMeshProUGUI>();
        label.text = propData.displayName;
        
        // Setup slider
        Slider slider = sliderObj.transform.Find("Slider").GetComponent<Slider>();
        slider.minValue = propData.floatRange.x;
        slider.maxValue = propData.floatRange.y;
        slider.value = materialInstance.GetFloat(propData.propertyName);
        
        // Setup value display
        TextMeshProUGUI valueText = sliderObj.transform.Find("ValueText").GetComponent<TextMeshProUGUI>();
        valueText.text = slider.value.ToString("F2");
        
        slider.onValueChanged.AddListener(value =>
        {
            materialInstance.SetFloat(propData.propertyName, value);
            valueText.text = value.ToString("F2");
        });
        
        return sliderObj;
    }
    
    GameObject CreateVector2UI(MaterialPropertyData propData)
    {
        GameObject vector2Obj = Instantiate(vector2Prefab, uiContainer);
        
        // Set label
        TextMeshProUGUI label = vector2Obj.transform.Find("Label").GetComponent<TextMeshProUGUI>();
        label.text = propData.displayName;
        
        // Get current vector value
        Vector4 currentVector = materialInstance.GetVector(propData.propertyName);
        
        // Setup input fields
        TMP_InputField xField = vector2Obj.transform.Find("XField").GetComponent<TMP_InputField>();
        TMP_InputField yField = vector2Obj.transform.Find("YField").GetComponent<TMP_InputField>();
        
        xField.text = currentVector.x.ToString("F2");
        yField.text = currentVector.y.ToString("F2");
        
        System.Action updateVector = () =>
        {
            if (float.TryParse(xField.text, out float x) && 
                float.TryParse(yField.text, out float y))
            {
                materialInstance.SetVector(propData.propertyName, new Vector2(x, y));
            }
        };
        
        xField.onEndEdit.AddListener(value => updateVector());
        yField.onEndEdit.AddListener(value => updateVector());
        
        return vector2Obj;
    }
    
    GameObject CreateVector3UI(MaterialPropertyData propData)
    {
        GameObject vector3Obj = Instantiate(vector3Prefab, uiContainer);
        
        // Set label
        TextMeshProUGUI label = vector3Obj.transform.Find("Label").GetComponent<TextMeshProUGUI>();
        label.text = propData.displayName;
        
        // Get current vector value
        Vector4 currentVector = materialInstance.GetVector(propData.propertyName);
        
        // Setup input fields
        TMP_InputField xField = vector3Obj.transform.Find("XField").GetComponent<TMP_InputField>();
        TMP_InputField yField = vector3Obj.transform.Find("YField").GetComponent<TMP_InputField>();
        TMP_InputField zField = vector3Obj.transform.Find("ZField").GetComponent<TMP_InputField>();
        
        xField.text = currentVector.x.ToString("F2");
        yField.text = currentVector.y.ToString("F2");
        zField.text = currentVector.z.ToString("F2");
        
        System.Action updateVector = () =>
        {
            if (float.TryParse(xField.text, out float x) && 
                float.TryParse(yField.text, out float y) &&
                float.TryParse(zField.text, out float z))
            {
                materialInstance.SetVector(propData.propertyName, new Vector3(x, y, z));
            }
        };
        
        xField.onEndEdit.AddListener(value => updateVector());
        yField.onEndEdit.AddListener(value => updateVector());
        zField.onEndEdit.AddListener(value => updateVector());
        
        return vector3Obj;
    }
    
    GameObject CreateVector4UI(MaterialPropertyData propData)
    {
        GameObject vector4Obj = Instantiate(vector4Prefab, uiContainer);
        
        // Set label
        TextMeshProUGUI label = vector4Obj.transform.Find("Label").GetComponent<TextMeshProUGUI>();
        label.text = propData.displayName;
        
        // Get current vector value
        Vector4 currentVector = materialInstance.GetVector(propData.propertyName);
        
        // Setup input fields
        TMP_InputField xField = vector4Obj.transform.Find("XField").GetComponent<TMP_InputField>();
        TMP_InputField yField = vector4Obj.transform.Find("YField").GetComponent<TMP_InputField>();
        TMP_InputField zField = vector4Obj.transform.Find("ZField").GetComponent<TMP_InputField>();
        TMP_InputField wField = vector4Obj.transform.Find("WField").GetComponent<TMP_InputField>();
        
        xField.text = currentVector.x.ToString("F2");
        yField.text = currentVector.y.ToString("F2");
        zField.text = currentVector.z.ToString("F2");
        wField.text = currentVector.w.ToString("F2");
        
        System.Action updateVector = () =>
        {
            if (float.TryParse(xField.text, out float x) && 
                float.TryParse(yField.text, out float y) &&
                float.TryParse(zField.text, out float z) &&
                float.TryParse(wField.text, out float w))
            {
                materialInstance.SetVector(propData.propertyName, new Vector4(x, y, z, w));
            }
        };
        
        xField.onEndEdit.AddListener(value => updateVector());
        yField.onEndEdit.AddListener(value => updateVector());
        zField.onEndEdit.AddListener(value => updateVector());
        wField.onEndEdit.AddListener(value => updateVector());
        
        return vector4Obj;
    }
    
    GameObject CreateTextureUI(MaterialPropertyData propData)
    {
        GameObject textureObj = Instantiate(texturePrefab, uiContainer);
        
        // Set label
        TextMeshProUGUI label = textureObj.transform.Find("Label").GetComponent<TextMeshProUGUI>();
        label.text = propData.displayName;
        
        // Setup texture preview
        RawImage preview = textureObj.transform.Find("Preview").GetComponent<RawImage>();
        Texture currentTexture = materialInstance.GetTexture(propData.propertyName);
        preview.texture = currentTexture;
        
        // Setup texture selector button
        Button selectButton = textureObj.transform.Find("SelectButton").GetComponent<Button>();
        selectButton.onClick.AddListener(() => OpenTextureSelector(propData.propertyName, preview));
        
        return textureObj;
    }
    
    void OpenTextureSelector(string propertyName, RawImage preview)
    {
        // This would open a texture selection UI
        // For now, we'll create a simple implementation
        // In a real project, you'd want a proper asset browser
        
        // Example: Load from Resources folder
        GameObject selectorPanel = CreateTextureSelectorPanel(propertyName, preview);
        selectorPanel.SetActive(true);
    }
    
    GameObject CreateTextureSelectorPanel(string propertyName, RawImage preview)
    {
        // Create a simple texture selector panel
        GameObject panel = new GameObject("TextureSelector");
        panel.transform.SetParent(uiContainer);
        
        // Add basic UI components for texture selection
        // This is a simplified version - you'd want a proper asset browser
        
        return panel;
    }
    
    // Method to save current material settings
    public void SaveMaterialSettings()
    {
        if (targetMaterial != null && materialInstance != null)
        {
            // Copy properties from instance back to original material
            // Or save to a ScriptableObject for persistence
        }
    }
    
    // Method to reset to original material
    public void ResetMaterial()
    {
        if (targetMaterial != null)
        {
            SetupMaterialInstance();
            CreateDynamicUI();
        }
    }
    
    // Method to add a new property configuration at runtime
    public void AddPropertyConfiguration(string propertyName, string displayName, MaterialPropertyType type, bool isSlider = false, Vector2 range = default)
    {
        MaterialPropertyData newProp = new MaterialPropertyData
        {
            propertyName = propertyName,
            displayName = displayName,
            propertyType = type,
            isSlider = isSlider,
            floatRange = range == default ? new Vector2(0f, 1f) : range
        };
        
        materialProperties.Add(newProp);
        CreateUIForProperty(newProp);
    }
}