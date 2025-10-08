// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ColoredHeightMapShader"
{
	Properties
	{
		_HeightMap("HeightMap", 2D) = "white" {}
		_HeightScale("Height Scale", Float) = 5
		_RemapColor("RemapColor", Vector) = (0,1,0,5)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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

		uniform sampler2D _HeightMap;
		uniform float4 _HeightMap_ST;
		uniform float _HeightScale;
		uniform float4 _RemapColor;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_HeightMap = v.texcoord * _HeightMap_ST.xy + _HeightMap_ST.zw;
			v.vertex.xyz += ( tex2Dlod( _HeightMap, float4( uv_HeightMap, 0, 0.0) ) * _HeightScale * float4( float3(0,1,0) , 0.0 ) ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 hsvTorgb31 = HSVToRGB( float3((_RemapColor.z + (ase_vertex3Pos.y - _RemapColor.x) * (_RemapColor.w - _RemapColor.z) / (_RemapColor.y - _RemapColor.x)),1.0,1.0) );
			o.Albedo = hsvTorgb31;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
237.6;80.8;797.2;426.2;1013.279;466.306;1.672279;False;False
Node;AmplifyShaderEditor.TexturePropertyNode;1;-794.0663,293.0449;Inherit;True;Property;_HeightMap;HeightMap;0;0;Create;True;0;0;0;False;0;False;1028a9ab963ee014eb604a527e73c29b;1028a9ab963ee014eb604a527e73c29b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PosVertexDataNode;6;-656.267,-255.7892;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;18;-644.585,-111.2665;Inherit;False;Property;_RemapColor;RemapColor;2;0;Create;True;0;0;0;False;0;False;0,1,0,5;0,37.87,0,5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-520.8676,284.2482;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-395.66,512.3846;Inherit;False;Property;_HeightScale;Height Scale;1;0;Create;True;0;0;0;False;0;False;5;32.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;5;-378.5213,602.7758;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;17;-436.5379,-139.324;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-167.7617,317.2704;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.HSVToRGBNode;31;-220.4636,-141.4293;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;76.79999,-3.83999;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ColoredHeightMapShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;17;0;6;2
WireConnection;17;1;18;1
WireConnection;17;2;18;2
WireConnection;17;3;18;3
WireConnection;17;4;18;4
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;3;2;5;0
WireConnection;31;0;17;0
WireConnection;0;0;31;0
WireConnection;0;11;3;0
ASEEND*/
//CHKSM=21AB08A56C2E90A6D2ED909C63E9B11BBA5967A5