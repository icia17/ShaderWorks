// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Bloom Shader"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		_BloomThreshold("BloomThreshold", Float) = 0.6
		_BloomIntensity("BloomIntensity", Float) = 3
		_NoiseScale("NoiseScale", Range( 50 , 100)) = 0
		_NoiseIntensity("NoiseIntensity", Float) = 0.15
		_NoiseFrequency("NoiseFrequency", Float) = 0.7
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture0;
		uniform float _BloomThreshold;
		uniform float _BloomIntensity;
		uniform float _NoiseScale;
		uniform float _NoiseIntensity;
		uniform float _NoiseFrequency;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 tex2DNode1 = tex2D( _Texture0, i.uv_texcoord );
			float luminance2 = Luminance(tex2DNode1.rgb);
			float2 temp_cast_1 = (5.5).xx;
			float2 panner13 = ( 1.0 * _Time.y * temp_cast_1 + ( i.uv_texcoord * _NoiseScale ));
			o.Emission = ( ( ( ( tex2DNode1 * step( luminance2 , _BloomThreshold ) ) * _BloomIntensity ) + saturate( 0.0 ) ) + float4( ( ( panner13 * _NoiseIntensity ) * step( abs( sin( _Time.y ) ) , _NoiseFrequency ) ), 0.0 , 0.0 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
393;81;1039;720;1085.264;376.3693;2.199156;False;False
Node;AmplifyShaderEditor.TexturePropertyNode;6;-1534.937,-80.20238;Inherit;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;0;False;0;False;0ed1e64f09bca254ca9e8b85bf4ceab1;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1450.197,420.0454;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1209.256,-63.01755;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-820.0573,214.3724;Inherit;False;Property;_BloomThreshold;BloomThreshold;1;0;Create;True;0;0;0;False;0;False;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LuminanceNode;2;-894.3059,83.76373;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1489.928,552.0702;Inherit;False;Property;_NoiseScale;NoiseScale;3;0;Create;True;0;0;0;False;0;False;0;50;50;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;19;-782.1979,800.7668;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1017.849,434.0199;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;3;-615.7339,91.49319;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-873.9039,599.3392;Inherit;False;Constant;_speedpaner;speed paner;4;0;Create;True;0;0;0;False;0;False;5.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;21;-538.5658,768.0211;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;13;-833.0754,430.7782;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-443.5068,60.19341;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-648.1549,566.6801;Inherit;False;Property;_NoiseIntensity;NoiseIntensity;4;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-433.7812,908.173;Inherit;False;Property;_NoiseFrequency;NoiseFrequency;5;0;Create;True;0;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-461.8371,247.3925;Inherit;False;Property;_BloomIntensity;BloomIntensity;2;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;22;-401.035,770.6406;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-438.2642,412.308;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;23;-267.4898,668.0043;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;8;-208.6555,262.035;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-224.4884,68.55365;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-146.504,406.352;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-34.853,112.5241;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;257.1396,448.3237;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;130.8693,111.8432;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;455.5235,96.5854;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Bloom Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;0;6;0
WireConnection;1;1;5;0
WireConnection;2;0;1;0
WireConnection;12;0;5;0
WireConnection;12;1;14;0
WireConnection;3;0;2;0
WireConnection;3;1;9;0
WireConnection;21;0;19;0
WireConnection;13;0;12;0
WireConnection;13;2;15;0
WireConnection;4;0;1;0
WireConnection;4;1;3;0
WireConnection;22;0;21;0
WireConnection;16;0;13;0
WireConnection;16;1;17;0
WireConnection;23;0;22;0
WireConnection;23;1;24;0
WireConnection;18;0;4;0
WireConnection;18;1;10;0
WireConnection;25;0;16;0
WireConnection;25;1;23;0
WireConnection;7;0;18;0
WireConnection;7;1;8;0
WireConnection;28;0;7;0
WireConnection;28;1;25;0
WireConnection;0;2;28;0
ASEEND*/
//CHKSM=DC5D7EEB9468810DEB64B2A6D3BFD8B10C1D3B17