// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaveDistortionShader"
{
	Properties
	{
		_Velocity("Velocity", Range( 0 , 10)) = 1
		_Frequency("Frequency", Range( 0 , 50)) = 1
		_HeightMagnitude("Height Magnitude", Range( 0 , 10)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _Frequency;
		uniform float _Velocity;
		uniform float _HeightMagnitude;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult14 = (float2(ase_worldPos.x , ase_worldPos.z));
			float mulTime7 = _Time.y * _Velocity;
			float temp_output_11_0 = ( sin( ( ( distance( appendResult14 , float2( 0,0 ) ) * _Frequency ) + mulTime7 ) ) * _HeightMagnitude );
			float4 appendResult12 = (float4(0.0 , temp_output_11_0 , 0.0 , 0.0));
			v.vertex.xyz += appendResult12.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color16 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float3 ase_worldPos = i.worldPos;
			float2 appendResult14 = (float2(ase_worldPos.x , ase_worldPos.z));
			float mulTime7 = _Time.y * _Velocity;
			float temp_output_11_0 = ( sin( ( ( distance( appendResult14 , float2( 0,0 ) ) * _Frequency ) + mulTime7 ) ) * _HeightMagnitude );
			o.Albedo = ( color16 * temp_output_11_0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
585;74;1328;978;2414.239;1130.989;2.157011;False;False
Node;AmplifyShaderEditor.WorldPosInputsNode;13;-1397.382,-110.1056;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1201.67,-75.44828;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;4;-1044.077,-75.08438;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1192.776,30.53569;Inherit;False;Property;_Frequency;Frequency;1;0;Create;True;0;0;0;False;0;False;1;5;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1191.902,134.1715;Inherit;False;Property;_Velocity;Velocity;0;0;Create;True;0;0;0;False;0;False;1;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-877.377,-57.46679;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;7;-913.9258,138.8965;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-692.1211,29.50538;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;10;-552.0895,26.65954;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-647.6082,361.782;Inherit;False;Property;_HeightMagnitude;Height Magnitude;2;0;Create;True;0;0;0;False;0;False;1;5.24;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-353.3274,343.2728;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-433.5793,-122.8884;Inherit;False;Constant;_White;White;3;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;12;-220.5786,318.377;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-197.4452,52.90524;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;WaveDistortionShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;0;13;1
WireConnection;14;1;13;3
WireConnection;4;0;14;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;7;0;3;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;10;0;8;0
WireConnection;11;0;10;0
WireConnection;11;1;9;0
WireConnection;12;1;11;0
WireConnection;15;0;16;0
WireConnection;15;1;11;0
WireConnection;0;0;15;0
WireConnection;0;11;12;0
ASEEND*/
//CHKSM=2C7A23594FE4BAA1C40F87BF4E770AF0292925A1