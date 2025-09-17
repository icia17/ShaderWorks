using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class UVShaderUI : MonoBehaviour
{
    [Header("Target Material")]
    public Material uvMaterial;
    public Renderer targetRenderer;
    
    [Header("UI Setup")]
    public Transform uiContainer;
    public GameObject sliderPrefab;
    public GameObject colorPrefab;
    public GameObject texturePrefab;
    
    [Header("Auto-detected Properties")]
    public List<ToonPropertyData> detectedProperties = new List<ToonPropertyData>();
    
    private Material materialInstance;
    private Dictionary<string, GameObject> propertyUIElements = new Dictionary<string, GameObject>();
    
    // Propiedades específicas del UV Shader
    private readonly Dictionary<string, ToonPropertyData> uvShaderProperties = new Dictionary<string, ToonPropertyData>()
    {
        ["_Float0"] = new ToonPropertyData { 
            propertyName = "_Float0", 
            displayName = "Mask Threshold 1", 
            propertyType = ToonPropertyType.Float, 
            floatRange = new Vector2(-2f, 2f) 
        },
        ["_La2datextura"] = new ToonPropertyData { 
            propertyName = "_La2datextura", 
            displayName = "Mask Threshold 2", 
            propertyType = ToonPropertyType.Float, 
            floatRange = new Vector2(-2f, 2f) 
        },
        ["_Color0"] = new ToonPropertyData { 
            propertyName = "_Color0", 
            displayName = "Base Color", 
            propertyType = ToonPropertyType.Color,
            showAlpha = false
        },
        ["_Color1"] = new ToonPropertyData { 
            propertyName = "_Color1", 
            displayName = "Texture 0 Tint", 
            propertyType = ToonPropertyType.Color,
            showAlpha = false
        },
        ["_Color2"] = new ToonPropertyData { 
            propertyName = "_Color2", 
            displayName = "Texture 2 Tint", 
            propertyType = ToonPropertyType.Color,
            showAlpha = false
        },
        ["_TextureSample0"] = new ToonPropertyData { 
            propertyName = "_TextureSample0", 
            displayName = "Screen Texture 0", 
            propertyType = ToonPropertyType.Texture2D 
        },
        ["_TextureSample1"] = new ToonPropertyData { 
            propertyName = "_TextureSample1", 
            displayName = "Screen Mask", 
            propertyType = ToonPropertyType.Texture2D 
        },
        ["_TextureSample2"] = new ToonPropertyData { 
            propertyName = "_TextureSample2", 
            displayName = "UV Texture", 
            propertyType = ToonPropertyType.Texture2D 
        }
    };
    
    void Start()
    {
        SetupMaterialInstance();
        DetectShaderProperties();
        CreateUVUI();
    }
    
    void SetupMaterialInstance()
    {
        if (targetRenderer != null)
        {
            materialInstance = targetRenderer.material;
        }
        else if (uvMaterial != null)
        {
            materialInstance = new Material(uvMaterial);
            ApplyToAllRenderers();
        }
        else
        {
            Debug.LogError("No UV material or renderer assigned!");
            return;
        }
    }
    
    void ApplyToAllRenderers()
    {
        Renderer[] allRenderers = FindObjectsOfType<Renderer>();
        foreach (Renderer renderer in allRenderers)
        {
            if (renderer.sharedMaterial != null && 
                renderer.sharedMaterial.shader.name == "UV")
            {
                renderer.material = materialInstance;
            }
        }
    }
    
    void DetectShaderProperties()
    {
        detectedProperties.Clear();
        
        if (materialInstance == null) return;
        
        // Agregar propiedades conocidas del UV Shader
        foreach (var kvp in uvShaderProperties)
        {
            if (materialInstance.HasProperty(kvp.Key))
            {
                detectedProperties.Add(kvp.Value);
            }
        }
    }
    
    void CreateUVUI()
    {
        if (materialInstance == null) return;
        
        // Limpiar UI existente
        foreach (Transform child in uiContainer)
        {
            DestroyImmediate(child.gameObject);
        }
        propertyUIElements.Clear();
        
        // Crear header principal
        CreateSectionHeader("UV Shader Controls");
        
        // Agrupar propiedades por categoría
        CreateSectionHeader("Mask Thresholds");
        CreatePropertyUI("_Float0");
        CreatePropertyUI("_La2datextura");
        
        CreateSectionHeader("Colors");
        CreatePropertyUI("_Color0");
        CreatePropertyUI("_Color1");
        CreatePropertyUI("_Color2");
        
        CreateSectionHeader("Textures");
        CreatePropertyUI("_TextureSample0");
        CreatePropertyUI("_TextureSample1");
        CreatePropertyUI("_TextureSample2");
        
        // Botones de control
        CreateControlButtons();
        
        LayoutRebuilder.ForceRebuildLayoutImmediate(uiContainer.GetComponent<RectTransform>());
    }
    
    void CreateSectionHeader(string title)
    {
        GameObject header = new GameObject("Header_" + title);
        header.transform.SetParent(uiContainer);
        header.transform.localScale = Vector3.one;
        
        TextMeshProUGUI headerText = header.AddComponent<TextMeshProUGUI>();
        headerText.text = title;
        headerText.fontSize = 14;
        headerText.fontStyle = FontStyles.Bold;
        headerText.color = Color.cyan; // Color distintivo para UV shader
        headerText.alignment = TextAlignmentOptions.Center;
        
        LayoutElement layoutElement = header.AddComponent<LayoutElement>();
        layoutElement.minHeight = 20;
        layoutElement.preferredHeight = 20;
    }
    
    void CreatePropertyUI(string propertyName)
    {
        if (!uvShaderProperties.ContainsKey(propertyName)) return;
        if (!materialInstance.HasProperty(propertyName)) return;
        
        ToonPropertyData propData = uvShaderProperties[propertyName];
        GameObject uiElement = null;
        
        switch (propData.propertyType)
        {
            case ToonPropertyType.Float:
                uiElement = CreateUVSliderUI(propData);
                break;
            case ToonPropertyType.Color:
                uiElement = CreateUVColorUI(propData);
                break;
            case ToonPropertyType.Texture2D:
                uiElement = CreateUVTextureUI(propData);
                break;
        }
        
        if (uiElement != null)
        {
            propertyUIElements[propertyName] = uiElement;
        }
    }
    
    GameObject CreateUVSliderUI(ToonPropertyData propData)
    {
        GameObject sliderObj = Instantiate(sliderPrefab, uiContainer);
        
        // Setup label
        TextMeshProUGUI label = sliderObj.transform.Find("Label").GetComponent<TextMeshProUGUI>();
        label.text = propData.displayName;
        label.fontSize = 12;
        
        // Setup slider
        Slider slider = sliderObj.transform.Find("Slider").GetComponent<Slider>();
        slider.minValue = propData.floatRange.x;
        slider.maxValue = propData.floatRange.y;
        slider.value = materialInstance.GetFloat(propData.propertyName);
        
        // Setup value display
        TextMeshProUGUI valueText = sliderObj.transform.Find("ValueText").GetComponent<TextMeshProUGUI>();
        valueText.text = slider.value.ToString("F3");
        valueText.fontSize = 10;
        
        // Color coding específico para UV shader
        Image sliderFill = slider.fillRect.GetComponent<Image>();
        if (propData.propertyName == "_Float0")
            sliderFill.color = new Color(0.3f, 1f, 1f); // Cyan para primer threshold
        else if (propData.propertyName == "_La2datextura")
            sliderFill.color = new Color(1f, 0.3f, 1f); // Magenta para segundo threshold
        
        slider.onValueChanged.AddListener(value =>
        {
            materialInstance.SetFloat(propData.propertyName, value);
            valueText.text = value.ToString("F3");
        });
        
        return sliderObj;
    }
    
    GameObject CreateUVColorUI(ToonPropertyData propData)
    {
        GameObject colorObj = Instantiate(colorPrefab, uiContainer);
        
        // Setup label
        TextMeshProUGUI label = colorObj.transform.Find("Label").GetComponent<TextMeshProUGUI>();
        label.text = propData.displayName;
        label.fontSize = 12;
        label.color = Color.cyan;
        
        // Setup color preview
        Image colorPreview = colorObj.transform.Find("ColorPreview").GetComponent<Image>();
        Color currentColor = materialInstance.GetColor(propData.propertyName);
        colorPreview.color = currentColor;
        
        // Setup color picker button
        Button colorButton = colorObj.transform.Find("ColorButton").GetComponent<Button>();
        colorButton.onClick.AddListener(() => OpenColorPicker(propData.propertyName, colorPreview));
        
        // RGB Sliders
        CreateRGBSliders(colorObj, propData, currentColor);
        
        return colorObj;
    }
    
    void CreateRGBSliders(GameObject parent, ToonPropertyData propData, Color currentColor)
    {
        Transform rgbContainer = parent.transform.Find("RGBContainer");
        if (rgbContainer == null) return;
        
        // Red slider
        CreateColorSlider(rgbContainer, "R", currentColor.r, Color.red, (value) => {
            Color color = materialInstance.GetColor(propData.propertyName);
            color.r = value;
            materialInstance.SetColor(propData.propertyName, color);
            parent.transform.Find("ColorPreview").GetComponent<Image>().color = color;
        });
        
        // Green slider
        CreateColorSlider(rgbContainer, "G", currentColor.g, Color.green, (value) => {
            Color color = materialInstance.GetColor(propData.propertyName);
            color.g = value;
            materialInstance.SetColor(propData.propertyName, color);
            parent.transform.Find("ColorPreview").GetComponent<Image>().color = color;
        });
        
        // Blue slider
        CreateColorSlider(rgbContainer, "B", currentColor.b, Color.blue, (value) => {
            Color color = materialInstance.GetColor(propData.propertyName);
            color.b = value;
            materialInstance.SetColor(propData.propertyName, color);
            parent.transform.Find("ColorPreview").GetComponent<Image>().color = color;
        });
    }
    
    void CreateColorSlider(Transform parent, string channelName, float currentValue, Color sliderColor, System.Action<float> onValueChanged)
    {
        GameObject sliderObj = new GameObject(channelName + "Slider");
        sliderObj.transform.SetParent(parent);
        sliderObj.transform.localScale = Vector3.one;
        
        // Add Slider component
        Slider slider = sliderObj.AddComponent<Slider>();
        slider.minValue = 0f;
        slider.maxValue = 1f;
        slider.value = currentValue;
        
        // Setup slider visuals (simplified)
        GameObject background = new GameObject("Background");
        background.transform.SetParent(sliderObj.transform);
        Image bgImage = background.AddComponent<Image>();
        bgImage.color = new Color(0.2f, 0.2f, 0.2f);
        
        GameObject fillArea = new GameObject("Fill Area");
        fillArea.transform.SetParent(sliderObj.transform);
        GameObject fill = new GameObject("Fill");
        fill.transform.SetParent(fillArea.transform);
        Image fillImage = fill.AddComponent<Image>();
        fillImage.color = sliderColor;
        
        slider.targetGraphic = fillImage;
        slider.fillRect = fill.GetComponent<RectTransform>();
        
        slider.onValueChanged.AddListener((value) => onValueChanged(value));
    }
    
    void OpenColorPicker(string propertyName, Image colorPreview)
    {
        // Implementación simple - en un proyecto real usarías un color picker más avanzado
        Color randomColor = new Color(Random.value, Random.value, Random.value, 1f);
        materialInstance.SetColor(propertyName, randomColor);
        colorPreview.color = randomColor;
    }
    
    GameObject CreateUVTextureUI(ToonPropertyData propData)
    {
        GameObject textureObj = Instantiate(texturePrefab, uiContainer);
        
        // Setup label
        TextMeshProUGUI label = textureObj.transform.Find("Label").GetComponent<TextMeshProUGUI>();
        label.text = propData.displayName;
        label.fontSize = 12;
        
        // Setup texture preview
        RawImage preview = textureObj.transform.Find("Preview").GetComponent<RawImage>();
        Texture currentTexture = materialInstance.GetTexture(propData.propertyName);
        preview.texture = currentTexture;
        
        // Setup texture selector
        Button selectButton = textureObj.transform.Find("SelectButton").GetComponent<Button>();
        selectButton.onClick.AddListener(() => OpenTextureSelector(propData.propertyName, preview));
        
        return textureObj;
    }
    
    void CreateControlButtons()
    {
        CreateSectionHeader("Controls");
        
        // Reset Button
        GameObject resetButton = new GameObject("ResetButton");
        resetButton.transform.SetParent(uiContainer);
        resetButton.transform.localScale = Vector3.one;
        
        Button resetBtn = resetButton.AddComponent<Button>();
        Image resetBtnImage = resetButton.AddComponent<Image>();
        resetBtnImage.color = new Color(0.8f, 0.3f, 0.3f);
        
        GameObject resetText = new GameObject("Text");
        resetText.transform.SetParent(resetButton.transform);
        TextMeshProUGUI resetTMP = resetText.AddComponent<TextMeshProUGUI>();
        resetTMP.text = "Reset to Default";
        resetTMP.alignment = TextAlignmentOptions.Center;
        resetTMP.color = Color.white;
        resetTMP.fontSize = 10;
        
        resetBtn.onClick.AddListener(ResetToDefaults);
        
        // Save Button
        GameObject saveButton = new GameObject("SaveButton");
        saveButton.transform.SetParent(uiContainer);
        saveButton.transform.localScale = Vector3.one;
        
        Button saveBtn = saveButton.AddComponent<Button>();
        Image saveBtnImage = saveButton.AddComponent<Image>();
        saveBtnImage.color = new Color(0.3f, 0.8f, 0.8f);
        
        GameObject saveText = new GameObject("Text");
        saveText.transform.SetParent(saveButton.transform);
        TextMeshProUGUI saveTMP = saveText.AddComponent<TextMeshProUGUI>();
        saveTMP.text = "Save Settings";
        saveTMP.alignment = TextAlignmentOptions.Center;
        saveTMP.color = Color.white;
        saveTMP.fontSize = 10;
        
        saveBtn.onClick.AddListener(SaveCurrentSettings);
    }
    
    void OpenTextureSelector(string propertyName, RawImage preview)
    {
        string[] textureNames = { "UVTexture", "MaskTexture", "NoiseTexture" };
        string currentName = textureNames[Random.Range(0, textureNames.Length)];
        
        Texture2D newTexture = Resources.Load<Texture2D>(currentName);
        if (newTexture != null)
        {
            materialInstance.SetTexture(propertyName, newTexture);
            preview.texture = newTexture;
        }
    }
    
    public void ResetToDefaults()
    {
        if (uvMaterial != null)
        {
            materialInstance.CopyPropertiesFromMaterial(uvMaterial);
            CreateUVUI();
        }
    }
    
    public void SaveCurrentSettings()
    {
        foreach (var propData in uvShaderProperties.Values)
        {
            if (!materialInstance.HasProperty(propData.propertyName)) continue;
            
            switch (propData.propertyType)
            {
                case ToonPropertyType.Float:
                    float floatValue = materialInstance.GetFloat(propData.propertyName);
                    PlayerPrefs.SetFloat("UVShader_" + propData.propertyName, floatValue);
                    break;
                case ToonPropertyType.Color:
                    Color colorValue = materialInstance.GetColor(propData.propertyName);
                    PlayerPrefs.SetFloat("UVShader_" + propData.propertyName + "_R", colorValue.r);
                    PlayerPrefs.SetFloat("UVShader_" + propData.propertyName + "_G", colorValue.g);
                    PlayerPrefs.SetFloat("UVShader_" + propData.propertyName + "_B", colorValue.b);
                    break;
            }
        }
        
        PlayerPrefs.Save();
        Debug.Log("UV Shader settings saved!");
    }
}