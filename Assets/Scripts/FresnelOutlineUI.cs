using UnityEngine;
using UnityEngine.UI;

public class FresnelOutlineUI_Multi : MonoBehaviour
{
    [Header("Renderers con el shader Fresnel")]
    public Renderer[] targetRenderers; // ahora soporta varios objetos

    [Header("Sliders para parámetros")]
    public Slider velocidadSlider;
    public Slider strengthSlider;
    public Slider thicknessSlider;
    public Slider scaleSlider;

    [Header("Sliders para el Color")]
    public Slider rSlider;
    public Slider gSlider;
    public Slider bSlider;

    private Material[] _materials;

    void Start()
    {
        if (targetRenderers == null || targetRenderers.Length == 0) return;

        // Crear array de materiales de cada renderer
        _materials = new Material[targetRenderers.Length];
        for (int i = 0; i < targetRenderers.Length; i++)
        {
            _materials[i] = targetRenderers[i].material; // crea instancia en runtime
        }

        // Asignar listeners a los sliders
        if (velocidadSlider != null) velocidadSlider.onValueChanged.AddListener(UpdateVelocidad);
        if (strengthSlider != null) strengthSlider.onValueChanged.AddListener(UpdateStrength);
        if (thicknessSlider != null) thicknessSlider.onValueChanged.AddListener(UpdateThickness);
        if (scaleSlider != null) scaleSlider.onValueChanged.AddListener(UpdateScale);

        if (rSlider != null) rSlider.onValueChanged.AddListener(_ => UpdateColor());
        if (gSlider != null) gSlider.onValueChanged.AddListener(_ => UpdateColor());
        if (bSlider != null) bSlider.onValueChanged.AddListener(_ => UpdateColor());

        // Inicializar valores
        UpdateColor();
    }

    void UpdateVelocidad(float value)
    {
        foreach (var mat in _materials)
            mat.SetFloat("_velocidad", value);
    }

    void UpdateStrength(float value)
    {
        foreach (var mat in _materials)
            mat.SetFloat("_strength", value);
    }

    void UpdateThickness(float value)
    {
        foreach (var mat in _materials)
            mat.SetFloat("_Outline Thickness", value);
    }

    void UpdateScale(float value)
    {
        foreach (var mat in _materials)
            mat.SetFloat("_scale", value);
    }

    void UpdateColor()
    {
        Color c = new Color(rSlider.value, gSlider.value, bSlider.value, 1f);
        foreach (var mat in _materials)
            mat.SetColor("_fresnelColor", c);
    }
}