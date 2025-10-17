// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BloomFilmShader"
{
	Properties
	{
		_CameraInputTexture2("Camera Input Texture", 2D) = "white" {}
		_MaxWeights("Max Weights", Float) = 0.3
		_NoiseOscillationFrequency("Noise Oscillation Frequency", Range( 0 , 10)) = 1
		_NoiseSpeed("Noise Speed", Range( 0 , 10)) = 1
		_NoiseScale("Noise Scale", Range( 0 , 100)) = 35
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _NoiseOscillationFrequency;
		uniform float _MaxWeights;
		uniform sampler2D _CameraInputTexture2;
		uniform float4 _CameraInputTexture2_ST;
		uniform float _NoiseSpeed;
		uniform float _NoiseScale;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime17 = _Time.y * _NoiseOscillationFrequency;
			float2 uv_CameraInputTexture2 = i.uv_texcoord * _CameraInputTexture2_ST.xy + _CameraInputTexture2_ST.zw;
			float mulTime13 = _Time.y * _NoiseSpeed;
			float2 temp_cast_0 = (mulTime13).xx;
			float dotResult4_g1 = dot( temp_cast_0 , float2( 12.9898,78.233 ) );
			float lerpResult10_g1 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g1 ) * 43758.55 ) ));
			float2 temp_cast_1 = (lerpResult10_g1).xx;
			float2 uv_TexCoord11 = i.uv_texcoord + temp_cast_1;
			float simplePerlin2D10 = snoise( uv_TexCoord11*_NoiseScale );
			simplePerlin2D10 = simplePerlin2D10*0.5 + 0.5;
			float4 temp_cast_2 = (simplePerlin2D10).xxxx;
			float layeredBlendVar12 = (0.0 + (saturate( sin( mulTime17 ) ) - 0.0) * (_MaxWeights - 0.0) / (1.0 - 0.0));
			float4 layeredBlend12 = ( lerp( tex2D( _CameraInputTexture2, uv_CameraInputTexture2 ),temp_cast_2 , layeredBlendVar12 ) );
			o.Albedo = layeredBlend12.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
818;73;774;565;963.7677;334.1379;1.454019;True;False
Node;AmplifyShaderEditor.RangedFloatNode;20;-1187.29,-170.0064;Inherit;False;Property;_NoiseOscillationFrequency;Noise Oscillation Frequency;2;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1401.931,318.3389;Inherit;False;Property;_NoiseSpeed;Noise Speed;3;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;17;-917.253,-164.4411;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;13;-1123.937,318.455;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;15;-756.7259,-164.3665;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;14;-913.184,304.5473;Inherit;False;Random Range;-1;;1;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-836.2164,19.28491;Inherit;True;Property;_CameraInputTexture2;Camera Input Texture;0;0;Create;True;0;0;0;False;0;False;ee31f1c5bce789b40a1c6119651c1416;ee31f1c5bce789b40a1c6119651c1416;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;19;-657.6118,-73.63789;Inherit;False;Property;_MaxWeights;Max Weights;1;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;21;-636.9259,-163.7868;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-720.5803,227.9326;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-785.1305,436.7389;Inherit;False;Property;_NoiseScale;Noise Scale;4;0;Create;True;0;0;0;False;0;False;35;35;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-582.3228,19.25981;Inherit;True;Property;_TextureSample2;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;18;-470.4844,-162.1711;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;10;-480.0803,222.7325;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.LayeredBlendNode;12;-210.2959,2.226482;Inherit;False;6;0;FLOAT;0.3;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;8;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;BloomFilmShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;20;0
WireConnection;13;0;23;0
WireConnection;15;0;17;0
WireConnection;14;1;13;0
WireConnection;21;0;15;0
WireConnection;11;1;14;0
WireConnection;5;0;3;0
WireConnection;18;0;21;0
WireConnection;18;4;19;0
WireConnection;10;0;11;0
WireConnection;10;1;22;0
WireConnection;12;0;18;0
WireConnection;12;1;5;0
WireConnection;12;2;10;0
WireConnection;8;0;12;0
ASEEND*/
//CHKSM=49B4199A9DE1D5000DF0AFB367C982EF2F05E7D9