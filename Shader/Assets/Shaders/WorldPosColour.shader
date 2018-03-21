Shader "Custom/WorldPosColour" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		sampler2D _MainTex;

		struct Input {
			float3 worldPos;
		};

		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutput o) {
			
			o.Albedo = fixed4(
			fmod( abs(IN.worldPos.x + _Time.y), 1.0),
			fmod( abs(IN.worldPos.y + _Time.y), 1.0),
			fmod( abs(IN.worldPos.z + _Time.y), 1.0),
			1) * _Color;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
