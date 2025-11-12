// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DistanceVertex"
{
	Properties
	{
		_difuser("difuser", Vector) = (0,0,0,0)
		_Color0("Color 0", Color) = (0.9433962,0.2457742,0,0)
		_frequency8("frequency", Range( 0 , 10)) = 10
		_epicenter("epicenter", Vector) = (0,0,0,0)
		_height("height", Range( 0 , 4)) = 0
		_Color11("Color 2", Color) = (0,0,0,0)
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

		uniform float3 _epicenter;
		uniform float _frequency8;
		uniform float3 _difuser;
		uniform float _height;
		uniform float4 _Color0;
		uniform float4 _Color11;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_25_0 = sin( ( ( distance( ase_vertex3Pos , _epicenter ) + _Time.y ) * _frequency8 ) );
			v.vertex.xyz += ( temp_output_25_0 * _difuser * _height );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_25_0 = sin( ( ( distance( ase_vertex3Pos , _epicenter ) + _Time.y ) * _frequency8 ) );
			float4 lerpResult31 = lerp( _Color0 , _Color11 , (0.0 + (temp_output_25_0 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)));
			o.Albedo = lerpResult31.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
686.4;73.6;530;447;1080.255;741.2248;1.500278;False;False
Node;AmplifyShaderEditor.PosVertexDataNode;33;-1737.729,-182.3197;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;18;-1711.906,-0.1313629;Inherit;False;Property;_epicenter;epicenter;4;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,2.79;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;20;-1181.421,132.5832;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;21;-1481.381,-64.39896;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-984.1879,130.3651;Inherit;False;Property;_frequency8;frequency;3;0;Create;False;0;0;0;False;0;False;10;2.26;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-1103.656,17.32875;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-972.3497,16.25352;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;25;-839.858,15.82323;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-629.6705,460.1495;Inherit;False;Property;_height;height;5;0;Create;True;0;0;0;False;0;False;0;0.83;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;27;-632.3304,292.4413;Inherit;False;Property;_difuser;difuser;0;0;Create;True;0;0;0;False;0;False;0,0,0;0,0.72,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;28;-550.4886,-147.1697;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;-880.1224,-582.9868;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0.9433962,0.2457742,0,0;0.9433962,0.2457741,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;34;-901.8054,-342.6459;Inherit;False;Property;_Color11;Color 2;5;0;Create;False;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-435.3691,273.9971;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;31;-433.6844,-307.7265;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;DistanceVertex;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;33;0
WireConnection;21;1;18;0
WireConnection;23;0;21;0
WireConnection;23;1;20;0
WireConnection;24;0;23;0
WireConnection;24;1;22;0
WireConnection;25;0;24;0
WireConnection;28;0;25;0
WireConnection;30;0;25;0
WireConnection;30;1;27;0
WireConnection;30;2;29;0
WireConnection;31;0;26;0
WireConnection;31;1;34;0
WireConnection;31;2;28;0
WireConnection;0;0;31;0
WireConnection;0;11;30;0
ASEEND*/
//CHKSM=D6A87B81F7BC5A1674990E0E68FED1E7ABC05F13