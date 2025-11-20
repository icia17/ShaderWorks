// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Greyscale"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_GrayscaleLuminance1("Grayscale Luminance", Vector) = (0.299,0.587,0.114,0)
		_VignetteFalloff1("Vignette Falloff", Range( 0 , 15)) = 0
		_ScreenBrightness1("Screen Brightness", Float) = 1.53
		_VignetteSharpness1("Vignette Sharpness", Float) = 0
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
			
			uniform float3 _GrayscaleLuminance1;
			uniform float _VignetteFalloff1;
			uniform float _VignetteSharpness1;
			uniform float _ScreenBrightness1;


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
				float dotResult18 = dot( tex2D( _MainTex, uv_MainTex ) , float4( _GrayscaleLuminance1 , 0.0 ) );
				float4 appendResult20 = (float4(dotResult18 , dotResult18 , dotResult18 , 0.0));
				float4 weightedBlendVar5 = float4( 0.5,0.5,0.5,0.5 );
				float4 weightedAvg5 = ( ( weightedBlendVar5.x*( appendResult20 * ( 1.0 - pow( ( length( ( uv_MainTex - float2( 0.5,0.5 ) ) ) * _VignetteFalloff1 ) , _VignetteSharpness1 ) ) ) + weightedBlendVar5.y*float4( 0,0,0,0 ) + weightedBlendVar5.z*float4( 0,0,0,0 ) + weightedBlendVar5.w*float4( 0,0,0,0 ) )/( weightedBlendVar5.x + weightedBlendVar5.y + weightedBlendVar5.z + weightedBlendVar5.w ) );
				

				finalColor = saturate( ( weightedAvg5 * _ScreenBrightness1 ) );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
590.4;73.6;490.7999;451;937.9643;424.6686;2.431822;False;False
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;8;-1384.948,-178.8924;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1156.736,212.4946;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;10;-904.4021,210.1541;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;12;-731.4031,220.1541;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-957.1671,354.8168;Inherit;False;Property;_VignetteFalloff1;Vignette Falloff;1;0;Create;True;0;0;0;False;0;False;0;1.4;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-714.8351,-176.3806;Inherit;True;Property;_TextureSample1;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-648.2211,403.3633;Inherit;False;Property;_VignetteSharpness1;Vignette Sharpness;3;0;Create;True;0;0;0;False;0;False;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;14;-688.4591,21.2159;Inherit;False;Property;_GrayscaleLuminance1;Grayscale Luminance;0;0;Create;True;0;0;0;False;0;False;0.299,0.587,0.114;1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-581.5021,243.9544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;17;-420.8066,302.2906;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;18;-398.7614,-7.025967;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;-261.7505,305.8527;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-252.5298,-29.67656;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;54.66388,104.6201;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WeightedBlendNode;5;208.883,79.70078;Inherit;False;5;0;FLOAT4;0.5,0.5,0.5,0.5;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;4;211.5607,290.7408;Inherit;False;Property;_ScreenBrightness1;Screen Brightness;2;0;Create;True;0;0;0;False;0;False;1.53;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;422.6862,183.5065;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;7;575.6641,196.2753;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;791.5837,166.9153;Float;False;True;-1;2;ASEMaterialInspector;0;2;Greyscale;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;9;2;8;0
WireConnection;10;0;9;0
WireConnection;12;0;10;0
WireConnection;16;0;8;0
WireConnection;15;0;12;0
WireConnection;15;1;11;0
WireConnection;17;0;15;0
WireConnection;17;1;13;0
WireConnection;18;0;16;0
WireConnection;18;1;14;0
WireConnection;19;0;17;0
WireConnection;20;0;18;0
WireConnection;20;1;18;0
WireConnection;20;2;18;0
WireConnection;3;0;20;0
WireConnection;3;1;19;0
WireConnection;5;1;3;0
WireConnection;6;0;5;0
WireConnection;6;1;4;0
WireConnection;7;0;6;0
WireConnection;0;0;7;0
ASEEND*/
//CHKSM=375112DEF27A2780A6BAA1F9FA234782B3784166