using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

[System.Serializable]
public class ToonPropertyData
{
    public string propertyName;
    public string displayName;
    public ToonPropertyType propertyType;
    public bool isSlider = true;
    public Vector2 floatRange = new Vector2(0f, 1f);
    public bool showAlpha = false; // Para colores
}

public enum ToonPropertyType
{
    Float,
    Color,
    Texture2D,
    Vector4
}

public class ToonShaderUI : MonoBehaviour
{
    [Header("Target Material")]
    public Material toonMaterial;
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
    
    // Propiedades específicas del ToonShader
    private readonly Dictionary<string, ToonPropertyData> toonShaderProperties = new Dictionary<string, ToonPropertyData>()
    {
        ["_ShadowNum"] = new ToonPropertyData { 
            propertyName = "_ShadowNum", 
            displayName = "Shadow Level 1", 
            propertyType = ToonPropertyType.Float, 
            floatRange = new Vector2(0f, 1f) 
        },
        ["_Shadowforce2"] = new ToonPropertyData { 
            propertyName = "_Shadowforce2", 
            displayName = "Shadow Level 2", 
            propertyType = ToonPropertyType.Float, 
            floatRange = new Vector2(0f, 1f) 
        },
        ["_Float0"] = new ToonPropertyData { 
            propertyName = "_Float0", 
            displayName = "Shadow Level 3", 
            propertyType = ToonPropertyType.Float, 
            floatRange = new Vector2(0f, 1f) 
        },
        ["_Color0"] = new ToonPropertyData { 
            propertyName = "_Color0", 
            displayName = "Shadow Color", 
            propertyType = ToonPropertyType.Color,
            showAlpha = false
        },
        ["_Color1"] = new ToonPropertyData { 
            propertyName = "_Color1", 
            displayName = "Light Color", 
            propertyType = ToonPropertyType.Color,
            showAlpha = false
        },
        ["_Texture0"] = new ToonPropertyData { 
            propertyName = "_Texture0", 
            displayName = "Base Texture", 
            propertyType = ToonPropertyType.Texture2D 
        },
        ["_TextureSample1"] = new ToonPropertyData { 
            propertyName = "_TextureSample1", 
            displayName = "Normal Map", 
            propertyType = ToonPropertyType.Texture2D 
        }
    };
    
    void Start()
    {
        SetupMaterialInstance();
        DetectShaderProperties();
        CreateToonUI();
    }
    
    void SetupMaterialInstance()
    {
        if (targetRenderer != null)
        {
            materialInstance = targetRenderer.material;
        }
        else if (toonMaterial != null)
        {
            materialInstance = new Material(toonMaterial);
            // Aplicar a todos los renderers en la escena con este material
            ApplyToAllRenderers();
        }
        else
        {
            Debug.LogError("No Toon material or renderer assigned!");
            return;
        }
    }
    
    void ApplyToAllRenderers()
    {
        Renderer[] allRenderers = FindObjectsOfType<Renderer>();
        foreach (Renderer renderer in allRenderers)
        {
            if (renderer.sharedMaterial != null && 
                renderer.sharedMaterial.shader.name == "Custom/ToonShader")
            {
                renderer.material = materialInstance;
            }
        }
    }
    
    void DetectShaderProperties()
    {
        detectedProperties.Clear();
        
        if (materialInstance == null) return;
        
        // Detectar automáticamente las propiedades del shader
        Shader shader = materialInstance.shader;
        int propertyCount = ShaderUtil.GetPropertyCount(shader);
        
        for (int i = 0; i < propertyCount; i++)
        {
            string propName = ShaderUtil.GetPropertyName(shader, i);
            ShaderUtil.ShaderPropertyType propType = ShaderUtil.GetPropertyType(shader, i);
            
            // Solo agregar propiedades que conocemos del ToonShader
            if (toonShaderProperties.ContainsKey(propName))
            {
                detectedProperties.Add(toonShaderProperties[propName]);
            }
        }
        
        // Si no se detectaron automáticamente, usar la lista manual
        if (detectedProperties.Count == 0)
        {
            foreach (var kvp in toonShaderProperties)
            {
                if (materialInstance.HasProperty(kvp.Key))
                {
                    detectedProperties.Add(kvp.Value);
                }
            }
        }
    }
    
    void CreateToonUI()
    {
        if (materialInstance == null) return;
        
        // Limpiar UI existente
        foreach (Transform child in uiContainer)
        {
            DestroyImmediate(child.gameObject);
        }
        propertyUIElements.Clear();
        
        // Crear header
        CreateSectionHeader("Toon Shader Controls");
        
        // Agrupar propiedades por categoría
        CreateSectionHeader("Shadow Levels");
        CreatePropertyUI("_ShadowNum");
        CreatePropertyUI("_Shadowforce2");
        CreatePropertyUI("_Float0");
        
        CreateSectionHeader("Colors");
        CreatePropertyUI("_Color0");
        CreatePropertyUI("_Color1");
        
        CreateSectionHeader("Textures");
        CreatePropertyUI("_Texture0");
        CreatePropertyUI("_TextureSample1");
        
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
        headerText.fontSize = 14; // Antes era 18
        headerText.fontStyle = FontStyles.Bold;
        headerText.color = Color.white;
        headerText.alignment = TextAlignmentOptions.Center;
    
        LayoutElement layoutElement = header.AddComponent<LayoutElement>();
        layoutElement.minHeight = 20; // Antes era 30
        layoutElement.preferredHeight = 20;
    }
    
    void CreatePropertyUI(string propertyName)
    {
        if (!toonShaderProperties.ContainsKey(propertyName)) return;
        if (!materialInstance.HasProperty(propertyName)) return;
        
        ToonPropertyData propData = toonShaderProperties[propertyName];
        GameObject uiElement = null;
        
        switch (propData.propertyType)
        {
            case ToonPropertyType.Float:
                uiElement = CreateToonSliderUI(propData);
                break;
            case ToonPropertyType.Color:
                uiElement = CreateToonColorUI(propData);
                break;
            case ToonPropertyType.Texture2D:
                uiElement = CreateToonTextureUI(propData);
                break;
        }
        
        if (uiElement != null)
        {
            propertyUIElements[propertyName] = uiElement;
        }
    }
    
    GameObject CreateToonSliderUI(ToonPropertyData propData)
    {
        GameObject sliderObj = Instantiate(sliderPrefab, uiContainer);
        
        // Setup label
        TextMeshProUGUI label = sliderObj.transform.Find("Label").GetComponent<TextMeshProUGUI>();
        label.text = propData.displayName;
        
        // Setup slider
        Slider slider = sliderObj.transform.Find("Slider").GetComponent<Slider>();
        slider.minValue = propData.floatRange.x;
        slider.maxValue = propData.floatRange.y;
        slider.value = materialInstance.GetFloat(propData.propertyName);
        
        // Setup value display
        TextMeshProUGUI valueText = sliderObj.transform.Find("ValueText").GetComponent<TextMeshProUGUI>();
        valueText.text = slider.value.ToString("F3");
        
        // Add special color coding for shadow levels
        if (propData.propertyName.Contains("Shadow") || propData.propertyName.Contains("Float0"))
        {
            Image sliderFill = slider.fillRect.GetComponent<Image>();
            if (propData.propertyName == "_ShadowNum")
                sliderFill.color = new Color(1f, 0.3f, 0.3f); // Rojo para primer nivel
            else if (propData.propertyName == "_Shadowforce2")
                sliderFill.color = new Color(1f, 0.8f, 0.3f); // Amarillo para segundo nivel
            else if (propData.propertyName == "_Float0")
                sliderFill.color = new Color(0.3f, 1f, 0.3f); // Verde para tercer nivel
        }
        
        slider.onValueChanged.AddListener(value =>
        {
            materialInstance.SetFloat(propData.propertyName, value);
            valueText.text = value.ToString("F3");
        });
        
        return sliderObj;
    }
    
    GameObject CreateToonColorUI(ToonPropertyData propData)
    {
        // Crear contenedor principal
        GameObject colorContainer = new GameObject(propData.propertyName + "_Container");
        colorContainer.transform.SetParent(uiContainer);
        colorContainer.transform.localScale = Vector3.one;
    
        // Layout Element para spacing correcto
        LayoutElement containerLayout = colorContainer.AddComponent<LayoutElement>();
        containerLayout.minHeight = 80; // Más alto para RGB sliders
        containerLayout.preferredHeight = 80;
    
        // Vertical Layout Group para organizar label + sliders RGB
        VerticalLayoutGroup verticalLayout = colorContainer.AddComponent<VerticalLayoutGroup>();
        verticalLayout.spacing = 2;
        verticalLayout.padding = new RectOffset(5, 5, 2, 2);
    
        // Label principal
        GameObject labelObj = new GameObject("Label");
        labelObj.transform.SetParent(colorContainer.transform);
        TextMeshProUGUI label = labelObj.AddComponent<TextMeshProUGUI>();
        label.text = propData.displayName;
        label.fontSize = 14;
        label.color = Color.white;
    
        // Obtener color actual
        Color currentColor = materialInstance.HasProperty(propData.propertyName) ? 
            materialInstance.GetColor(propData.propertyName) : Color.white;
    
        // Crear sliders RGB
        CreateColorChannelSlider(colorContainer, "R", currentColor.r, new Color(1f, 0.3f, 0.3f), propData.propertyName, 0);
        CreateColorChannelSlider(colorContainer, "G", currentColor.g, new Color(0.3f, 1f, 0.3f), propData.propertyName, 1);
        CreateColorChannelSlider(colorContainer, "B", currentColor.b, new Color(0.3f, 0.3f, 1f), propData.propertyName, 2);
    
        return colorContainer;
    }
    
    void CreateColorChannelSlider(GameObject parent, string channelName, float currentValue, Color sliderColor, string propertyName, int channelIndex)
{
    // Contenedor del slider
    GameObject sliderContainer = new GameObject(channelName + "Slider");
    sliderContainer.transform.SetParent(parent.transform);
    sliderContainer.transform.localScale = Vector3.one;
    
    // Layout horizontal para label + slider + value
    HorizontalLayoutGroup horizontalLayout = sliderContainer.AddComponent<HorizontalLayoutGroup>();
    horizontalLayout.spacing = 5;
    horizontalLayout.childControlWidth = true;
    horizontalLayout.childControlHeight = true;
    horizontalLayout.childForceExpandWidth = false;
    
    // Label del canal (R, G, B)
    GameObject channelLabel = new GameObject("ChannelLabel");
    channelLabel.transform.SetParent(sliderContainer.transform);
    TextMeshProUGUI channelText = channelLabel.AddComponent<TextMeshProUGUI>();
    channelText.text = channelName + ":";
    channelText.fontSize = 14;
    channelText.color = sliderColor;
    channelText.alignment = TextAlignmentOptions.MidlineRight;
    
    LayoutElement channelLabelLayout = channelLabel.AddComponent<LayoutElement>();
    channelLabelLayout.minWidth = 20;
    channelLabelLayout.preferredWidth = 20;
    
    // Slider
    GameObject sliderObj = new GameObject("Slider");
    sliderObj.transform.SetParent(sliderContainer.transform);
    Slider slider = sliderObj.AddComponent<Slider>();
    slider.minValue = 0f;
    slider.maxValue = 1f;
    slider.value = currentValue;
    
    // Configurar visualmente el slider (similar a los shadow levels)
    SetupSliderVisuals(slider, sliderColor);
    
    LayoutElement sliderLayout = sliderObj.AddComponent<LayoutElement>();
    sliderLayout.flexibleWidth = 1f;
    sliderLayout.minHeight = 15;
    
    // Value text
    GameObject valueObj = new GameObject("ValueText");
    valueObj.transform.SetParent(sliderContainer.transform);
    TextMeshProUGUI valueText = valueObj.AddComponent<TextMeshProUGUI>();
    valueText.text = currentValue.ToString("F2");
    valueText.fontSize = 12;
    valueText.color = Color.white;
    valueText.alignment = TextAlignmentOptions.MidlineLeft;
    
    LayoutElement valueLayout = valueObj.AddComponent<LayoutElement>();
    valueLayout.minWidth = 50;
    valueLayout.preferredWidth = 50;
    
    // Event listener
    slider.onValueChanged.AddListener((value) => {
        if (materialInstance.HasProperty(propertyName))
        {
            Color color = materialInstance.GetColor(propertyName);
            
            // Actualizar el canal correspondiente
            switch (channelIndex)
            {
                case 0: color.r = value; break;
                case 1: color.g = value; break;
                case 2: color.b = value; break;
            }
            
            materialInstance.SetColor(propertyName, color);
            valueText.text = value.ToString("F2");
        }
    });
}
    
    void SetupSliderVisuals(Slider slider, Color fillColor)
    {
        // Background
        GameObject background = new GameObject("Background");
        background.transform.SetParent(slider.transform);
        RectTransform bgRect = background.AddComponent<RectTransform>();
        Image bgImage = background.AddComponent<Image>();
        bgImage.color = new Color(0.2f, 0.2f, 0.2f);
        bgRect.anchorMin = Vector2.zero;
        bgRect.anchorMax = Vector2.one;
        bgRect.sizeDelta = Vector2.zero;
    
        // Fill Area
        GameObject fillArea = new GameObject("Fill Area");
        fillArea.transform.SetParent(slider.transform);
        RectTransform fillAreaRect = fillArea.AddComponent<RectTransform>();
        fillAreaRect.anchorMin = Vector2.zero;
        fillAreaRect.anchorMax = Vector2.one;
        fillAreaRect.sizeDelta = Vector2.zero;
    
        // Fill
        GameObject fill = new GameObject("Fill");
        fill.transform.SetParent(fillArea.transform);
        RectTransform fillRect = fill.AddComponent<RectTransform>();
        Image fillImage = fill.AddComponent<Image>();
        fillImage.color = fillColor;
        fillRect.anchorMin = Vector2.zero;
        fillRect.anchorMax = Vector2.one;
        fillRect.sizeDelta = Vector2.zero;
    
        // Asignar al slider
        slider.fillRect = fillRect;
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
    
    GameObject CreateToonTextureUI(ToonPropertyData propData)
    {
        GameObject textureObj = Instantiate(texturePrefab, uiContainer);
        
        // Setup label
        TextMeshProUGUI label = textureObj.transform.Find("Label").GetComponent<TextMeshProUGUI>();
        label.text = propData.displayName;
        
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
        
        resetBtn.onClick.AddListener(ResetToDefaults);
        
        // Save Button
        GameObject saveButton = new GameObject("SaveButton");
        saveButton.transform.SetParent(uiContainer);
        saveButton.transform.localScale = Vector3.one;
        
        Button saveBtn = saveButton.AddComponent<Button>();
        Image saveBtnImage = saveButton.AddComponent<Image>();
        saveBtnImage.color = new Color(0.3f, 0.8f, 0.3f);
        
        GameObject saveText = new GameObject("Text");
        saveText.transform.SetParent(saveButton.transform);
        TextMeshProUGUI saveTMP = saveText.AddComponent<TextMeshProUGUI>();
        saveTMP.text = "Save Settings";
        saveTMP.alignment = TextAlignmentOptions.Center;
        saveTMP.color = Color.white;
        
        saveBtn.onClick.AddListener(SaveCurrentSettings);
    }
    
    void OpenColorPicker(string propertyName, Image colorPreview)
    {
        // Implementación simple - en un proyecto real usarías un color picker más avanzado
        Color randomColor = new Color(Random.value, Random.value, Random.value, 1f);
        materialInstance.SetColor(propertyName, randomColor);
        colorPreview.color = randomColor;
    }
    
    void OpenTextureSelector(string propertyName, RawImage preview)
    {
        // Implementación simple - en un proyecto real tendrías un asset browser
        // Por ahora solo alternar entre algunas texturas de Resources
        string[] textureNames = { "DefaultTexture", "NoiseTexture", "GradientTexture" };
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
        if (toonMaterial != null)
        {
            // Copiar propiedades del material original
            materialInstance.CopyPropertiesFromMaterial(toonMaterial);
            
            // Recrear UI con valores por defecto
            CreateToonUI();
        }
    }
    
    public void SaveCurrentSettings()
    {
        // Guardar configuración actual en PlayerPrefs
        foreach (var propData in toonShaderProperties.Values)
        {
            if (!materialInstance.HasProperty(propData.propertyName)) continue;
            
            switch (propData.propertyType)
            {
                case ToonPropertyType.Float:
                    float floatValue = materialInstance.GetFloat(propData.propertyName);
                    PlayerPrefs.SetFloat("ToonShader_" + propData.propertyName, floatValue);
                    break;
                case ToonPropertyType.Color:
                    Color colorValue = materialInstance.GetColor(propData.propertyName);
                    PlayerPrefs.SetFloat("ToonShader_" + propData.propertyName + "_R", colorValue.r);
                    PlayerPrefs.SetFloat("ToonShader_" + propData.propertyName + "_G", colorValue.g);
                    PlayerPrefs.SetFloat("ToonShader_" + propData.propertyName + "_B", colorValue.b);
                    break;
            }
        }
        
        PlayerPrefs.Save();
        Debug.Log("Toon Shader settings saved!");
    }
    
    public void LoadSavedSettings()
    {
        foreach (var propData in toonShaderProperties.Values)
        {
            if (!materialInstance.HasProperty(propData.propertyName)) continue;
            
            switch (propData.propertyType)
            {
                case ToonPropertyType.Float:
                    string floatKey = "ToonShader_" + propData.propertyName;
                    if (PlayerPrefs.HasKey(floatKey))
                    {
                        float savedValue = PlayerPrefs.GetFloat(floatKey);
                        materialInstance.SetFloat(propData.propertyName, savedValue);
                    }
                    break;
                case ToonPropertyType.Color:
                    string rKey = "ToonShader_" + propData.propertyName + "_R";
                    string gKey = "ToonShader_" + propData.propertyName + "_G";
                    string bKey = "ToonShader_" + propData.propertyName + "_B";
                    
                    if (PlayerPrefs.HasKey(rKey))
                    {
                        Color savedColor = new Color(
                            PlayerPrefs.GetFloat(rKey),
                            PlayerPrefs.GetFloat(gKey),
                            PlayerPrefs.GetFloat(bKey),
                            1f
                        );
                        materialInstance.SetColor(propData.propertyName, savedColor);
                    }
                    break;
            }
        }
        
        CreateToonUI();
    }
}

// Clase auxiliar para acceder a propiedades del shader
public static class ShaderUtil
{
    public enum ShaderPropertyType
    {
        Color, Vector, Float, Range, TexEnv
    }
    
    public static int GetPropertyCount(Shader shader)
    {
        // Implementación simplificada - en Unity real usarías ShaderUtil.GetPropertyCount
        return 10; // Número estimado para el ToonShader
    }
    
    public static string GetPropertyName(Shader shader, int propertyIndex)
    {
        // Implementación simplificada - retorna nombres conocidos del ToonShader
        string[] knownProperties = { "_ShadowNum", "_Shadowforce2", "_Float0", "_Color0", "_Color1", "_Texture0", "_TextureSample1" };
        return propertyIndex < knownProperties.Length ? knownProperties[propertyIndex] : "";
    }
    
    public static ShaderPropertyType GetPropertyType(Shader shader, int propertyIndex)
    {
        // Implementación simplificada basada en el nombre
        string propName = GetPropertyName(shader, propertyIndex);
        if (propName.Contains("Color")) return ShaderPropertyType.Color;
        if (propName.Contains("Texture")) return ShaderPropertyType.TexEnv;
        return ShaderPropertyType.Float;
    }
}