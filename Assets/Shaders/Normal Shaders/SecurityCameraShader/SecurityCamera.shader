// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SecurityCamera"
{
	Properties
	{
		_CameraInputTexture("Camera Input Texture", 2D) = "white" {}
		_ScreenResolution("Screen Resolution", Vector) = (240,135,0,0)
		_ScreenBarsScale("Screen Bars Scale", Float) = 250
		_ScreenBarSize("Screen Bar Size", Range( 0 , 1)) = 0.75
		_ScreenBarsSpeed("Screen Bars Speed", Range( 0 , 1)) = 0.1
		_VignetteFalloff("Vignette Falloff", Range( 0 , 15)) = 0
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _CameraInputTexture;
		uniform float2 _ScreenResolution;
		uniform float _ScreenBarsSpeed;
		uniform float _ScreenBarsScale;
		uniform float _ScreenBarSize;
		uniform float _VignetteFalloff;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float pixelWidth8 =  1.0f / _ScreenResolution.x;
			float pixelHeight8 = 1.0f / _ScreenResolution.y;
			half2 pixelateduv8 = half2((int)(i.uv_texcoord.x / pixelWidth8) * pixelWidth8, (int)(i.uv_texcoord.y / pixelHeight8) * pixelHeight8);
			float dotResult6 = dot( tex2D( _CameraInputTexture, pixelateduv8 ) , float4( float3(0.299,0.587,0.114) , 0.0 ) );
			float4 appendResult15 = (float4(dotResult6 , dotResult6 , dotResult6 , 0.0));
			float3 ase_worldPos = i.worldPos;
			float mulTime47 = _Time.y * _ScreenBarsSpeed;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float smoothstepResult68 = smoothstep( 0.0 , _VignetteFalloff , distance( ase_vertex3Pos , float3( 0,0,0 ) ));
			float4 weightedBlendVar65 = float4( 0.5,0.5,0.5,0.5 );
			float4 weightedAvg65 = ( ( weightedBlendVar65.x*( appendResult15 * step( frac( sin( ( ( ase_worldPos.y - mulTime47 ) * _ScreenBarsScale ) ) ) , _ScreenBarSize ) * ( 1.0 - smoothstepResult68 ) ) + weightedBlendVar65.y*float4( 0,0,0,0 ) + weightedBlendVar65.z*float4( 0,0,0,0 ) + weightedBlendVar65.w*float4( 0,0,0,0 ) )/( weightedBlendVar65.x + weightedBlendVar65.y + weightedBlendVar65.z + weightedBlendVar65.w ) );
			o.Albedo = weightedAvg65.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1138;73;454;593;934.9094;54.227;2.751777;False;False
Node;AmplifyShaderEditor.RangedFloatNode;48;-1349.555,675.7641;Inherit;False;Property;_ScreenBarsSpeed;Screen Bars Speed;4;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;28;-1009.856,530.0353;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;47;-1000.353,679.0896;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1165.671,238.7901;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-791.8398,703.5892;Inherit;False;Property;_ScreenBarsScale;Screen Bars Scale;2;0;Create;True;0;0;0;False;0;False;250;150;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;46;-793.7526,577.8897;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;10;-1151.949,361.4576;Inherit;False;Property;_ScreenResolution;Screen Resolution;1;0;Create;True;0;0;0;False;0;False;240,135;480,270;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-586.175,584.2952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-903.0372,70.70264;Inherit;True;Property;_CameraInputTexture;Camera Input Texture;0;0;Create;True;0;0;0;False;0;False;ee31f1c5bce789b40a1c6119651c1416;ee31f1c5bce789b40a1c6119651c1416;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TFHCPixelate;8;-859.6891,287.2815;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;62;-785.3284,993.6243;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;11;-438.7,584.7183;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-649.1427,70.67743;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;55;-564.2636,1030.567;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-785.6103,1146.955;Inherit;False;Property;_VignetteFalloff;Vignette Falloff;5;0;Create;True;0;0;0;False;0;False;0;0.5;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;5;-570.5818,322.9426;Inherit;False;Constant;_GrayscaleLuminance;Grayscale Luminance;1;0;Create;True;0;0;0;False;0;False;0.299,0.587,0.114;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SmoothstepOpNode;68;-393.309,1037.248;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;32;-297.0543,584.7145;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-440.8094,676.418;Inherit;False;Property;_ScreenBarSize;Screen Bar Size;3;0;Create;True;0;0;0;False;0;False;0.75;0.76;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;6;-291.7782,173.5098;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;23;-143.5402,583.7625;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-145.5469,150.8592;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;69;-211.3209,1036.169;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;340.0291,203.4542;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WeightedBlendNode;65;491.4669,250.8514;Inherit;False;5;0;FLOAT4;0.5,0.5,0.5,0.5;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;594.5001,34.2;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SecurityCamera;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;47;0;48;0
WireConnection;46;0;28;2
WireConnection;46;1;47;0
WireConnection;25;0;46;0
WireConnection;25;1;26;0
WireConnection;8;0;9;0
WireConnection;8;1;10;1
WireConnection;8;2;10;2
WireConnection;11;0;25;0
WireConnection;4;0;3;0
WireConnection;4;1;8;0
WireConnection;55;0;62;0
WireConnection;68;0;55;0
WireConnection;68;2;53;0
WireConnection;32;0;11;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;23;0;32;0
WireConnection;23;1;35;0
WireConnection;15;0;6;0
WireConnection;15;1;6;0
WireConnection;15;2;6;0
WireConnection;69;0;68;0
WireConnection;43;0;15;0
WireConnection;43;1;23;0
WireConnection;43;2;69;0
WireConnection;65;1;43;0
WireConnection;0;0;65;0
ASEEND*/
//CHKSM=0989614EBB6EE18354D0C929338B1656A14A011A