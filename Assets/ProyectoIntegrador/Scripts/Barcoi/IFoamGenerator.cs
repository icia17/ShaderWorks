
using UnityEngine;

public interface IFoamGenerator
{

    Vector3 GetFoamPosition();
    

    bool IsActive();
    
  
    float GetFoamRadius();
}