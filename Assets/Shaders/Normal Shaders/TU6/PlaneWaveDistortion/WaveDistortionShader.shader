// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaveDistortionShader"
{
	Properties
	{
		_Velocity("Velocity", Range( 0 , 10)) = 1
		_Frequency("Frequency", Range( 0 , 10)) = 1
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
			float mulTime17 = _Time.y * _Velocity;
			float temp_output_16_0 = sin( ( ( distance( appendResult14 , float2( 0,0 ) ) * _Frequency ) + mulTime17 ) );
			float4 appendResult24 = (float4(0.0 , ( temp_output_16_0 * _HeightMagnitude ) , 0.0 , 0.0));
			v.vertex.xyz += appendResult24.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult14 = (float2(ase_worldPos.x , ase_worldPos.z));
			float mulTime17 = _Time.y * _Velocity;
			float temp_output_16_0 = sin( ( ( distance( appendResult14 , float2( 0,0 ) ) * _Frequency ) + mulTime17 ) );
			float3 temp_cast_0 = (temp_output_16_0).xxx;
			o.Albedo = temp_cast_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
694;73;898;565;1106.287;413.9563;1.775201;False;False
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1311.039,-139.1159;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1118.924,-105.4459;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1121.866,0.2413774;Inherit;False;Property;_Frequency;Frequency;1;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;3;-983.5665,-105.3762;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1131.392,103.8796;Inherit;False;Property;_Velocity;Velocity;0;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-816.8671,-87.75869;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;17;-853.4159,108.6046;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-631.6112,-0.7865231;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-587.0984,331.4898;Inherit;False;Property;_HeightMagnitude;Height Magnitude;2;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;16;-491.5799,-3.632353;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-292.8175,312.9806;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-160.0687,288.0849;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;WaveDistortionShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;0;1;1
WireConnection;14;1;1;3
WireConnection;3;0;14;0
WireConnection;18;0;3;0
WireConnection;18;1;19;0
WireConnection;17;0;21;0
WireConnection;20;0;18;0
WireConnection;20;1;17;0
WireConnection;16;0;20;0
WireConnection;22;0;16;0
WireConnection;22;1;23;0
WireConnection;24;1;22;0
WireConnection;0;0;16;0
WireConnection;0;11;24;0
ASEEND*/
//CHKSM=B901DCB0E3F9C2911FE54EC8ABD51E70A657F977