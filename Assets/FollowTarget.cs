using UnityEngine;

public class FollowTarget : MonoBehaviour
{
    [SerializeField] private Transform target;
    [SerializeField] private float heightOffset = 0.1f;
    
    private void Update()
    {
        if (target != null)
        {
            Vector3 pos = target.position;
            pos.y = heightOffset; // Altura fija sobre el agua
            transform.position = pos;
        }
    }
}