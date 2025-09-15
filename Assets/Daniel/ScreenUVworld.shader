// Upgrade NOTE: upgraded instancing buffer 'UV' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UV"
{
	Properties
	{
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_Color0("Color 0", Color) = (0,0.5671964,1,0)
		_Float0("Float 0", Float) = -0.5
		_La2datextura("La 2da textura", Float) = -0.5
		_Color1("Color 1", Color) = (0,0.5671964,1,0)
		_Color2("Color 2", Color) = (0,0.5671964,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform float4 _Color0;
		uniform sampler2D _TextureSample0;
		uniform float4 _Color1;
		uniform sampler2D _TextureSample1;
		uniform sampler2D _TextureSample2;
		uniform float4 _Color2;

		UNITY_INSTANCING_BUFFER_START(UV)
			UNITY_DEFINE_INSTANCED_PROP(float4, _TextureSample2_ST)
#define _TextureSample2_ST_arr UV
			UNITY_DEFINE_INSTANCED_PROP(float, _Float0)
#define _Float0_arr UV
			UNITY_DEFINE_INSTANCED_PROP(float, _La2datextura)
#define _La2datextura_arr UV
		UNITY_INSTANCING_BUFFER_END(UV)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float _Float0_Instance = UNITY_ACCESS_INSTANCED_PROP(_Float0_arr, _Float0);
			float4 lerpResult11 = lerp( _Color0 , ( tex2D( _TextureSample0, (ase_screenPosNorm).xyzw.xy ) * _Color1 ) , ceil( saturate( ( tex2D( _TextureSample1, (ase_screenPosNorm).xyzw.xy ) + _Float0_Instance ) ) ));
			float4 _TextureSample2_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_TextureSample2_ST_arr, _TextureSample2_ST);
			float2 uv_TextureSample2 = i.uv_texcoord * _TextureSample2_ST_Instance.xy + _TextureSample2_ST_Instance.zw;
			float _La2datextura_Instance = UNITY_ACCESS_INSTANCED_PROP(_La2datextura_arr, _La2datextura);
			float4 lerpResult21 = lerp( lerpResult11 , float4( 0,0,0,0 ) , ceil( saturate( ( ( tex2D( _TextureSample2, uv_TextureSample2 ) * _Color2 ) + _La2datextura_Instance ) ) ));
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
779;73;755;648;914.9911;431.2808;1.690219;False;False
Node;AmplifyShaderEditor.CommentaryNode;27;-1579.172,369.6952;Inherit;False;606.7843;262;UV Fun;2;26;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;26;-1529.172,419.6948;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;30;-1174.184,-72.34653;Inherit;False;606.7846;262;Comment;2;28;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;25;-1195.387,508.9385;Inherit;False;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;28;-1124.184,-22.34652;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;24;-415.2109,427.0288;Inherit;False;Property;_Color2;Color 2;7;0;Create;True;0;0;0;False;0;False;0,0.5671964,1,0;0.8111136,0.1647059,0.9333333,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-522.2143,649.7333;Inherit;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;0;False;0;False;-1;0bebe40e9ebbecc48b8e9cfea982da7e;0ad200a494caf0f43a31858677a3fd81;True;0;True;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-977.3486,226.8125;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;16d574e53541bba44a84052fa38778df;e7715ad31a5979f4dbf93e80ca3a92df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-797.6832,532.049;Inherit;False;InstancedProperty;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;-0.5;-0.49;-2;-2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-394.9856,912.7266;Inherit;False;InstancedProperty;_La2datextura;La 2da textura;5;0;Create;True;0;0;0;False;0;False;-0.5;-0.01;-2;-2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-154.113,557.3916;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;29;-790.3994,66.89842;Inherit;False;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-590.5586,329.6697;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;14;-492.0027,-226.2721;Inherit;False;Property;_Color1;Color 1;6;0;Create;True;0;0;0;False;0;False;0,0.5671964,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-484.1896,13.96085;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;0bebe40e9ebbecc48b8e9cfea982da7e;1cd2deb5f024fd64c937d77c80f5a3f4;True;0;True;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;8;-390.1089,332.292;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;24.165,510.9463;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CeilOpNode;9;-234.8259,296.4517;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;12;-64.24953,-433.8995;Inherit;False;Property;_Color0;Color 0;3;0;Create;True;0;0;0;False;0;False;0,0.5671964,1,0;0.5466803,0.5988233,0.6132076,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-141.5901,-45.69485;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;17;311.201,638.8621;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;11;536.6034,56.68924;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CeilOpNode;18;476.9305,462.9245;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;21;783.7953,48.90387;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1044.728,59.76097;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;UV;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;26;0
WireConnection;5;1;25;0
WireConnection;23;0;15;0
WireConnection;23;1;24;0
WireConnection;29;0;28;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;10;1;29;0
WireConnection;8;0;7;0
WireConnection;16;0;23;0
WireConnection;16;1;19;0
WireConnection;9;0;8;0
WireConnection;13;0;10;0
WireConnection;13;1;14;0
WireConnection;17;0;16;0
WireConnection;11;0;12;0
WireConnection;11;1;13;0
WireConnection;11;2;9;0
WireConnection;18;0;17;0
WireConnection;21;0;11;0
WireConnection;21;2;18;0
WireConnection;0;0;21;0
ASEEND*/
//CHKSM=5840EB8FF1F7215B51E18B7E05AF9A2D3027213C