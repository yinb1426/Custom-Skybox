using System.Collections;
using System.Collections.Generic;
using System.Linq.Expressions;
using UnityEditor.ShaderGraph.Internal;
using UnityEngine;

[ExecuteAlways]
public class SkyboxController : MonoBehaviour
{
    [Header("Game Objects")]
    [SerializeField]
    public Material _SkyboxMaterial;

    [SerializeField]
    public Light _MainLight;

    [Header("Running Controller")]
    [SerializeField]
    public bool _IsRunning = false;

    [SerializeField, Range(0f, 24f)]
    public float _CurrrentTime = 12.0f;

    [SerializeField, Range(0.1f, 10.0f)]
    public float _TimeSpeed = 1.0f;

    private float deltaTime = 0.01f;
    private Vector3 curRotation = Vector3.zero;

    void Start()
    {
        curRotation = _MainLight.transform.rotation.eulerAngles;
        curRotation.x = _CurrrentTime / 24.0f * 360.0f - 90.0f;
        _MainLight.transform.rotation = Quaternion.Euler(curRotation);
        _SkyboxMaterial.SetFloat("_CurrentTime", _CurrrentTime);
    }

    // Update is called once per frame
    void Update()
    {
        if(_IsRunning)
        {
            float newDeltaTime = deltaTime * _TimeSpeed;
            _CurrrentTime += newDeltaTime;
            if (_CurrrentTime > 24.0f)
                _CurrrentTime -= 24.0f;
            curRotation.x += newDeltaTime / 24.0f * 360.0f;
            if (curRotation.x > 180.0f)
                curRotation.x -= 360.0f;
        }
        else
        {
            curRotation.x = _CurrrentTime / 24.0f * 360.0f - 90.0f;
        }
        _SkyboxMaterial.SetFloat("_CurrentTime", _CurrrentTime);
        _MainLight.transform.rotation = Quaternion.Euler(curRotation);
    }
}
