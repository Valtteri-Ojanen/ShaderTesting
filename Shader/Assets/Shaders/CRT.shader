Shader "Custom/CRT" {
	Properties {
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Scanline("Scanline", float) = 0.5
		_Contrast("Contrast", Float) = 0
		_Brightness("Brightness", Float) = 0
	}

	SubShader {
		Pass {
			ZTest Always Cull Off ZWrite Off Fog {Mode off}
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			#pragma target 3.0

			struct uniforms
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
				float4 scr_pos : TEXCOORD1;
			};

			sampler2D _MainTex;
			
			float _Scanline;
			float _Contrast;
			float _Brightness;

			uniforms vert (appdata_img v) {
				uniforms o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord);
				o.scr_pos = ComputeScreenPos(o.pos);
				return o;
			}


			half4 frag(uniforms i) : Color {
				float2 pixelpos = i.scr_pos.xy * _ScreenParams.xy / i.scr_pos.w;
				half4 color = tex2D(_MainTex, i.uv);
				int pixelposXMod = (int)pixelpos.x % 3.0;

				color += (_Brightness / 255);
				color = color - _Contrast * (color-1.0) * color * (color - 0.5);

				if(pixelposXMod == 0) {
					color.b *= 0.5;
					color.g *= 0.5;
				}
				else if (pixelposXMod == 1) {
					color.r *= 0.5;
					color.b *= 0.5;
				}
				else if(pixelposXMod == 2) {
					color.r *= 0.5;
					color.g *= 0.5;
				}
				if((int)pixelpos.y % 3.0 == 0) {
					color *= float4(_Scanline,_Scanline,_Scanline,1);
				}

				return color;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
