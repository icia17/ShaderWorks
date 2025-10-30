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
		_Texture1("Texture 1", 2D) = "white" {}
		_Float4("Float 4", Float) = 1
		_Float2("Float 2", Range( 0 , 1.2)) = 1

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
			uniform sampler2D _Texture1;
			uniform float _Float2;
			UNITY_INSTANCING_BUFFER_START(BurnPosition)
				UNITY_DEFINE_INSTANCED_PROP(float, _Float4)
#define _Float4_arr BurnPosition
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

				float2 texCoord10 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord12 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_40_0 = tex2D( _Texture1, texCoord12 ).r;
				float4 color53 = IsGammaSpace() ? float4(0.8679245,0.3417684,0.004093993,0) : float4(0.7254258,0.09564961,0.0003168726,0);
				float _Float4_Instance = UNITY_ACCESS_INSTANCED_PROP(_Float4_arr, _Float4);
				
				half4 color = ( ( float4( 0,0,0,0 ) + ( tex2D( _Basetexture, texCoord10 ) * step( ( temp_output_40_0 - ( 1.0 - saturate( ( _Time.y * 0.2 ) ) ) ) , 0.0 ) ) ) + ( ( color53 * step( ( ( _Float2 + temp_output_40_0 ) - 0.0 ) , 0.0 ) ) * _Float4_Instance ) );
				
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
699;73;780;661;2509.762;236.9654;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;46;-2541.818,-151.9605;Inherit;False;1787.274;427.103;Mascara principal ;10;44;43;45;40;3;4;12;60;62;64;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;60;-1932.194,267.0107;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-2444.818,-85.18797;Inherit;True;Property;_Texture1;Texture 1;1;0;Create;True;0;0;0;False;0;False;bdbe94d7623ec3940947b62544306f1c;12c89afe141ffb44db0961b50bfb0d10;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-2245.156,116.1426;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;61;-1922.194,387.8731;Inherit;False;Constant;_TimeVel;TimeVel;10;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1992.849,-98.3401;Inherit;True;Property;_NoiseTexture;Noise Texture;1;0;Create;True;0;0;0;False;0;False;-1;bdbe94d7623ec3940947b62544306f1c;bdbe94d7623ec3940947b62544306f1c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-1719.219,291.7277;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1438.127,-470.489;Inherit;False;Property;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;1;1;0;1.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;62;-1539.123,136.2642;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;40;-1554.675,-101.9605;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-1019.642,-540.3314;Inherit;False;2;2;0;FLOAT;0.05;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;64;-1420.594,82.59079;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-1248.442,-77.72939;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-511.5887,162.7804;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-792.1551,-531.8133;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1073.644,71.71741;Inherit;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;53;-527.6213,-794.9773;Inherit;False;Constant;_Edgeproperty;Edge property;10;0;Create;True;0;0;0;False;0;False;0.8679245,0.3417684,0.004093993,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;50;-591.6835,-523.564;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;44;-906.5439,-77.94177;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-346.6843,-34.93101;Inherit;True;Property;_Basetexture;Base texture ;0;0;Create;True;0;0;0;False;0;False;-1;05c8444f2486e5a43ba3438f935d2b38;dc095ce8d2086f541bd26c7e3a71ef12;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;-16.14223,-475.6346;Inherit;False;InstancedProperty;_Float4;Float 4;3;0;Create;True;0;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-194.5995,-612.6775;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-147.9131,-174.0015;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;26;-827.592,808.0132;Inherit;False;1344.187;352.2484;Dissolve Mask;8;6;5;15;16;17;9;20;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;76.31712,-247.5659;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;123.7371,-612.0671;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1548.398,1030.586;Inherit;False;Property;_BurnPosition;Burn Position;8;0;Create;True;0;0;0;False;0;False;0.5;1.36;-1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-535.5142,919.6161;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-777.5927,911.2938;Inherit;False;Property;_DissolveAmount;Dissolve Amount;4;0;Create;True;0;0;0;False;0;False;1;10.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-1202.27,758.7098;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-734.8361,1042.475;Inherit;False;Property;_EdgeWidth;Edge Width;6;0;Create;True;0;0;0;False;0;False;1;21.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1433.375,754.4788;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;355.1428,-309.9042;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;30;-1715.513,755.953;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;28;-1872.328,966.4629;Inherit;False;Property;_Burndirection;Burn direction;7;0;Create;True;0;0;0;False;0;False;0,-1;-57.89117,-92.8;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-2124.468,748.8266;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;16;-325.7958,916.6831;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;14;-514.9418,698.6798;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;349.055,866.7419;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;182.6884,858.013;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;78.8647,1046.101;Inherit;False;InstancedProperty;_EdgeIntensity;Edge Intensity ;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;17;-124.5547,881.8682;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;828.0249,-315.1901;Float;False;True;-1;2;ASEMaterialInspector;0;4;Burn Position;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;3;0;4;0
WireConnection;3;1;12;0
WireConnection;63;0;60;0
WireConnection;63;1;61;0
WireConnection;62;0;63;0
WireConnection;40;0;3;1
WireConnection;47;0;48;0
WireConnection;47;1;40;0
WireConnection;64;0;62;0
WireConnection;43;0;40;0
WireConnection;43;1;64;0
WireConnection;49;0;47;0
WireConnection;50;0;49;0
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;1;1;10;0
WireConnection;54;0;53;0
WireConnection;54;1;50;0
WireConnection;57;0;1;0
WireConnection;57;1;44;0
WireConnection;58;1;57;0
WireConnection;55;0;54;0
WireConnection;55;1;56;0
WireConnection;15;0;5;0
WireConnection;15;1;6;0
WireConnection;33;0;32;0
WireConnection;32;0;30;0
WireConnection;32;1;29;0
WireConnection;59;0;58;0
WireConnection;59;1;55;0
WireConnection;30;0;31;0
WireConnection;30;1;28;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;14;0;33;0
WireConnection;14;1;5;0
WireConnection;21;0;20;0
WireConnection;21;1;9;0
WireConnection;20;1;17;0
WireConnection;17;0;16;0
WireConnection;17;1;14;0
WireConnection;0;0;59;0
ASEEND*/
//CHKSM=6019989F03E3800E2A7026075F54F6FD5B5AE3D4