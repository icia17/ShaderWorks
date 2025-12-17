using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class CardShaderEditorRuntime : MonoBehaviour
{
    [Header("Cards")]
    public CardMaterialGroup[] cards;
    private int cardIndex;

    [Header("UI - Dropdowns")]
    public TMP_Dropdown cardDropdown;
    public TMP_Dropdown rendererDropdown;
    public TMP_Dropdown materialDropdown;

    [Header("Shader Parameters")]
    public ShaderParam[] parameters;

    [Header("UI - Prefabs")]
    public Transform uiRoot;
    public GameObject sliderPrefab;
    public GameObject colorPrefab;
    public GameObject togglePrefab;

    Material currentMaterial;

    void Start()
    {
        SetupCardDropdown();
    }

    void SetupCardDropdown()
    {
        cardDropdown.ClearOptions();

        foreach (var c in cards)
            cardDropdown.options.Add(new TMP_Dropdown.OptionData(c.name));

        cardDropdown.onValueChanged.AddListener(i =>
        {
            cardIndex = i;
            SetupRendererDropdown();
        });

        cardIndex = 0;
        SetupRendererDropdown();
    }

    void SetupRendererDropdown()
    {
        rendererDropdown.ClearOptions();

        foreach (var k in cards[cardIndex].RuntimeMaterials.Keys)
            rendererDropdown.options.Add(new TMP_Dropdown.OptionData(k));

        rendererDropdown.onValueChanged.AddListener(_ => SetupMaterialDropdown());

        rendererDropdown.value = 0;
        SetupMaterialDropdown();
    }

    void SetupMaterialDropdown()
    {
        materialDropdown.ClearOptions();

        string key = rendererDropdown.options[rendererDropdown.value].text;
        var mats = cards[cardIndex].RuntimeMaterials[key];

        for (int i = 0; i < mats.Length; i++)
            materialDropdown.options.Add(
                new TMP_Dropdown.OptionData($"Material {i}")
            );

        materialDropdown.onValueChanged.AddListener(i =>
        {
            currentMaterial = mats[i];
            RebuildUI();
        });

        materialDropdown.value = 0;
        currentMaterial = mats[0];
        RebuildUI();
    }

    void RebuildUI()
    {
        foreach (Transform c in uiRoot)
            Destroy(c.gameObject);

        if (currentMaterial == null) return;

        foreach (var p in parameters)
        {
            if (!currentMaterial.HasProperty(p.property))
                continue;

            if (p.type == ParamType.Float || p.type == ParamType.Range)
                CreateSlider(p);
            else if (p.type == ParamType.Color)
                CreateColor(p);
            else if (p.type == ParamType.Toggle)
                CreateToggle(p);
        }
    }

    void CreateSlider(ShaderParam p)
    {
        var go = Instantiate(sliderPrefab, uiRoot);
        var label = go.transform.Find("Label").GetComponent<TMP_Text>();
        var slider = go.transform.Find("Slider").GetComponent<Slider>();
        var value = go.transform.Find("Value").GetComponent<TMP_Text>();

        label.text = p.label;
        slider.minValue = p.min;
        slider.maxValue = p.max;

        float cur = currentMaterial.GetFloat(p.property);
        slider.value = cur;
        value.text = cur.ToString("0.###");

        slider.onValueChanged.AddListener(v =>
        {
            currentMaterial.SetFloat(p.property, v);
            value.text = v.ToString("0.###");
        });
    }

    void CreateToggle(ShaderParam p)
    {
        var go = Instantiate(togglePrefab, uiRoot);
        var label = go.transform.Find("Label").GetComponent<TMP_Text>();
        var toggle = go.transform.Find("Toggle").GetComponent<Toggle>();

        label.text = p.label;
        toggle.isOn = currentMaterial.GetFloat(p.property) > 0.5f;

        toggle.onValueChanged.AddListener(v =>
        {
            currentMaterial.SetFloat(p.property, v ? 1f : 0f);
        });
    }

    void CreateColor(ShaderParam p)
    {
        var go = Instantiate(colorPrefab, uiRoot);
        var label = go.transform.Find("Label").GetComponent<TMP_Text>();
        label.text = p.label;

        var r = go.transform.Find("R").GetComponent<Slider>();
        var g = go.transform.Find("G").GetComponent<Slider>();
        var b = go.transform.Find("B").GetComponent<Slider>();

        Color c = currentMaterial.GetColor(p.property);
        r.value = c.r;
        g.value = c.g;
        b.value = c.b;

        void Apply()
        {
            currentMaterial.SetColor(
                p.property,
                new Color(r.value, g.value, b.value, 1f)
            );
        }

        r.onValueChanged.AddListener(_ => Apply());
        g.onValueChanged.AddListener(_ => Apply());
        b.onValueChanged.AddListener(_ => Apply());
    }
}
