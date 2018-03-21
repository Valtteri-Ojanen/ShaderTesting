Shader "Custom/VertexOffset" {
Properties {
		_MainTex("Texture", 2D) = "white"{}
		_BumpMap("BumbMap", 2D) = "bump" {}
		_Metal("Metal", Float) = 1
		_Smooth("Smooth", Float) = 1
		_USpeed("USpeed", Float) = 1
		_VSpeed("VSpeed", Float) = 1
		_UVScale("UVScale", Float) = 1
		_Amount("Offset Amount", Float) = 1
		_speed("Speed", Float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows vertex:vert

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
		float _UVScale;
		float _Amount;
		float _Speed;

		void vert (inout appdata_full v) {

			v.vertex.xyz += v.normal * _Amount;
		}


		void surf (Input IN, inout SurfaceOutputStandard o) {
			float2 vAlbedoOffset = (IN.uv_MainTex * _UVScale) + float2(_Time.y * _USpeed, _Time.y * _VSpeed);
			float2 vNormOffset = (IN.uv_BumpMap * _UVScale) + float2(_Time.y * _USpeed, _Time.y * _VSpeed);

			o.Albedo = tex2D(_MainTex, vAlbedoOffset).rgb;
			o.Normal = UnpackNormal(tex2D(_BumpMap, vNormOffset));
			o.Metallic = _Metal;
			o.Smoothness = _Smooth;

		}
		ENDCG
	}
	FallBack "Diffuse"
}