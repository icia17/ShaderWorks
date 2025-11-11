using UnityEngine;

public class RippleRaycast : MonoBehaviour
{
    public float raycastDistance = 100f;
    public KeyCode shootKey = KeyCode.E; // Tecla E

    void Update()
    {
        if (Input.GetKeyDown(shootKey))
        {
            ShootRaycast();
        }
    }

    void ShootRaycast()
    {
        // Crear el ray desde el centro de la cámara
        Ray ray = new Ray(Camera.main.transform.position, Camera.main.transform.forward);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, raycastDistance))
        {
            if (hit.collider.CompareTag("RippleShader"))
            {
                // Obtener el material del objeto impactado
                Renderer renderer = hit.collider.GetComponent<Renderer>();

                if (renderer != null && renderer.material != null)
                {
                    Material hitMaterial = renderer.material;

                    // Enviar punto de impacto y tiempo al shader
                    hitMaterial.SetVector("_RippleCenter", hit.point);
                    hitMaterial.SetFloat("_RippleStartTime", Time.time);

                    // Debug visual (opcional)
                    Debug.DrawLine(ray.origin, hit.point, Color.cyan, 1f);
                }
                else
                {
                    Debug.LogWarning("El objeto no tiene Renderer o Material!");
                }
            }
        }
    }
}