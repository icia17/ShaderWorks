// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InvertPixelateShader"
{
	Properties
	{
		_CameraInputTexture1("Camera Input Texture", 2D) = "white" {}
		_ScreenResolution1("Screen Resolution", Vector) = (240,135,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
			float2 uv_texcoord;
		};

		uniform sampler2D _CameraInputTexture1;
		uniform float2 _ScreenResolution1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float pixelWidth11 =  1.0f / _ScreenResolution1.x;
			float pixelHeight11 = 1.0f / _ScreenResolution1.y;
			half2 pixelateduv11 = half2((int)(i.uv_texcoord.x / pixelWidth11) * pixelWidth11, (int)(i.uv_texcoord.y / pixelHeight11) * pixelHeight11);
			o.Albedo = ( 1.0 - tex2D( _CameraInputTexture1, pixelateduv11 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
748;73;844;565;1093.056;395.9095;1.624342;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1017.61,161.7705;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;7;-1003.887,284.4382;Inherit;False;Property;_ScreenResolution1;Screen Resolution;1;0;Create;True;0;0;0;False;0;False;240,135;240,135;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;8;-754.9773,-6.316886;Inherit;True;Property;_CameraInputTexture1;Camera Input Texture;0;0;Create;True;0;0;0;False;0;False;ee31f1c5bce789b40a1c6119651c1416;ee31f1c5bce789b40a1c6119651c1416;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TFHCPixelate;11;-711.6291,210.262;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;12;-501.0832,-6.341987;Inherit;True;Property;_TextureSample1;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;28;-180.0874,-1.144449;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;InvertPixelateShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;6;0
WireConnection;11;1;7;1
WireConnection;11;2;7;2
WireConnection;12;0;8;0
WireConnection;12;1;11;0
WireConnection;28;0;12;0
WireConnection;0;0;28;0
ASEEND*/
//CHKSM=CC6FBE57677EC52D8E9E3026FCCFAA9856F79F87