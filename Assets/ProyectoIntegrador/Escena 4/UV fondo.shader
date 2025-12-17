// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UV fondo"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_Color2("Color 2", Color) = (0,0.5671964,1,0)
		_Sombra1("Sombra1", Float) = -0.5
		_Sombra2("Sombra2", Float) = -0.5
		_Color1("Color 1", Color) = (0,0.5671964,1,0)
		_Color0("Color 0", Color) = (0,0.5671964,1,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
		};

		uniform float4 _Color2;
		uniform sampler2D _TextureSample1;
		uniform float4 _Color1;
		uniform sampler2D _TextureSample0;
		uniform float _Sombra1;
		uniform sampler2D _TextureSample2;
		uniform float4 _Color0;
		uniform float _Sombra2;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 lerpResult23 = lerp( _Color2 , ( tex2D( _TextureSample1, (ase_screenPosNorm).xyzw.xy ) * _Color1 ) , ceil( saturate( ( tex2D( _TextureSample0, (ase_screenPosNorm).xyzw.xy ) + _Sombra1 ) ) ));
			float4 lerpResult25 = lerp( lerpResult23 , float4( 0,0,0,0 ) , ceil( saturate( ( ( tex2D( _TextureSample2, (ase_screenPosNorm).xyzw.xy ) * _Color0 ) + _Sombra2 ) ) ));
			o.Albedo = lerpResult25.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
661.6;73.6;482.8;470.2;564.0444;1234.409;5.400327;False;False
Node;AmplifyShaderEditor.CommentaryNode;1;-1410.363,135.7905;Inherit;False;606.7843;262;UV Fun;2;4;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-973.8779,593.9283;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;26;-1342.465,200.9837;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;3;-1005.375,-306.2512;Inherit;False;606.7846;262;Comment;2;11;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;4;-1026.578,275.0338;Inherit;False;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;5;-640.0928,683.172;Inherit;False;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;6;-955.3748,-256.2512;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-755.7366,7.758713;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;16d574e53541bba44a84052fa38778df;e7715ad31a5979f4dbf93e80ca3a92df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;8;-246.4018,193.1241;Inherit;False;Property;_Color0;Color 0;7;0;Create;True;0;0;0;False;0;False;0,0.5671964,1,0;0,0.5671963,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-628.8741,298.1443;Inherit;False;Property;_Sombra1;Sombra1;4;0;Create;True;0;0;0;False;0;False;-0.5;-0.94;-2;-2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-353.4052,415.8286;Inherit;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;0;False;0;False;-1;0bebe40e9ebbecc48b8e9cfea982da7e;0ad200a494caf0f43a31858677a3fd81;True;0;True;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-226.1765,678.8219;Inherit;False;Property;_Sombra2;Sombra2;5;0;Create;True;0;0;0;False;0;False;-0.5;0;-2;-2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;14.69614,323.4869;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-421.7495,95.76501;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;11;-621.5903,-167.0063;Inherit;False;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;192.9742,277.0416;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;16;-322.1935,-460.1768;Inherit;False;Property;_Color1;Color 1;6;0;Create;True;0;0;0;False;0;False;0,0.5671964,1,0;0.8111136,0.1647058,0.9333333,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;17;-221.2997,98.3873;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;18;-315.3805,-219.9438;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;0bebe40e9ebbecc48b8e9cfea982da7e;1cd2deb5f024fd64c937d77c80f5a3f4;True;0;True;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;19;480.0101,404.9574;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;20;104.5596,-667.8042;Inherit;False;Property;_Color2;Color 2;3;0;Create;True;0;0;0;False;0;False;0,0.5671964,1,0;0.1012371,0.2768046,0.8584906,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;27.21904,-279.5995;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CeilOpNode;22;-66.01675,62.547;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;23;705.4125,-177.2155;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CeilOpNode;24;645.7396,229.0198;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;25;952.6044,-185.0008;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1249.036,-271.6292;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;UV fondo;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;26;0
WireConnection;5;0;2;0
WireConnection;7;1;4;0
WireConnection;10;1;5;0
WireConnection;14;0;10;0
WireConnection;14;1;8;0
WireConnection;12;0;7;0
WireConnection;12;1;9;0
WireConnection;11;0;6;0
WireConnection;15;0;14;0
WireConnection;15;1;13;0
WireConnection;17;0;12;0
WireConnection;18;1;11;0
WireConnection;19;0;15;0
WireConnection;21;0;18;0
WireConnection;21;1;16;0
WireConnection;22;0;17;0
WireConnection;23;0;20;0
WireConnection;23;1;21;0
WireConnection;23;2;22;0
WireConnection;24;0;19;0
WireConnection;25;0;23;0
WireConnection;25;2;24;0
WireConnection;0;0;25;0
ASEEND*/
//CHKSM=AC1121603BEA75BE51909EBF15E02499F0BC1EF7