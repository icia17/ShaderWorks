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
        Ray ray = new Ray(Camera.main.transform.position, Camera.main.transform.forward);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, raycastDistance))
        {
            if (hit.collider.CompareTag("RippleShader"))
            {
                Renderer renderer = hit.collider.GetComponent<Renderer>();

                if (renderer != null && renderer.sharedMaterial != null)
                {
                    // Use sharedMaterial to access the existing instance
                    Material hitMaterial = renderer.sharedMaterial;

                    hitMaterial.SetVector("_RippleCenter", hit.point);
                    hitMaterial.SetFloat("_RippleStartTime", Time.time);

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