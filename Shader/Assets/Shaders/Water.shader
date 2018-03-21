Shader "Custom/Water" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_BlendColor("Blend Color", Color) = (1,1,1,1)
		_Softness("Softness", Range(0.01, 3.0)) = 1.0
		_FadeLimit("Fade Limit", Range(0.0, 1.0)) = 0.3
		_Speed("Speed", float) = 1
		_Amplitude("Amplitude", Range(0.0,4.0)) = 1
		_Offset("Offset", Range(0.0,4.0)) = 0
		_MainTex("Texture", 2D) = "white"{}
	}
	SubShader {
		Tags { "Queue" = "Transparent" "RenderType" ="Transparent" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard vertex:vert alpha:fade nolightmap
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
			float4 screenPos;
			float eyeDepth;
		};

		sampler2D_float _CameraDepthTexture;
		fixed4 _Color;
		fixed4 _BlendColor;
		float _FadeLimit;
		float _Softness;
		float _Speed;
		float _Amplitude;
		float _Offset;
		sampler2D _MainTex;

		void vert(inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input, o);
			COMPUTE_EYEDEPTH(o.eyeDepth);
			float sinTimeX = 0.1 * sin(_Time.y * _Speed + (v.vertex.x * _Offset) * v.vertex.z );
			float cosTimeX = 0.1 * cos(_Time.y * _Speed +(v.vertex.x * _Offset) * v.vertex.z  * _Offset);

			v.vertex.x += sinTimeX * _Amplitude;
			v.vertex.z += cosTimeX * _Amplitude;
			v.vertex.y += (sinTimeX + cosTimeX) * _Amplitude;
		}


		void surf (Input IN, inout SurfaceOutputStandard o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
			o.Alpha = 0.7;
			o.Metallic = 0;
			o.Smoothness = 0;

			float rawZ = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(IN.screenPos));
			float sceneZ = LinearEyeDepth(rawZ);
			float partZ = IN.eyeDepth;

			float fade = 1.0;

			if(rawZ > 0.0) {
				fade = saturate(_Softness * (sceneZ - partZ));
			}

			if(fade < _FadeLimit) {
				o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * fade + _BlendColor * (1-fade);
			}
		}
		ENDCG
	}
	FallBack "Diffuse"
}
