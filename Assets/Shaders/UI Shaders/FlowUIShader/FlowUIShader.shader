// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlowUIShader"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_Speed("Speed", Float) = 1
		_FlowTex("Flow Tex", 2D) = "white" {}
		_RampTex("Ramp Tex", 2D) = "white" {}
		_DistortionTex("Distortion Tex", 2D) = "white" {}
		_DistortionNormalTex("Distortion Normal Tex", 2D) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			#include "UnityStandardUtils.cginc"
			#include "UnityShaderVariables.cginc"

			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform sampler2D _DistortionTex;
			uniform sampler2D _DistortionNormalTex;
			uniform float4 _DistortionTex_ST;
			uniform sampler2D _RampTex;
			uniform sampler2D _FlowTex;
			uniform float4 _FlowTex_ST;
			uniform float _Speed;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_DistortionTex = IN.texcoord.xy * _DistortionTex_ST.xy + _DistortionTex_ST.zw;
				float2 MainUvs222_g2 = uv_DistortionTex;
				float4 tex2DNode65_g2 = tex2D( _DistortionNormalTex, MainUvs222_g2 );
				float4 appendResult82_g2 = (float4(0.0 , tex2DNode65_g2.g , 0.0 , tex2DNode65_g2.r));
				float2 temp_output_84_0_g2 = (UnpackScaleNormal( appendResult82_g2, 0.3 )).xy;
				float2 temp_output_71_0_g2 = ( temp_output_84_0_g2 + MainUvs222_g2 );
				float4 tex2DNode96_g2 = tex2D( _DistortionTex, temp_output_71_0_g2 );
				float2 uv_FlowTex = IN.texcoord.xy * _FlowTex_ST.xy + _FlowTex_ST.zw;
				float4 tex2DNode14_g1 = tex2D( _FlowTex, uv_FlowTex );
				float2 appendResult20_g1 = (float2(tex2DNode14_g1.r , tex2DNode14_g1.g));
				float mulTime10 = _Time.y * _Speed;
				float TimeVar197_g1 = mulTime10;
				float2 temp_cast_0 = (TimeVar197_g1).xx;
				float2 temp_output_18_0_g1 = ( appendResult20_g1 - temp_cast_0 );
				float4 tex2DNode72_g1 = tex2D( _RampTex, temp_output_18_0_g1 );
				float4 weightedBlendVar22 = float4( 1,1,1,0 );
				float4 weightedBlend22 = ( weightedBlendVar22.x*tex2DNode96_g2 + weightedBlendVar22.y*( ( tex2DNode72_g1 * tex2DNode14_g1.a ) * float4( 1,1,1,1 ) ) + weightedBlendVar22.z*float4( 0,0,0,0 ) + weightedBlendVar22.w*float4( 0,0,0,0 ) );
				
				half4 color = weightedBlend22;
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
212.8;73.6;497.2;463.8;488.6501;-525.792;1;False;False
Node;AmplifyShaderEditor.RangedFloatNode;11;-593.895,383.4678;Inherit;False;Property;_Speed;Speed;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;5;-473.1321,185.2238;Inherit;True;Property;_FlowTex;Flow Tex;8;0;Create;True;0;0;0;False;0;False;6525cc3a0b430154eba0612a6a0d7b4d;6525cc3a0b430154eba0612a6a0d7b4d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleTimeNode;10;-418.1992,388.9728;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-468.4273,-31.94517;Inherit;True;Property;_RampTex;Ramp Tex;9;0;Create;True;0;0;0;False;0;False;948990beaa590ae4a8e23c1c8578fc7d;948990beaa590ae4a8e23c1c8578fc7d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;16;-484.0223,907.2248;Inherit;False;Constant;_DistortionAmount;Distortion Amount;7;0;Create;True;0;0;0;False;0;False;0.3;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;14;-470.8494,486.4274;Inherit;True;Property;_DistortionTex;Distortion Tex;10;0;Create;True;0;0;0;False;0;False;36be8d528a4fa024faa4680d7658642c;948990beaa590ae4a8e23c1c8578fc7d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;15;-445.9918,685.2448;Inherit;True;Property;_DistortionNormalTex;Distortion Normal Tex;11;0;Create;True;0;0;0;False;0;False;d710ce45bb70a4341bf82edae6bf7596;948990beaa590ae4a8e23c1c8578fc7d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;1;-123.9041,145.4006;Inherit;True;UI-Sprite Effect Layer;0;;1;789bf62641c5cfe4ab7126850acc22b8;18,74,1,204,1,191,1,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,1,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.FunctionNode;12;-82.70724,489.8804;Inherit;False;UI-Sprite Effect Layer;0;;2;789bf62641c5cfe4ab7126850acc22b8;18,74,0,204,0,191,0,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,0,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.SummedBlendNode;22;331.0613,351.1502;Inherit;False;5;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;521.8018,327.5822;Float;False;True;-1;2;ASEMaterialInspector;0;4;FlowUIShader;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;10;0;11;0
WireConnection;1;37;4;0
WireConnection;1;33;5;0
WireConnection;1;40;10;0
WireConnection;12;37;14;0
WireConnection;12;75;15;0
WireConnection;12;80;16;0
WireConnection;22;1;12;0
WireConnection;22;2;1;0
WireConnection;0;0;22;0
ASEEND*/
//CHKSM=E63D575CA65ED251734C5C58F813C1F69D2BB000