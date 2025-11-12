// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RippleWaveHitboxShader"
{
	Properties
	{
		_Velocity("Velocity", Float) = 1
		_Frequency("Frequency", Range( 0 , 50)) = 1
		_RippleStartTime("RippleStartTime", Float) = 0
		_RippleMaxTime("RippleMaxTime", Float) = 1
		_RippleMaxDistance("RippleMaxDistance", Float) = 0
		_HeightMagnitude("Height Magnitude", Range( 0 , 10)) = 0
		_RippleCenter("RippleCenter", Vector) = (0,0,0,0)
		_RippleSeed("Ripple Seed", Float) = 0
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

		uniform float3 _RippleCenter;
		uniform float _Frequency;
		uniform float _RippleStartTime;
		uniform float _Velocity;
		uniform float _RippleSeed;
		uniform float _RippleMaxDistance;
		uniform float _RippleMaxTime;
		uniform float _HeightMagnitude;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_17_0 = ( _RippleStartTime - _Time.y );
			float temp_output_39_0 = ( saturate( ( sin( ( ( distance( ase_worldPos , _RippleCenter ) * _Frequency ) + ( ( temp_output_17_0 * _Velocity ) - _RippleSeed ) ) ) - (0.0 + (distance( ase_worldPos , _RippleCenter ) - 0.0) * (1.0 - 0.0) / (_RippleMaxDistance - 0.0)) ) ) * ( 1.0 - saturate( (0.0 + (-temp_output_17_0 - 0.0) * (1.0 - 0.0) / (_RippleMaxTime - 0.0)) ) ) );
			float4 appendResult12 = (float4(0.0 , ( temp_output_39_0 * _HeightMagnitude ) , 0.0 , 0.0));
			v.vertex.xyz += appendResult12.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float temp_output_17_0 = ( _RippleStartTime - _Time.y );
			float temp_output_39_0 = ( saturate( ( sin( ( ( distance( ase_worldPos , _RippleCenter ) * _Frequency ) + ( ( temp_output_17_0 * _Velocity ) - _RippleSeed ) ) ) - (0.0 + (distance( ase_worldPos , _RippleCenter ) - 0.0) * (1.0 - 0.0) / (_RippleMaxDistance - 0.0)) ) ) * ( 1.0 - saturate( (0.0 + (-temp_output_17_0 - 0.0) * (1.0 - 0.0) / (_RippleMaxTime - 0.0)) ) ) );
			float3 temp_cast_0 = (temp_output_39_0).xxx;
			o.Albedo = temp_cast_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
464;73;961;604;1636.908;396.4753;1.786973;False;False
Node;AmplifyShaderEditor.CommentaryNode;28;-1577.298,295.5591;Inherit;False;871.639;382.0125;Valor que va de 0-1 y baja si la distancia del centro del ripple tiende a su maxima distancia;5;14;20;19;26;18;;1,0,0.5444956,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;16;-1556.119,835.5344;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1569.609,755.4111;Inherit;False;Property;_RippleStartTime;RippleStartTime;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1071.191,133.2109;Inherit;False;Property;_Velocity;Velocity;0;0;Create;True;0;0;0;False;0;False;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1425.293,-238.2166;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;17;-1346.782,761.5455;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;14;-1518.608,493.2639;Inherit;False;Property;_RippleCenter;RippleCenter;6;0;Create;True;0;0;0;False;0;False;0,0,0;0,-2,-14;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-909.7994,110.9733;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;4;-1198.16,-176.7593;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1334.842,56.4291;Inherit;False;Property;_Frequency;Frequency;1;0;Create;True;0;0;0;False;0;False;1;5;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-921.8665,215.2042;Inherit;False;Property;_RippleSeed;Ripple Seed;7;0;Create;True;0;0;0;False;0;False;0;-2.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-726.0734,151.4114;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1019.443,-34.17098;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;20;-1527.298,345.5592;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;19;-1133.039,403.9436;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;37;-1180.201,762.5281;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1222.164,912.9615;Inherit;False;Property;_RippleMaxTime;RippleMaxTime;3;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1196.378,504.3045;Inherit;False;Property;_RippleMaxDistance;RippleMaxDistance;4;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-720.0999,-30.77416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;26;-958.0721,404.5948;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;10;-576.0886,-32.2934;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;35;-955.8021,765.728;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;30;-416.2223,45.87833;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;41;-761.8745,766.5624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-620.0471,768.3088;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;31;-218.7328,128.8784;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-320.0661,457.6498;Inherit;False;Property;_HeightMagnitude;Height Magnitude;5;0;Create;True;0;0;0;False;0;False;0;5.99;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-34.72168,186.1715;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-25.78525,439.1406;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;147.2349,414.2448;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;374.6496,132.3203;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;RippleWaveHitboxShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;42;0;17;0
WireConnection;42;1;3;0
WireConnection;4;0;1;0
WireConnection;4;1;14;0
WireConnection;43;0;42;0
WireConnection;43;1;44;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;19;0;20;0
WireConnection;19;1;14;0
WireConnection;37;0;17;0
WireConnection;8;0;6;0
WireConnection;8;1;43;0
WireConnection;26;0;19;0
WireConnection;26;2;18;0
WireConnection;10;0;8;0
WireConnection;35;0;37;0
WireConnection;35;2;34;0
WireConnection;30;0;10;0
WireConnection;30;1;26;0
WireConnection;41;0;35;0
WireConnection;40;0;41;0
WireConnection;31;0;30;0
WireConnection;39;0;31;0
WireConnection;39;1;40;0
WireConnection;11;0;39;0
WireConnection;11;1;9;0
WireConnection;12;1;11;0
WireConnection;0;0;39;0
WireConnection;0;11;12;0
ASEEND*/
//CHKSM=7D739F86700F5DE2F2ECFEF7A548F493E6E848ED