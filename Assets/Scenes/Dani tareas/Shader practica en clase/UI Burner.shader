// Upgrade NOTE: upgraded instancing buffer 'BurnPosition' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Burn Position"
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
		_Basetexture("Base texture ", 2D) = "white" {}
		_NoiseTexture("Noise Texture", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_Texture1("Texture 1", 2D) = "white" {}
		_EdgeIntensity("Edge Intensity ", Float) = 1
		_DissolveAmount("Dissolve Amount", Float) = 1
		_EdgeWidth("Edge Width", Float) = 1
		_Gradientcolor1("Gradient color 1", Color) = (0.8679245,0.4616314,0,0)
		_Color1("Color 1", Color) = (0.9716981,0.7888607,0,0)
		_Gradientcolor2("Gradient color 2 ", Color) = (0.4433962,0.2823514,0,0)
		_Edgecolorstart("Edge color start", Color) = (0.7735849,0,0,0)
		_Burndirection("Burn direction", Vector) = (0,-1,0,0)
		_BurnPosition("Burn Position", Range( -1 , 2)) = 0.5

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
			
			#pragma multi_compile_instancing

			
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
			uniform sampler2D _Basetexture;
			uniform sampler2D _Texture0;
			uniform float2 _Burndirection;
			uniform float _BurnPosition;
			uniform sampler2D _NoiseTexture;
			uniform sampler2D _Texture1;
			uniform float _DissolveAmount;
			uniform float4 _Edgecolorstart;
			uniform float4 _Color1;
			uniform float4 _Gradientcolor1;
			uniform float4 _Gradientcolor2;
			uniform float _EdgeWidth;
			UNITY_INSTANCING_BUFFER_START(BurnPosition)
				UNITY_DEFINE_INSTANCED_PROP(float4, _Texture0_ST)
#define _Texture0_ST_arr BurnPosition
				UNITY_DEFINE_INSTANCED_PROP(float4, _Texture1_ST)
#define _Texture1_ST_arr BurnPosition
				UNITY_DEFINE_INSTANCED_PROP(float, _EdgeIntensity)
#define _EdgeIntensity_arr BurnPosition
			UNITY_INSTANCING_BUFFER_END(BurnPosition)

			
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

				float4 _Texture0_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Texture0_ST_arr, _Texture0_ST);
				float2 uv_Texture0 = IN.texcoord.xy * _Texture0_ST_Instance.xy + _Texture0_ST_Instance.zw;
				float4 tex2DNode1 = tex2D( _Basetexture, uv_Texture0 );
				float2 texCoord31 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float dotResult30 = dot( texCoord31 , _Burndirection );
				float4 _Texture1_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Texture1_ST_arr, _Texture1_ST);
				float2 uv_Texture1 = IN.texcoord.xy * _Texture1_ST_Instance.xy + _Texture1_ST_Instance.zw;
				float temp_output_14_0 = ( ( ( dotResult30 + _BurnPosition ) + tex2D( _NoiseTexture, uv_Texture1 ).r ) == _DissolveAmount ? 0.0 : 0.0 );
				float4 lerpResult18 = lerp( _Edgecolorstart , _Color1 , tex2D( _NoiseTexture, uv_Texture1 ).r);
				float4 lerpResult36 = lerp( _Gradientcolor1 , _Gradientcolor2 , tex2D( _NoiseTexture, uv_Texture1 ).r);
				float4 lerpResult37 = lerp( lerpResult18 , lerpResult36 , (0.0 + (tex2D( _NoiseTexture, uv_Texture1 ).r - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)));
				float _EdgeIntensity_Instance = UNITY_ACCESS_INSTANCED_PROP(_EdgeIntensity_arr, _EdgeIntensity);
				
				half4 color = ( ( ( tex2DNode1 * temp_output_14_0 ) + ( ( lerpResult37 * ( ( temp_output_14_0 > ( _DissolveAmount + _EdgeWidth ) ? 0.0 : 0.0 ) - temp_output_14_0 ) ) * _EdgeIntensity_Instance ) ) + tex2DNode1 );
				
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
726;73;710;503;1706.19;1102.131;1;False;False
Node;AmplifyShaderEditor.TexturePropertyNode;4;-2491.818,-73.18797;Inherit;True;Property;_Texture1;Texture 1;3;0;Create;True;0;0;0;False;0;False;bdbe94d7623ec3940947b62544306f1c;bdbe94d7623ec3940947b62544306f1c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector2Node;28;-1751.495,540.3603;Inherit;False;Property;_Burndirection;Burn direction;11;0;Create;True;0;0;0;False;0;False;0,-1;-57.89117,-92.8;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-2224.166,29.97372;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-2143.152,272.4453;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-1427.565,604.4833;Inherit;False;Property;_BurnPosition;Burn Position;12;0;Create;True;0;0;0;False;0;False;0.5;2;-1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;30;-1605.887,255.8767;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1961.971,-52.40877;Inherit;True;Property;_NoiseTexture;Noise Texture;1;0;Create;True;0;0;0;False;0;False;-1;bdbe94d7623ec3940947b62544306f1c;bdbe94d7623ec3940947b62544306f1c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;13;-1590.493,-182.3658;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;26;-909.2585,331.6223;Inherit;False;1344.187;352.2484;Dissolve Mask;8;6;5;15;16;17;9;20;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1305.817,256.644;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-859.2592,434.9031;Inherit;False;Property;_DissolveAmount;Dissolve Amount;5;0;Create;True;0;0;0;False;0;False;1;10.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-816.5026,566.0849;Inherit;False;Property;_EdgeWidth;Edge Width;6;0;Create;True;0;0;0;False;0;False;1;21.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-912.542,111.9751;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;39;-1518.942,-1215.015;Inherit;False;1013.946;886.249;Colores;8;38;7;34;8;35;18;36;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;34;-1238.905,-1072.535;Inherit;False;Property;_Color1;Color 1;8;0;Create;True;0;0;0;False;0;False;0.9716981,0.7888607,0,0;0.8301887,0.5309738,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;8;-1468.942,-946.6567;Inherit;False;Property;_Gradientcolor1;Gradient color 1;7;0;Create;True;0;0;0;False;0;False;0.8679245,0.4616314,0,0;0.990566,0.7932865,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;14;-532.5101,75.08405;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-617.1807,443.2255;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;35;-1272.617,-727.9708;Inherit;False;Property;_Gradientcolor2;Gradient color 2 ;9;0;Create;True;0;0;0;False;0;False;0.4433962,0.2823514,0,0;0.3490566,0.1593457,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-998.9037,-1165.015;Inherit;False;Property;_Edgecolorstart;Edge color start;10;0;Create;True;0;0;0;False;0;False;0.7735849,0,0,0;0.7735849,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;36;-882.5198,-647.7373;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;38;-863.6879,-531.5662;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-48.959,-478.2054;Inherit;True;Property;_Texture0;Texture 0;2;0;Create;True;0;0;0;False;0;False;05c8444f2486e5a43ba3438f935d2b38;bdbe94d7623ec3940947b62544306f1c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Compare;16;-407.463,440.2925;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;-881.8099,-764.4146;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;308.1209,-291.4753;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;17;-206.2219,405.4774;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;37;-687.6058,-684.9611;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;574.7491,-462.0604;Inherit;True;Property;_Basetexture;Base texture ;0;0;Create;True;0;0;0;False;0;False;-1;05c8444f2486e5a43ba3438f935d2b38;05c8444f2486e5a43ba3438f935d2b38;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;101.0212,381.6222;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-5.802418,568.7104;Inherit;False;InstancedProperty;_EdgeIntensity;Edge Intensity ;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;699.7654,-72.79031;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;267.3878,390.3511;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;981.1884,-15.19754;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;1188.146,-20.25639;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1365.867,-24.83383;Float;False;True;-1;2;ASEMaterialInspector;0;4;Burn Position;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;12;2;4;0
WireConnection;30;0;31;0
WireConnection;30;1;28;0
WireConnection;3;1;12;0
WireConnection;13;0;3;0
WireConnection;32;0;30;0
WireConnection;32;1;29;0
WireConnection;33;0;32;0
WireConnection;33;1;13;0
WireConnection;14;0;33;0
WireConnection;14;1;5;0
WireConnection;15;0;5;0
WireConnection;15;1;6;0
WireConnection;36;0;8;0
WireConnection;36;1;35;0
WireConnection;36;2;13;0
WireConnection;38;0;13;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;18;0;7;0
WireConnection;18;1;34;0
WireConnection;18;2;13;0
WireConnection;10;2;2;0
WireConnection;17;0;16;0
WireConnection;17;1;14;0
WireConnection;37;0;18;0
WireConnection;37;1;36;0
WireConnection;37;2;38;0
WireConnection;1;1;10;0
WireConnection;20;0;37;0
WireConnection;20;1;17;0
WireConnection;22;0;1;0
WireConnection;22;1;14;0
WireConnection;21;0;20;0
WireConnection;21;1;9;0
WireConnection;24;0;22;0
WireConnection;24;1;21;0
WireConnection;27;0;24;0
WireConnection;27;1;1;0
WireConnection;0;0;27;0
ASEEND*/
//CHKSM=C5C890F8662B32868240A16CC27A1F6C0B7EF64A