using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]

public class CRT : MonoBehaviour {

    public Shader shader;
    private Material _material;

    [Range(0.0f,1.0f)]
    public float _scanlineMult;

    [Range(-3.0f, 20.0f)]
    public float contrast = 0f;

    [Range(-200.0f, 200.0f)]
    public float brightness = 0f;


    protected Material Material
    {
        get
        {
            if(null == _material)
            {
                _material = new Material(shader);
                _material.hideFlags = HideFlags.HideAndDontSave;
            }
            return _material;
        }
    }

    private void OnRenderImage( RenderTexture source, RenderTexture destination )
    {
        if(null != shader)
        {
            Material mat = Material;
            mat.SetFloat("_Scanline", _scanlineMult);
            mat.SetFloat("_Contrast", contrast);
            mat.SetFloat("_Brightness", brightness);
            Graphics.Blit(source, destination, mat);
        } else
        {
            Graphics.Blit(source, destination);
        }
    }

    private void OnDisable()
    {
        if(_material)
            DestroyImmediate(_material);
    }
}
