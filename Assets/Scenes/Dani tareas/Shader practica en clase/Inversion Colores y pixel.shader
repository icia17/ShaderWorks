// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Inversion Colores y pixel"
{
	Properties
	{
		_Pixeldensity("Pixel density", Float) = 100
		_mezcladevalores("mezcla de valores ", Range( 0 , 1)) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture0;
		uniform float _Pixeldensity;
		uniform float _mezcladevalores;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 lerpResult8 = lerp( ( 1.0 - tex2D( _Texture0, ( floor( ( i.uv_texcoord * _Pixeldensity ) ) / _Pixeldensity ) ) ) , float4( 0,0,0,0 ) , _mezcladevalores);
			o.Emission = lerpResult8.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
796;81;636;557;743.1942;191.5322;1.712878;False;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1392.342,360.5623;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-1235.59,516.4594;Inherit;False;Property;_Pixeldensity;Pixel density;0;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1061.231,353.3156;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;10;-567.9988,531.6219;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;5;-829.5907,363.2816;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;6;-572.6628,374.6178;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-1098.468,-82.86228;Inherit;True;Property;_Texture0;Texture 0;2;0;Create;True;0;0;0;False;0;False;19495687d80e6d04da719667d57b6025;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;1;-683.8775,-146.359;Inherit;True;Property;_Texureproperty;Texure property;0;0;Create;True;0;0;0;False;0;False;-1;19495687d80e6d04da719667d57b6025;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-301.2737,354.876;Inherit;False;Property;_mezcladevalores;mezcla de valores ;1;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;4;-336.3237,-82.23196;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;8;-134.8312,127.8311;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;234.6643,23.98029;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Inversion Colores y pixel;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;2;0
WireConnection;7;1;9;0
WireConnection;10;0;9;0
WireConnection;5;0;7;0
WireConnection;6;0;5;0
WireConnection;6;1;10;0
WireConnection;1;0;12;0
WireConnection;1;1;6;0
WireConnection;4;0;1;0
WireConnection;8;0;4;0
WireConnection;8;2;13;0
WireConnection;0;2;8;0
ASEEND*/
//CHKSM=9693FFBBC28839BE3C203879D14CDB55C1A4B4EC