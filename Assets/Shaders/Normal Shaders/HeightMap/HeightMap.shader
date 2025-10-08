// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HeightMap"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		_Color("Color", Color) = (0.2853328,0.8641509,0.7129481,0)
		_Offset("Offset", Float) = 0
		_Tiling("Tiling", Float) = 0
		_DiffuseMap("Diffuse Map", 2D) = "white" {}
		_TextureHeightScale("Texture Height Scale", Float) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture0;
		uniform float _Tiling;
		uniform float _Offset;
		uniform float _TextureHeightScale;
		uniform sampler2D _DiffuseMap;
		uniform float4 _DiffuseMap_ST;
		uniform float4 _Color;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 temp_cast_0 = (_Tiling).xx;
			float2 temp_cast_1 = (_Offset).xx;
			float2 uv_TexCoord25 = v.texcoord.xy * temp_cast_0 + temp_cast_1;
			v.vertex.xyz += ( tex2Dlod( _Texture0, float4( uv_TexCoord25, 0, 0.0) ).r * float4(0,1,0,0) * _TextureHeightScale ).xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_DiffuseMap = i.uv_texcoord * _DiffuseMap_ST.xy + _DiffuseMap_ST.zw;
			o.Albedo = ( tex2D( _DiffuseMap, uv_DiffuseMap ) * _Color ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
294;73;1350;595;539.929;306.0983;1.118685;False;False
Node;AmplifyShaderEditor.RangedFloatNode;26;-293.9008,104.7155;Inherit;False;Property;_Tiling;Tiling;7;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-289.6698,253.6144;Inherit;False;Property;_Offset;Offset;6;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-38.75624,119.1526;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;17;-47.83181,-106.7416;Inherit;True;Property;_Texture0;Texture 0;10;0;Create;True;0;0;0;False;0;False;None;51dabacd2b30a03498e5f4c2a4944a2e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;18;252.864,65.00291;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;20;382.4024,312.6027;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;257.0532,-377.5695;Inherit;True;Property;_DiffuseMap;Diffuse Map;8;0;Create;True;0;0;0;False;0;False;-1;ad661d18fc1283849b65b5e2b8a59b01;ad661d18fc1283849b65b5e2b8a59b01;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;23;328.125,-181.2119;Inherit;False;Property;_Color;Color;5;0;Create;True;0;0;0;False;0;False;0.2853328,0.8641509,0.7129481,0;0.2853327,0.8641509,0.7129481,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;366.8112,513.3115;Inherit;False;Property;_TextureHeightScale;Texture Height Scale;9;0;Create;True;0;0;0;False;0;False;0;162.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;645.9219,136.3031;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;653.3557,-208.9755;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;924.1016,-76.98905;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;HeightMap;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;2;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;26;0
WireConnection;25;1;27;0
WireConnection;18;0;17;0
WireConnection;18;1;25;0
WireConnection;19;0;18;1
WireConnection;19;1;20;0
WireConnection;19;2;21;0
WireConnection;24;0;22;0
WireConnection;24;1;23;0
WireConnection;0;0;24;0
WireConnection;0;11;19;0
ASEEND*/
//CHKSM=A1A3BA5D31F7E77969B12BD71F64A92D11635768