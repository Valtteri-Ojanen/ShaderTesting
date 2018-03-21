Shader "Custom/Textured" {
	Properties {
		_MainTex("Texture", 2D) = "white"{}
		_BumpMap("BumbMap", 2D) = "bump" {}
		_Metal("Metal", Float) = 1
		_Smooth("Smooth", Float) = 1
		_USpeed("USpeed", Float) = 1
		_VSpeed("VSpeed", Float) = 1
		_UVScale("UVScale", Float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
		};

		sampler2D _MainTex;
		sampler2D _BumpMap;
		float _Metal;
		float _Smooth;
		float _USpeed;
		float _VSpeed;
		float2 UVSpeed;
		float _UVScale;


		void surf (Input IN, inout SurfaceOutputStandard o) {
			UVSpeed.x = _SinTime.y * _USpeed;
			UVSpeed.y = _SinTime.y * _VSpeed;
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex * _UVScale + UVSpeed);
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap * _UVScale + UVSpeed));
			o.Metallic = _Metal;
			o.Smoothness = _Smooth;

		}
		ENDCG
	}
	FallBack "Diffuse"
}
