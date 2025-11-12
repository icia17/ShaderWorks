// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UIRotationShader"
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
		_RotationSpeed("Rotation Speed", Float) = 0.25
		_RotationScaleX("RotationScaleX", Range( 0 , 5)) = 0
		_RotationScaleY("RotationScaleY", Range( 0 , 5)) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_BaseTex("Base Tex", 2D) = "white" {}
		_RotationTint("Rotation Tint", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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
				float4 ase_texcoord2 : TEXCOORD2;
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform sampler2D _Texture0;
			uniform float _RotationScaleX;
			uniform float _RotationScaleY;
			uniform float _RotationSpeed;
			uniform float4 _RotationTint;
			uniform sampler2D _BaseTex;
			uniform float4 _BaseTex_ST;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				float4 appendResult11 = (float4(0.0 , 0.0 , _RotationScaleX , _RotationScaleY));
				float4 temp_output_57_0_g1 = appendResult11;
				float2 temp_output_2_0_g1 = (temp_output_57_0_g1).zw;
				float2 temp_cast_0 = (1.0).xx;
				float2 temp_output_13_0_g1 = ( ( ( IN.texcoord.xy + (temp_output_57_0_g1).xy ) * temp_output_2_0_g1 ) + -( ( temp_output_2_0_g1 - temp_cast_0 ) * 0.5 ) );
				float mulTime9 = _Time.y * _RotationSpeed;
				float TimeVar197_g1 = mulTime9;
				float cos17_g1 = cos( TimeVar197_g1 );
				float sin17_g1 = sin( TimeVar197_g1 );
				float2 rotator17_g1 = mul( temp_output_13_0_g1 - float2( 0.5,0.5 ) , float2x2( cos17_g1 , -sin17_g1 , sin17_g1 , cos17_g1 )) + float2( 0.5,0.5 );
				float2 vertexToFrag246_g1 = rotator17_g1;
				OUT.ase_texcoord2.xy = vertexToFrag246_g1;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				OUT.ase_texcoord2.zw = 0;
				
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

				float2 vertexToFrag246_g1 = IN.ase_texcoord2.xy;
				float4 tex2DNode97_g1 = tex2D( _Texture0, vertexToFrag246_g1 );
				float4 appendResult11 = (float4(0.0 , 0.0 , _RotationScaleX , _RotationScaleY));
				float4 temp_output_57_0_g1 = appendResult11;
				float2 temp_output_2_0_g1 = (temp_output_57_0_g1).zw;
				float2 temp_cast_0 = (1.0).xx;
				float2 temp_output_13_0_g1 = ( ( ( IN.texcoord.xy + (temp_output_57_0_g1).xy ) * temp_output_2_0_g1 ) + -( ( temp_output_2_0_g1 - temp_cast_0 ) * 0.5 ) );
				float temp_output_115_0_g1 = step( ( (temp_output_13_0_g1).y + -0.5 ) , 0.0 );
				float lerpResult125_g1 = lerp( 1.0 , 1.0 , temp_output_115_0_g1);
				float2 uv_BaseTex = IN.texcoord.xy * _BaseTex_ST.xy + _BaseTex_ST.zw;
				float4 temp_output_192_0_g1 = tex2D( _BaseTex, uv_BaseTex );
				
				half4 color = ( ( ( tex2DNode97_g1 * lerpResult125_g1 * tex2DNode97_g1.a ) * _RotationTint ) + temp_output_192_0_g1 );
				
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
440;73;985;604;1204.46;512.9075;1.586436;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;2;-1126.501,-433.9683;Inherit;True;Property;_BaseTex;Base Tex;12;0;Create;True;0;0;0;False;0;False;80ab37a9e4f49c842903bb43bdd7bcd2;80ab37a9e4f49c842903bb43bdd7bcd2;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;8;-957.1486,560.5465;Inherit;False;Property;_RotationSpeed;Rotation Speed;7;0;Create;True;0;0;0;False;0;False;0.25;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1045.672,465.381;Inherit;False;Property;_RotationScaleY;RotationScaleY;9;0;Create;True;0;0;0;False;0;False;0;5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1046.476,374.4221;Inherit;False;Property;_RotationScaleX;RotationScaleX;8;0;Create;True;0;0;0;False;0;False;0;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-867.7761,-436.1951;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;9;-757.1702,558.6237;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;5;-813.0168,-23.07388;Inherit;True;Property;_Texture0;Texture 0;11;0;Create;True;0;0;0;False;0;False;None;6f80de115a7df2c40aac8a100011eeb8;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;4;-782.0129,-214.9746;Inherit;False;Property;_RotationTint;Rotation Tint;13;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;11;-727.5374,376.6682;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;10;-816.8918,170.4784;Inherit;True;Property;_RotationMask;Rotation Mask;10;0;Create;True;0;0;0;False;0;False;596678c53fd54a640bf95ba7dfafd092;596678c53fd54a640bf95ba7dfafd092;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;1;-247.7325,8.527405;Inherit;False;UI-Sprite Effect Layer;0;;1;789bf62641c5cfe4ab7126850acc22b8;18,74,2,204,2,191,1,225,0,242,1,237,0,249,0,186,0,177,0,182,0,229,0,92,0,98,1,234,0,126,1,129,1,130,0,31,1;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;4;UIRotationShader;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;3;0;2;0
WireConnection;9;0;8;0
WireConnection;11;2;12;0
WireConnection;11;3;13;0
WireConnection;1;192;3;0
WireConnection;1;39;4;0
WireConnection;1;37;5;0
WireConnection;1;57;11;0
WireConnection;1;40;9;0
WireConnection;0;0;1;0
ASEEND*/
//CHKSM=5AA813FA9740C239FB66982E241B04008133E92E