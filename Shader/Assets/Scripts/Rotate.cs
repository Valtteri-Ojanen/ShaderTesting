﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour {

	
	
	// Update is called once per frame
	void Update () {

        transform.Rotate(new Vector3(0f, 50f * Time.deltaTime, 0f));
	}
}
