// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UV"
{
	Properties
	{
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_Color1("Color 1 ", Color) = (0,0.5671964,1,0)
		_Sombra1("Sombra1", Float) = -0.5
		_Sombra2("Sombra2", Float) = -0.5
		_Color2("Color 2", Color) = (0,0.5671964,1,0)
		_Color3("Color3", Color) = (0,0.5671964,1,0)
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

		uniform float4 _Color1;
		uniform sampler2D _TextureSample0;
		uniform float4 _Color2;
		uniform sampler2D _TextureSample1;
		uniform float _Sombra1;
		uniform sampler2D _TextureSample2;
		uniform float4 _Color3;
		uniform float _Sombra2;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 lerpResult11 = lerp( _Color1 , ( tex2D( _TextureSample0, (ase_screenPosNorm).xyzw.xy ) * _Color2 ) , ceil( saturate( ( tex2D( _TextureSample1, (ase_screenPosNorm).xyzw.xy ) + _Sombra1 ) ) ));
			float4 lerpResult21 = lerp( lerpResult11 , float4( 0,0,0,0 ) , ceil( saturate( ( ( tex2D( _TextureSample2, (ase_screenPosNorm).xyzw.xy ) * _Color3 ) + _Sombra2 ) ) ));
			o.Albedo = lerpResult21.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
571.2;73.6;565.9999;459;2462.001;1255.345;6.881183;False;False
Node;AmplifyShaderEditor.CommentaryNode;27;-1579.172,369.6952;Inherit;False;606.7843;262;UV Fun;2;26;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;26;-1529.172,419.6948;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;32;-1142.687,827.833;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;30;-1174.184,-72.34653;Inherit;False;606.7846;262;Comment;2;28;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;25;-1195.387,508.9385;Inherit;False;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;31;-808.902,917.0767;Inherit;False;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;28;-1124.184,-22.34652;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-924.5458,241.6634;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;16d574e53541bba44a84052fa38778df;e7715ad31a5979f4dbf93e80ca3a92df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;24;-415.2109,427.0288;Inherit;False;Property;_Color3;Color3;7;0;Create;True;0;0;0;False;0;False;0,0.5671964,1,0;0,0.5671963,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-797.6832,532.049;Inherit;False;Property;_Sombra1;Sombra1;4;0;Create;True;0;0;0;False;0;False;-0.5;-0.94;-2;-2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;15;-522.2143,649.7333;Inherit;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;0;False;0;False;-1;0bebe40e9ebbecc48b8e9cfea982da7e;0ad200a494caf0f43a31858677a3fd81;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-154.113,557.3916;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-394.9856,912.7266;Inherit;False;Property;_Sombra2;Sombra2;5;0;Create;True;0;0;0;False;0;False;-0.5;0;-2;-2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;29;-790.3994,66.89842;Inherit;False;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-590.5586,329.6697;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;24.165,510.9463;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;14;-491.0027,-226.2721;Inherit;False;Property;_Color2;Color 2;6;0;Create;True;0;0;0;False;0;False;0,0.5671964,1,0;0.8111136,0.1647058,0.9333333,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;8;-390.1089,332.292;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;10;-484.1896,13.96085;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;0bebe40e9ebbecc48b8e9cfea982da7e;1cd2deb5f024fd64c937d77c80f5a3f4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;17;311.201,638.8621;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;12;-64.24953,-433.8995;Inherit;False;Property;_Color1;Color 1 ;3;0;Create;True;0;0;0;False;0;False;0,0.5671964,1,0;0.1012371,0.2768046,0.8584906,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-141.5901,-45.69485;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CeilOpNode;9;-234.8259,296.4517;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;11;536.6034,56.68924;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CeilOpNode;18;476.9305,462.9245;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;21;783.7953,48.90387;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1044.728,59.76097;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;UV;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;26;0
WireConnection;31;0;32;0
WireConnection;5;1;25;0
WireConnection;15;1;31;0
WireConnection;23;0;15;0
WireConnection;23;1;24;0
WireConnection;29;0;28;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;16;0;23;0
WireConnection;16;1;19;0
WireConnection;8;0;7;0
WireConnection;10;1;29;0
WireConnection;17;0;16;0
WireConnection;13;0;10;0
WireConnection;13;1;14;0
WireConnection;9;0;8;0
WireConnection;11;0;12;0
WireConnection;11;1;13;0
WireConnection;11;2;9;0
WireConnection;18;0;17;0
WireConnection;21;0;11;0
WireConnection;21;2;18;0
WireConnection;0;0;21;0
ASEEND*/
//CHKSM=68A3763DCFA5867C586133FBF9F32B9F9917BFAF