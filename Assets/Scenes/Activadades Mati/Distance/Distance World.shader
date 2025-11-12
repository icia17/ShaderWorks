// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distance World"
{
	Properties
	{
		_difuser("difuser", Vector) = (0,0,0,0)
		_color1("color1", Color) = (0.945098,0,0.1444872,0)
		_Color2("Color 2", Color) = (0,0.3913655,0.9849057,0)
		_frequency3("frequency", Range( 0 , 10)) = 0
		_epicenter("epicenter", Vector) = (0,0,0,0)
		_height("height", Range( 0 , 4)) = 0
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
		uniform float _frequency3;
		uniform float3 _difuser;
		uniform float _height;
		uniform float4 _color1;
		uniform float4 _Color2;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_9_0 = sin( ( ( distance( ase_worldPos , _epicenter ) + _Time.y ) * _frequency3 ) );
			v.vertex.xyz += ( temp_output_9_0 * _difuser * _height );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float temp_output_9_0 = sin( ( ( distance( ase_worldPos , _epicenter ) + _Time.y ) * _frequency3 ) );
			float4 lerpResult15 = lerp( _color1 , _Color2 , (0.0 + (temp_output_9_0 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)));
			o.Albedo = lerpResult15.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
686.4;73.6;530;447;1628.586;1297.266;4.98271;False;False
Node;AmplifyShaderEditor.CommentaryNode;1;-549.9814,-115.1888;Inherit;False;522.6196;283.7019;generacion de ondas;5;9;8;7;6;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;2;-1050.291,-81.14337;Inherit;False;Property;_epicenter;epicenter;4;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,2.79;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;3;-1068.656,-248.1087;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;4;-519.8055,51.57123;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;5;-819.7654,-145.411;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-322.5721,49.35312;Inherit;False;Property;_frequency3;frequency;3;0;Create;False;0;0;0;False;0;False;0;2.26;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-442.0402,-63.68326;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-310.7339,-64.75848;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;9;-178.2422,-65.18878;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;11;29.28534,211.4293;Inherit;False;Property;_difuser;difuser;0;0;Create;True;0;0;0;False;0;False;0,0,0;0,0.72,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;12;111.1271,-228.1817;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;31.94525,379.1375;Inherit;False;Property;_height;height;5;0;Create;True;0;0;0;False;0;False;0;0.83;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-260.131,-439.414;Inherit;False;Property;_Color2;Color 2;2;0;Create;True;0;0;0;False;0;False;0,0.3913655,0.9849057,0;0.2817369,0.02563189,0.6037736,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;10;-218.5067,-663.9988;Inherit;False;Property;_color1;color1;1;0;Create;True;0;0;0;False;0;False;0.945098,0,0.1444872,0;0.9433962,0.2457741,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;226.2466,192.9851;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;15;227.9313,-388.7385;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;559.6671,-344.1425;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Distance World;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;0
WireConnection;5;1;2;0
WireConnection;7;0;5;0
WireConnection;7;1;4;0
WireConnection;8;0;7;0
WireConnection;8;1;6;0
WireConnection;9;0;8;0
WireConnection;12;0;9;0
WireConnection;14;0;9;0
WireConnection;14;1;11;0
WireConnection;14;2;13;0
WireConnection;15;0;10;0
WireConnection;15;1;16;0
WireConnection;15;2;12;0
WireConnection;0;0;15;0
WireConnection;0;11;14;0
ASEEND*/
//CHKSM=C28C100E97A0B93980B5FE6B49AF8CB250F833AC