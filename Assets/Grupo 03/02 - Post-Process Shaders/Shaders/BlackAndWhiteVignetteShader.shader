// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BlackAndWhiteVignetteShader"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_GrayscaleLuminance("Grayscale Luminance", Vector) = (0.299,0.587,0.114,0)
		_VignetteFalloff("Vignette Falloff", Range( 0 , 15)) = 0
		_ScreenBrightness("Screen Brightness", Float) = 1.53
		_VignetteSharpness("Vignette Sharpness", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float3 _GrayscaleLuminance;
			uniform float _VignetteFalloff;
			uniform float _VignetteSharpness;
			uniform float _ScreenBrightness;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float dotResult17 = dot( tex2D( _MainTex, uv_MainTex ) , float4( _GrayscaleLuminance , 0.0 ) );
				float4 appendResult23 = (float4(dotResult17 , dotResult17 , dotResult17 , 0.0));
				float4 weightedBlendVar25 = float4( 0.5,0.5,0.5,0.5 );
				float4 weightedAvg25 = ( ( weightedBlendVar25.x*( appendResult23 * ( 1.0 - pow( ( length( ( uv_MainTex - float2( 0.5,0.5 ) ) ) * _VignetteFalloff ) , _VignetteSharpness ) ) ) + weightedBlendVar25.y*float4( 0,0,0,0 ) + weightedBlendVar25.z*float4( 0,0,0,0 ) + weightedBlendVar25.w*float4( 0,0,0,0 ) )/( weightedBlendVar25.x + weightedBlendVar25.y + weightedBlendVar25.z + weightedBlendVar25.w ) );
				

				finalColor = saturate( ( weightedAvg25 * _ScreenBrightness ) );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
627;73;789;604;3531.43;1396.874;5.773556;True;False
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;35;-1631.877,-221.4008;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-1594.619,165.159;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;45;-1342.285,162.8185;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1391.481,330.084;Inherit;False;Property;_VignetteFalloff;Vignette Falloff;1;0;Create;True;0;0;0;False;0;False;0;1.4;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;46;-1169.286,172.8185;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-1152.718,-223.7162;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;50;-1086.104,356.0277;Inherit;False;Property;_VignetteSharpness;Vignette Sharpness;3;0;Create;True;0;0;0;False;0;False;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;14;-1126.342,-26.11969;Inherit;False;Property;_GrayscaleLuminance;Grayscale Luminance;0;0;Create;True;0;0;0;False;0;False;0.299,0.587,0.114;1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1019.385,196.6188;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;49;-858.6896,254.955;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;17;-836.6444,-54.36156;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-690.4127,-77.01215;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;54;-699.6335,258.5171;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-383.2191,57.28446;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-226.3223,243.4052;Inherit;False;Property;_ScreenBrightness;Screen Brightness;2;0;Create;True;0;0;0;False;0;False;1.53;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WeightedBlendNode;25;-229,32.36519;Inherit;False;5;0;FLOAT4;0.5,0.5,0.5,0.5;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-15.19681,136.1709;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;53;137.7811,148.9397;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;28;289.4633,138.3928;Float;False;True;-1;2;ASEMaterialInspector;0;2;BlackAndWhiteVignetteShader;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;38;2;35;0
WireConnection;45;0;38;0
WireConnection;46;0;45;0
WireConnection;36;0;35;0
WireConnection;47;0;46;0
WireConnection;47;1;16;0
WireConnection;49;0;47;0
WireConnection;49;1;50;0
WireConnection;17;0;36;0
WireConnection;17;1;14;0
WireConnection;23;0;17;0
WireConnection;23;1;17;0
WireConnection;23;2;17;0
WireConnection;54;0;49;0
WireConnection;24;0;23;0
WireConnection;24;1;54;0
WireConnection;25;1;24;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;53;0;27;0
WireConnection;28;0;53;0
ASEEND*/
//CHKSM=38F4761615386AEF4BD73101589DC955A8F8F53E