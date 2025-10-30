// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BurnDissolveUIShader"
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
		_GlintedTex("Glinted Tex", 2D) = "white" {}
		_DissolveSpeed("Dissolve Speed", Float) = 0.25
		_RedPhase("Red Phase", Range( 0 , 0.999)) = 0
		_CharcoalPhase("Charcoal Phase", Range( 0 , 0.999)) = 0.3
		_VanishPhase("Vanish Phase", Range( 0 , 0.999)) = 0.6
		_EndPhase("End Phase", Range( 0 , 1)) = 0.35
		_TimeBeforeBurn("Time Before Burn", Float) = 1
		_RedPhaseColor("Red Phase Color", Color) = (1,0,0,1)
		_CharcoalPhaseColor("Charcoal Phase Color", Color) = (0,0,0,1)
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
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform sampler2D _GlintedTex;
			uniform float4 _GlintedTex_ST;
			uniform float4 _RedPhaseColor;
			uniform float _RedPhase;
			uniform float _TimeBeforeBurn;
			uniform float _DissolveSpeed;
			uniform float _CharcoalPhase;
			uniform float4 _CharcoalPhaseColor;
			uniform float _VanishPhase;
			uniform float _EndPhase;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			

			
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

				float2 uv_GlintedTex = IN.texcoord.xy * _GlintedTex_ST.xy + _GlintedTex_ST.zw;
				float4 tex2DNode4 = tex2D( _GlintedTex, uv_GlintedTex );
				float2 texCoord2 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float simplePerlin2D1 = snoise( texCoord2*2.5 );
				simplePerlin2D1 = simplePerlin2D1*0.5 + 0.5;
				float mulTime17 = _Time.y * _DissolveSpeed;
				float temp_output_24_0 = ( 1.0 - saturate( ( ( simplePerlin2D1 + _TimeBeforeBurn ) - mulTime17 ) ) );
				float4 lerpResult73 = lerp( tex2DNode4 , _RedPhaseColor , (0.0 + (( step( _RedPhase , temp_output_24_0 ) * temp_output_24_0 ) - 0.0) * (1.0 - 0.0) / (_CharcoalPhase - 0.0)));
				float temp_output_56_0 = step( _CharcoalPhase , temp_output_24_0 );
				float4 lerpResult74 = lerp( lerpResult73 , _CharcoalPhaseColor , ( temp_output_56_0 * (0.0 + (( temp_output_56_0 * temp_output_24_0 ) - 0.0) * (1.0 - 0.0) / (_VanishPhase - 0.0)) ));
				float temp_output_50_0 = step( _VanishPhase , temp_output_24_0 );
				float clampResult79 = clamp( ( temp_output_24_0 * temp_output_50_0 ) , _VanishPhase , _EndPhase );
				float4 lerpResult75 = lerp( lerpResult74 , float4( 0,0,0,0 ) , ( (0.0 + (clampResult79 - _VanishPhase) * (1.0 - 0.0) / (_EndPhase - _VanishPhase)) * temp_output_50_0 ));
				
				half4 color = ( saturate( ( tex2DNode4 * 255.0 ) ) * saturate( lerpResult75 ) );
				
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
216;73;1427;570;486.0963;-334.3207;1.00466;False;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1549.385,274.5684;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;49;-1337.552,398.3887;Inherit;False;Property;_TimeBeforeBurn;Time Before Burn;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1325.968,495.8832;Inherit;False;Property;_DissolveSpeed;Dissolve Speed;1;0;Create;True;0;0;0;False;0;False;0.25;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;1;-1327.554,268.4505;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;10,100;False;1;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;17;-1136.284,500.2431;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1076.495,367.7281;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;6;-943.249,371.4792;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;20;-802.3149,370.7722;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-76.9155,279.0807;Inherit;False;Property;_CharcoalPhase;Charcoal Phase;3;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0.999;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-492.7724,63.9483;Inherit;False;Property;_RedPhase;Red Phase;2;0;Create;True;0;0;0;False;0;False;0;0.15;0;0.999;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-363.587,700.4479;Inherit;False;Property;_VanishPhase;Vanish Phase;4;0;Create;True;0;0;0;False;0;False;0.6;0.5;0;0.999;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;24;-664.941,370.2045;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;50;-39.86061,584.6063;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;56;302.0802,282.8454;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;22;-170.0774,83.0423;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;107.7359,505.6049;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;8.662704,83.5874;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-58.44201,777.6268;Inherit;False;Property;_EndPhase;End Phase;5;0;Create;True;0;0;0;False;0;False;0.35;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;458.3016,388.7528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-509.6096,-297.4403;Inherit;True;Property;_GlintedTex;Glinted Tex;0;0;Create;True;0;0;0;False;0;False;55b1b7c646982a049b43cadc6fe191fa;55b1b7c646982a049b43cadc6fe191fa;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;76;527.7793,151.1559;Inherit;False;Property;_RedPhaseColor;Red Phase Color;7;0;Create;True;0;0;0;False;0;False;1,0,0,1;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;79;272.518,627.8961;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-217.9528,-298.9498;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;60;621.4496,442.7603;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;59;263.1938,83.82063;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;77;864.1342,216.1097;Inherit;False;Property;_CharcoalPhaseColor;Charcoal Phase Color;8;0;Create;True;0;0;0;False;0;False;0,0,0,1;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;61;431.0044,690.2308;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;73;775.6492,37.88557;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;952.6526,393.7456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;665.5699,612.0014;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;74;1144.836,178.2896;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;38;1295.103,-206.2337;Inherit;False;Constant;_PurestWhite;Purest White;2;0;Create;True;0;0;0;False;0;False;255;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;75;1364.409,432.7296;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;1462.844,-276.8917;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;58;1534.22,434.5131;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;39;1628.863,-274.8395;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;1806.292,-274.1016;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1975.259,-275.1326;Float;False;True;-1;2;ASEMaterialInspector;0;4;BurnDissolveUIShader;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;1;0;2;0
WireConnection;17;0;18;0
WireConnection;21;0;1;0
WireConnection;21;1;49;0
WireConnection;6;0;21;0
WireConnection;6;1;17;0
WireConnection;20;0;6;0
WireConnection;24;0;20;0
WireConnection;50;0;46;0
WireConnection;50;1;24;0
WireConnection;56;0;55;0
WireConnection;56;1;24;0
WireConnection;22;0;40;0
WireConnection;22;1;24;0
WireConnection;53;0;24;0
WireConnection;53;1;50;0
WireConnection;52;0;22;0
WireConnection;52;1;24;0
WireConnection;57;0;56;0
WireConnection;57;1;24;0
WireConnection;79;0;53;0
WireConnection;79;1;46;0
WireConnection;79;2;78;0
WireConnection;4;0;3;0
WireConnection;60;0;57;0
WireConnection;60;2;46;0
WireConnection;59;0;52;0
WireConnection;59;2;55;0
WireConnection;61;0;79;0
WireConnection;61;1;46;0
WireConnection;61;2;78;0
WireConnection;73;0;4;0
WireConnection;73;1;76;0
WireConnection;73;2;59;0
WireConnection;64;0;56;0
WireConnection;64;1;60;0
WireConnection;63;0;61;0
WireConnection;63;1;50;0
WireConnection;74;0;73;0
WireConnection;74;1;77;0
WireConnection;74;2;64;0
WireConnection;75;0;74;0
WireConnection;75;2;63;0
WireConnection;35;0;4;0
WireConnection;35;1;38;0
WireConnection;58;0;75;0
WireConnection;39;0;35;0
WireConnection;37;0;39;0
WireConnection;37;1;58;0
WireConnection;0;0;37;0
ASEEND*/
//CHKSM=06580164F8B15FF9BF87313EEB24FBF7C60D23CB