// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distance2"
{
	Properties
	{
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.5
		_epicenter("epicenter", Vector) = (0,0,0,0)
		_Frequency("Frequency", Float) = 0
		_timeScale("timeScale", Float) = 1
		_tess("tess", Float) = 0.2
		_Color0("Color 0", Color) = (0,0,0,0)
		_Color1("Color 1", Color) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		struct Input
		{
			float3 worldPos;
		};

		uniform float3 _epicenter;
		uniform float _Frequency;
		uniform float _timeScale;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _tess;
		uniform float _TessPhongStrength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _tess);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float mulTime8 = _Time.y * _timeScale;
			float temp_output_4_0 = sin( ( ( distance( ase_worldPos , _epicenter ) * _Frequency ) + mulTime8 ) );
			v.vertex.xyz += ( temp_output_4_0 * float3(0,1,0) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float mulTime8 = _Time.y * _timeScale;
			float temp_output_4_0 = sin( ( ( distance( ase_worldPos , _epicenter ) * _Frequency ) + mulTime8 ) );
			float4 lerpResult14 = lerp( _Color0 , _Color1 , temp_output_4_0);
			o.Albedo = lerpResult14.rgb;
			o.Emission = lerpResult14.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
869;73;610;649;1429.986;31.50156;1.995922;False;False
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1349.599,381.7683;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;3;-1321.32,535.7325;Inherit;False;Property;_epicenter;epicenter;0;0;Create;True;0;0;0;False;0;False;0,0,0;27,-4,16;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;2;-1104.514,403.7631;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1107.369,817.5654;Inherit;False;Property;_timeScale;timeScale;2;0;Create;True;0;0;0;False;0;False;1;3.89;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1080.486,620.2873;Inherit;False;Property;_Frequency;Frequency;1;0;Create;True;0;0;0;False;0;False;0;3.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;8;-966.0197,768.8947;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-921.8141,504.9901;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-806.6944,615.2863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-265.1829,624.5129;Inherit;False;Property;_tess;tess;3;0;Create;True;0;0;0;False;0;False;0.2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;11;-436.336,397.0265;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;15;-759.5176,-99.61765;Inherit;False;Property;_Color0;Color 0;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.08235291,0.271836,0.8313726,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;16;-772.1624,106.9083;Inherit;False;Property;_Color1;Color 1;5;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.509434,0.509434,0.509434,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;4;-677.7769,734.371;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;14;-453.9432,31.04163;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-276.8264,302.0888;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;12;-179.6825,519.9334;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Distance2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;True;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;8;0;9;0
WireConnection;5;0;2;0
WireConnection;5;1;6;0
WireConnection;7;0;5;0
WireConnection;7;1;8;0
WireConnection;4;0;7;0
WireConnection;14;0;15;0
WireConnection;14;1;16;0
WireConnection;14;2;4;0
WireConnection;10;0;4;0
WireConnection;10;1;11;0
WireConnection;12;0;13;0
WireConnection;0;0;14;0
WireConnection;0;2;14;0
WireConnection;0;11;10;0
WireConnection;0;14;12;0
ASEEND*/
//CHKSM=3E7BA0A1B498AE89EE2DF7EB3006499F8FC4345B