using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class DissolveAnim : MonoBehaviour
{
    [SerializeField] float minValue = 0f;
    [SerializeField] float maxValue = 1f;
    [SerializeField] float animDuration = 1.0f;

    [SerializeField] Material material;

    bool isActing = false;
    private void Update()
    {
        if (!isActing && Input.GetKeyDown(KeyCode.UpArrow))
        {
            StartCoroutine(DoAnim(minValue, maxValue));
        }
        else if (!isActing && Input.GetKeyDown(KeyCode.DownArrow))
        {
            StartCoroutine(DoAnim(maxValue, minValue));
        }
    }

    IEnumerator DoAnim(float from, float to)
    {
        isActing = true;
        float eTime = 0f;
        while(eTime < animDuration)
        {
            material.SetFloat("_PhaseHeight", Mathf.Lerp(from, to, eTime / animDuration));
            yield return null;
            eTime += Time.deltaTime;
        }
        material.SetFloat("_PhaseHeight",to);
        isActing = false;
    }
}
