// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CubeWaveDistortionShader"
{
	Properties
	{
		_Velocity2("Velocity", Range( 0 , 10)) = 1
		_Frequency2("Frequency", Range( 0 , 50)) = 1
		_HeightMagnitude2("Height Magnitude", Range( 0 , 10)) = 1
		_WaveCenter("Wave Center", Vector) = (0,0,0,0)
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
			half filler;
		};

		uniform float2 _WaveCenter;
		uniform float _Frequency2;
		uniform float _Velocity2;
		uniform float _HeightMagnitude2;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 objToWorld14 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float2 appendResult2 = (float2(objToWorld14.x , objToWorld14.z));
			float mulTime7 = _Time.y * _Velocity2;
			float temp_output_10_0 = sin( ( ( distance( appendResult2 , _WaveCenter ) * _Frequency2 ) + mulTime7 ) );
			float4 appendResult12 = (float4(0.0 , ( temp_output_10_0 * _HeightMagnitude2 ) , 0.0 , 0.0));
			v.vertex.xyz += appendResult12.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 objToWorld14 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float2 appendResult2 = (float2(objToWorld14.x , objToWorld14.z));
			float mulTime7 = _Time.y * _Velocity2;
			float temp_output_10_0 = sin( ( ( distance( appendResult2 , _WaveCenter ) * _Frequency2 ) + mulTime7 ) );
			float3 temp_cast_0 = (temp_output_10_0).xxx;
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
248.8;73.6;734.8;463.8;1894.845;457.983;1.21349;False;False
Node;AmplifyShaderEditor.TransformPositionNode;14;-1447.945,-260.9153;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;2;-1219.863,-222.1699;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;13;-1249.342,-121.2814;Inherit;False;Property;_WaveCenter;Wave Center;3;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;3;-1183.695,105.0499;Inherit;False;Property;_Velocity2;Velocity;0;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1184.569,4.011703;Inherit;False;Property;_Frequency2;Frequency;1;0;Create;True;0;0;0;False;0;False;1;1;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;4;-1046.656,-178.1697;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-869.1699,-86.58839;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;7;-905.7187,109.7749;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-683.914,0.3838027;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-639.4011,332.6606;Inherit;False;Property;_HeightMagnitude2;Height Magnitude;2;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;10;-543.8824,-2.462049;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-345.1202,314.1513;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-212.3716,289.2555;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;CubeWaveDistortionShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;14;1
WireConnection;2;1;14;3
WireConnection;4;0;2;0
WireConnection;4;1;13;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;7;0;3;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;10;0;8;0
WireConnection;11;0;10;0
WireConnection;11;1;9;0
WireConnection;12;1;11;0
WireConnection;0;0;10;0
WireConnection;0;11;12;0
ASEEND*/
//CHKSM=CAC86C22138EFDC74854DBD2CB4D9D6E7D773052