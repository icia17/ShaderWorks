// Upgrade NOTE: upgraded instancing buffer 'CustomToonShader' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/ToonShader"
{
	Properties
	{
		_ShadowNum("Shadow Num", Range( 0 , 1)) = 1
		_Shadowforce2("Shadow force 2 ", Range( 0 , 1)) = 1
		_Float0("Float 0", Range( 0 , 1)) = 1
		_Texture0("Texture 0", 2D) = "white" {}
		_Color0("Color 0", Color) = (0.1084906,0.1428816,1,0)
		_Color1("Color 1", Color) = (0,1,0.2141662,0)
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _Texture0;
		uniform float4 _Color0;
		uniform sampler2D _TextureSample1;

		UNITY_INSTANCING_BUFFER_START(CustomToonShader)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Texture0_ST)
#define _Texture0_ST_arr CustomToonShader
			UNITY_DEFINE_INSTANCED_PROP(float4, _Color1)
#define _Color1_arr CustomToonShader
			UNITY_DEFINE_INSTANCED_PROP(float4, _TextureSample1_ST)
#define _TextureSample1_ST_arr CustomToonShader
			UNITY_DEFINE_INSTANCED_PROP(float, _ShadowNum)
#define _ShadowNum_arr CustomToonShader
			UNITY_DEFINE_INSTANCED_PROP(float, _Shadowforce2)
#define _Shadowforce2_arr CustomToonShader
			UNITY_DEFINE_INSTANCED_PROP(float, _Float0)
#define _Float0_arr CustomToonShader
		UNITY_INSTANCING_BUFFER_END(CustomToonShader)

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 _Texture0_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Texture0_ST_arr, _Texture0_ST);
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST_Instance.xy + _Texture0_ST_Instance.zw;
			float4 _Color1_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color1_arr, _Color1);
			float _ShadowNum_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShadowNum_arr, _ShadowNum);
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float4 _TextureSample1_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_TextureSample1_ST_arr, _TextureSample1_ST);
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST_Instance.xy + _TextureSample1_ST_Instance.zw;
			float dotResult3 = dot( ase_worldlightDir , (WorldNormalVector( i , UnpackNormal( tex2D( _TextureSample1, uv_TextureSample1 ) ) )) );
			float Dir_light_var13 = dotResult3;
			float _Shadowforce2_Instance = UNITY_ACCESS_INSTANCED_PROP(_Shadowforce2_arr, _Shadowforce2);
			float _Float0_Instance = UNITY_ACCESS_INSTANCED_PROP(_Float0_arr, _Float0);
			float4 lerpResult25 = lerp( _Color0 , _Color1_Instance , ( ( step( (0.0 + (_ShadowNum_Instance - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) , Dir_light_var13 ) + step( (0.0 + (_Shadowforce2_Instance - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) , Dir_light_var13 ) + step( (0.0 + (_Float0_Instance - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) , Dir_light_var13 ) ) / 3.0 ));
			c.rgb = ( tex2D( _Texture0, uv_Texture0 ) * lerpResult25 ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
450;194;1073;552;2266.16;-1122.333;2.410466;False;False
Node;AmplifyShaderEditor.CommentaryNode;18;-1456.038,1666.923;Inherit;False;924.0689;529.7861;Comment;4;2;1;3;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;32;-1920.446,1974.558;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;0;False;0;False;-1;77fdad851e93f394c9f8a1b1a63b56f3;77fdad851e93f394c9f8a1b1a63b56f3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;1;-1386.224,1716.923;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;2;-1406.038,1942.709;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;3;-1054.082,1932.409;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-769.8483,1724.913;Inherit;False;Dir_light_var;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-939.3583,-160.9761;Inherit;True;InstancedProperty;_ShadowNum;Shadow Num;0;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-988.3549,423.3868;Inherit;True;InstancedProperty;_Shadowforce2;Shadow force 2 ;1;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1070.966,937.2077;Inherit;True;InstancedProperty;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-601.4293,732.563;Inherit;False;13;Dir_light_var;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;29;-715.7706,940.8738;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-665.509,1211.382;Inherit;False;13;Dir_light_var;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;15;-647.5731,468.2319;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-592.9374,259.7017;Inherit;False;13;Dir_light_var;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;6;-571.433,-45.26973;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;4;-277.0645,121.3577;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;16;-292.9335,487.5046;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;30;-345.2384,950.0634;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-17.76029,318.1437;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;21;354.5871,218.0094;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;148.182,-546.1177;Inherit;False;InstancedProperty;_Color1;Color 1;5;0;Create;True;0;0;0;False;0;False;0,1,0.2141662,0;0,1,0.2141662,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;8;-91.16366,-266.4615;Inherit;True;Property;_Texture0;Texture 0;3;0;Create;True;0;0;0;False;0;False;5798ded558355430c8a9b13ee12a847c;5798ded558355430c8a9b13ee12a847c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;22;287.8665,-774.7886;Inherit;False;Property;_Color0;Color 0;4;0;Create;True;0;0;0;False;0;False;0.1084906,0.1428816,1,0;0.1084906,0.1428816,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;213.5619,-208.902;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;25;588.0814,-79.8156;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;27;342.0129,-54.04926;Inherit;False;InstancedProperty;_Color2;Color 2;6;0;Create;True;0;0;0;False;0;False;0,1,0.2141662,0;0,1,0.2141662,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;842.535,-73.18672;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1229.418,-141.1978;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Custom/ToonShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;32;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;13;0;3;0
WireConnection;29;0;28;0
WireConnection;15;0;20;0
WireConnection;6;0;5;0
WireConnection;4;0;6;0
WireConnection;4;1;14;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;30;0;29;0
WireConnection;30;1;31;0
WireConnection;19;0;4;0
WireConnection;19;1;16;0
WireConnection;19;2;30;0
WireConnection;21;0;19;0
WireConnection;7;0;8;0
WireConnection;25;0;22;0
WireConnection;25;1;24;0
WireConnection;25;2;21;0
WireConnection;9;0;7;0
WireConnection;9;1;25;0
WireConnection;0;13;9;0
ASEEND*/
//CHKSM=9255BE0D57F7FA34E5AFB18031B3072948320990