using System.Collections;
using System.Collections.Generic;
using System.Linq.Expressions;
using UnityEditor.ShaderGraph.Internal;
using UnityEngine;

[ExecuteAlways]
public class SkyboxController : MonoBehaviour
{
    [Header("Game Objects")]
    public Material _SkyboxMaterial;
    public Light _MainLight;

    [Header("Time Controller")]
    public bool _IsRunning = false;
    [Range(0f, 24f)]
    public float _CurrrentTime = 12.0f;
    [Range(0.1f, 10.0f)]
    public float _TimeSpeed = 1.0f;

    [Header("Sky Morning")]
    public Gradient _MorningColorGradient;
    public AnimationCurve _MorningTimeCurve;

    [Header("Sky Morning")]
    public Gradient _AfternoonColorGradient;
    public AnimationCurve _AfternoonTimeCurve;

    [Header("Sky Dusk")]
    public Gradient _DuskColorGradient;
    public AnimationCurve _DuskTimeCurve;


    [Header("Sky Night")]
    public Gradient _NightColorGradient;
    public AnimationCurve _NightTimeCurve;

    [Header("Cloud")]
    public AnimationCurve _CloudTimeCurve;

    [Header("Aurora")]
    public AnimationCurve _AuroraTimeCurve;

    private float deltaTime = 0.01f;
    private Vector3 curRotation = Vector3.zero;
    private int gradientResolution = 256;
    private int curveResolution = 1024;
    private Texture2D morningColorGradientTexture;
    private Texture2D afternoonColorGradientTexture;
    private Texture2D duskColorGradientTexture;
    private Texture2D nightColorGradientTexture;
    private Texture2D morningTimeCurveTexture;
    private Texture2D afternoonTimeCurveTexture;
    private Texture2D duskTimeCurveTexture;
    private Texture2D nightTimeCurveTexture;
    private Texture2D cloudTimeCurveTexture;
    private Texture2D auroraTimeCurveTexture;

    void Start()
    {
        curRotation = _MainLight.transform.rotation.eulerAngles;
        curRotation.x = _CurrrentTime / 24.0f * 360.0f - 90.0f;
        _MainLight.transform.rotation = Quaternion.Euler(curRotation);
        _SkyboxMaterial.SetFloat("_CurrentTime", _CurrrentTime);

        morningColorGradientTexture = GetGradientTexture(_MorningColorGradient);
        afternoonColorGradientTexture = GetGradientTexture(_AfternoonColorGradient);
        duskColorGradientTexture = GetGradientTexture(_DuskColorGradient);
        nightColorGradientTexture = GetGradientTexture(_NightColorGradient);

        _SkyboxMaterial.SetTexture("_MorningColorGradientTexture", morningColorGradientTexture);
        _SkyboxMaterial.SetTexture("_AfternoonColorGradientTexture", afternoonColorGradientTexture);
        _SkyboxMaterial.SetTexture("_DuskColorGradientTexture", duskColorGradientTexture);
        _SkyboxMaterial.SetTexture("_NightColorGradientTexture", nightColorGradientTexture);

        morningTimeCurveTexture = GetCurveTexture(_MorningTimeCurve);
        afternoonTimeCurveTexture = GetCurveTexture (_AfternoonTimeCurve);
        duskTimeCurveTexture = GetCurveTexture (_DuskTimeCurve);
        nightTimeCurveTexture = GetCurveTexture (_NightTimeCurve);
        _SkyboxMaterial.SetTexture("_MorningTimeCurveTexture", morningTimeCurveTexture);
        _SkyboxMaterial.SetTexture("_AfternoonTimeCurveTexture", afternoonTimeCurveTexture);
        _SkyboxMaterial.SetTexture("_DuskTimeCurveTexture", duskTimeCurveTexture);
        _SkyboxMaterial.SetTexture("_NightTimeCurveTexture", nightTimeCurveTexture);

        cloudTimeCurveTexture = GetCurveTexture(_CloudTimeCurve);
        _SkyboxMaterial.SetTexture("_CloudTimeCurveTexture", cloudTimeCurveTexture);

        auroraTimeCurveTexture = GetCurveTexture(_AuroraTimeCurve);
        _SkyboxMaterial.SetTexture("_AuroraTimeCurveTexture", auroraTimeCurveTexture);

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

    // void OnDestroy()
    // {
    //     ReleaseAllTextures();
    // }

    private Texture2D GetGradientTexture(Gradient gradient)
    {
        Texture2D gradientTexture = new Texture2D(gradientResolution, 1);
        gradientTexture.wrapMode = TextureWrapMode.Clamp;
        for (int i = 0; i < gradientResolution; i++)
        {
            Color color = gradient.Evaluate(i / 255f);
            gradientTexture.SetPixel(i, 0, color);
        }
        gradientTexture.Apply();
        return gradientTexture;
    }

        private Texture2D GetCurveTexture(AnimationCurve curve)
    {
        Texture2D curveTexture = new Texture2D(curveResolution, 1);
        curveTexture.wrapMode = TextureWrapMode.Clamp;
        for (int i = 0; i < curveResolution; i++)
        {
            float t = i / (float)(curveResolution - 1) * 24.0f;
            float value = curve.Evaluate(t);        
            curveTexture.SetPixel(i, 0, new Color(value, 0, 0, 1));
        }
        curveTexture.Apply();
        return curveTexture;
    }

    private void ReleaseAllTextures()
    {
        if (morningColorGradientTexture != null)
        {
            Destroy(morningColorGradientTexture);
            morningColorGradientTexture = null;
        }
        if (afternoonColorGradientTexture != null)
        {
            Destroy(afternoonColorGradientTexture);
            afternoonColorGradientTexture = null;
        }
        if (duskColorGradientTexture != null)
        {
            Destroy(duskColorGradientTexture);
            duskColorGradientTexture = null;
        }
        if (nightColorGradientTexture != null)
        {
            Destroy(nightColorGradientTexture);
            nightColorGradientTexture = null;
        }
        if (morningTimeCurveTexture != null)
        {
            Destroy(morningTimeCurveTexture);
            morningTimeCurveTexture = null;
        }
        if (afternoonTimeCurveTexture != null)
        {
            Destroy(afternoonTimeCurveTexture);
            afternoonTimeCurveTexture = null;
        }
        if (duskTimeCurveTexture != null)
        {
            Destroy(duskTimeCurveTexture);
            duskTimeCurveTexture = null;
        }
        if (nightTimeCurveTexture != null)
        {
            Destroy(nightTimeCurveTexture);
            nightTimeCurveTexture = null;
        }
        if (cloudTimeCurveTexture != null)
        {
            Destroy(cloudTimeCurveTexture);
            cloudTimeCurveTexture = null;
        }
        if (auroraTimeCurveTexture != null)
        {
            Destroy(auroraTimeCurveTexture);
            auroraTimeCurveTexture = null;
        }
    }
}
