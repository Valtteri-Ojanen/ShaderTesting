Shader "Custom/ColorCycler" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Int ("Int", Int) = 1
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float2 color : COLOR;
		};

		fixed4 _Color;
		int _Int;

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = _Color * _SinTime * _Int;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
