// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BlackAndWhiteVignetteShader"
{
	Properties
	{
		_CameraInputTexture("Camera Input Texture", 2D) = "white" {}
		_GrayscaleLuminance("Grayscale Luminance", Vector) = (0.299,0.587,0.114,0)
		_VignetteFalloff("Vignette Falloff", Range( 0 , 15)) = 0
		_ScreenBrightness("Screen Brightness", Float) = 1.53
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
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
		uniform float4 _CameraInputTexture_ST;
		uniform float3 _GrayscaleLuminance;
		uniform float _VignetteFalloff;
		uniform float _ScreenBrightness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_CameraInputTexture = i.uv_texcoord * _CameraInputTexture_ST.xy + _CameraInputTexture_ST.zw;
			float dotResult17 = dot( tex2D( _CameraInputTexture, uv_CameraInputTexture ) , float4( _GrayscaleLuminance , 0.0 ) );
			float4 appendResult23 = (float4(dotResult17 , dotResult17 , dotResult17 , 0.0));
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float smoothstepResult18 = smoothstep( 0.0 , _VignetteFalloff , distance( ase_vertex3Pos , float3( 0,0,0 ) ));
			float4 weightedBlendVar25 = float4( 0.5,0.5,0.5,0.5 );
			float4 weightedAvg25 = ( ( weightedBlendVar25.x*( appendResult23 * ( 1.0 - smoothstepResult18 ) ) + weightedBlendVar25.y*float4( 0,0,0,0 ) + weightedBlendVar25.z*float4( 0,0,0,0 ) + weightedBlendVar25.w*float4( 0,0,0,0 ) )/( weightedBlendVar25.x + weightedBlendVar25.y + weightedBlendVar25.z + weightedBlendVar25.w ) );
			o.Albedo = weightedAvg25.xyz;
			o.Emission = ( weightedAvg25 * _ScreenBrightness ).xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1148;73;355;753;152.0548;363.9864;1.348182;False;False
Node;AmplifyShaderEditor.TexturePropertyNode;8;-1458.797,-278.3598;Inherit;True;Property;_CameraInputTexture;Camera Input Texture;0;0;Create;True;0;0;0;False;0;False;ee31f1c5bce789b40a1c6119651c1416;ee31f1c5bce789b40a1c6119651c1416;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PosVertexDataNode;10;-1297.316,163.7453;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;14;-1126.342,-26.11969;Inherit;False;Property;_GrayscaleLuminance;Grayscale Luminance;1;0;Create;True;0;0;0;False;0;False;0.299,0.587,0.114;3,3,3;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;12;-1204.903,-278.3849;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;15;-1076.251,200.688;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1297.598,317.0759;Inherit;False;Property;_VignetteFalloff;Vignette Falloff;2;0;Create;True;0;0;0;False;0;False;0;6.8;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;17;-836.6444,-54.36156;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;18;-905.2965,207.3689;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-690.4127,-77.01215;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;22;-723.3086,206.2898;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-383.2191,57.28446;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WeightedBlendNode;25;-229,32.36519;Inherit;False;5;0;FLOAT4;0.5,0.5,0.5,0.5;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-226.3223,243.4052;Inherit;False;Property;_ScreenBrightness;Screen Brightness;3;0;Create;True;0;0;0;False;0;False;1.53;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-15.19681,136.1709;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;169.9983,36.42822;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;BlackAndWhiteVignetteShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;8;0
WireConnection;15;0;10;0
WireConnection;17;0;12;0
WireConnection;17;1;14;0
WireConnection;18;0;15;0
WireConnection;18;2;16;0
WireConnection;23;0;17;0
WireConnection;23;1;17;0
WireConnection;23;2;17;0
WireConnection;22;0;18;0
WireConnection;24;0;23;0
WireConnection;24;1;22;0
WireConnection;25;1;24;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;0;0;25;0
WireConnection;0;2;27;0
ASEEND*/
//CHKSM=E0FD8D5078654F5D790FF3C627C6216E965A8C50