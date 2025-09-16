// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water Noise Texture"
{
	Properties
	{
		[Header(Texture Properties)]_WaterColor("Water Color", Color) = (0.2235294,0.7215686,0.972549,0)
		_WaterNoiseTexture("Water Noise Texture", 2D) = "white" {}
		_WaterNormalTexture("Water Normal Texture", 2D) = "white" {}
		_TextureTilingXY("Texture Tiling XY", Vector) = (1.25,1.25,0,0)
		[Header(Wave Speed Properties)]_WaveSpeed("Wave Speed", Float) = 1
		_WaveDirection("Wave Direction", Vector) = (1,0,1,0)
		[Header(Wave Height Properties)]_WaveHeightSpeed("Wave Height Speed", Float) = 1
		_MaxWaveHeightSine("Max Wave Height Sine", Vector) = (0.5,1,0,0)
		[Header(Visual Properties)]_FresnelStrenght("Fresnel Strenght", Range( 0 , 1)) = 0.1
		_WaterSmoothness("Water Smoothness", Range( 0 , 1)) = 1
		_FoamDistance("Foam Distance", Range( 0 , 5)) = 1
		_FoamStrength("Foam Strength", Float) = 1
		_WaterDarkLightMinMax("Water Dark/Light MinMax", Vector) = (1,5,0,0)
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 50
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
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
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _WaterNoiseTexture;
		uniform float2 _TextureTilingXY;
		uniform float _WaveSpeed;
		uniform float3 _WaveDirection;
		uniform float _WaveHeightSpeed;
		uniform float2 _MaxWaveHeightSine;
		uniform sampler2D _WaterNormalTexture;
		uniform float4 _WaterColor;
		uniform float2 _WaterDarkLightMinMax;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FoamDistance;
		uniform float _FoamStrength;
		uniform float _FresnelStrenght;
		uniform float _WaterSmoothness;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float mulTime7 = _Time.y * _WaveSpeed;
			float3 normalizeResult11 = normalize( _WaveDirection );
			float2 uv_TexCoord44 = v.texcoord.xy * _TextureTilingXY + ( mulTime7 * normalizeResult11 ).xy;
			float2 UVMovement66 = uv_TexCoord44;
			float4 NoiseTex71 = tex2Dlod( _WaterNoiseTexture, float4( UVMovement66, 0, 0.0) );
			float mulTime37 = _Time.y * _WaveHeightSpeed;
			float4 WaveHeight90 = (( NoiseTex71 * float4(0,1,0,0) * (_MaxWaveHeightSine.x + (sin( mulTime37 ) - -1.0) * (_MaxWaveHeightSine.y - _MaxWaveHeightSine.x) / (1.0 - -1.0)) )*1.0 + 0.0);
			v.vertex.xyz += WaveHeight90.rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime7 = _Time.y * _WaveSpeed;
			float3 normalizeResult11 = normalize( _WaveDirection );
			float2 uv_TexCoord44 = i.uv_texcoord * _TextureTilingXY + ( mulTime7 * normalizeResult11 ).xy;
			float2 UVMovement66 = uv_TexCoord44;
			float4 NormalTex70 = tex2D( _WaterNormalTexture, UVMovement66 );
			o.Normal = NormalTex70.rgb;
			float4 NoiseTex71 = tex2D( _WaterNoiseTexture, UVMovement66 );
			float4 temp_cast_2 = (_WaterDarkLightMinMax.x).xxxx;
			float4 temp_cast_3 = (_WaterDarkLightMinMax.y).xxxx;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth49 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth49 = abs( ( screenDepth49 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _FoamDistance ) );
			float FoamValue78 = saturate( ( ( 1.0 - distanceDepth49 ) * _FoamStrength ) );
			float4 WaterAlbedo84 = ( saturate( ( _WaterColor * (temp_cast_2 + (NoiseTex71 - float4( 0,0,0,0 )) * (temp_cast_3 - temp_cast_2) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) ) ) + FoamValue78 );
			o.Albedo = WaterAlbedo84.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV31 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode31 = ( 0.0 + _FresnelStrenght * pow( 1.0 - fresnelNdotV31, 5.0 ) );
			float4 FresnelValue81 = ( fresnelNode31 * NoiseTex71 );
			o.Emission = FresnelValue81.rgb;
			o.Smoothness = _WaterSmoothness;
			o.Alpha = WaterAlbedo84.a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				vertexDataFunc( v );
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
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
839;73;578;665;-204.4154;1638.673;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;69;522.6187,-2124.963;Inherit;False;1030.315;459.1963;UV Movement (Water Wave Simulation);8;6;35;7;11;8;65;44;66;;1,0,0.06448603,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;6;572.619,-1947.907;Inherit;False;Property;_WaveSpeed;Wave Speed;4;1;[Header];Create;True;1;Wave Speed Properties;0;0;False;0;False;1;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;35;580.1563,-1853.767;Inherit;False;Property;_WaveDirection;Wave Direction;5;0;Create;True;0;0;0;False;0;False;1,0,1;-1,0,-0.05;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;11;772.4166,-1849.679;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;7;755.6634,-1941.928;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;65;887.3328,-2074.963;Inherit;False;Property;_TextureTilingXY;Texture Tiling XY;3;0;Create;True;0;0;0;False;0;False;1.25,1.25;6,6;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;943.4178,-1934.679;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;1095.234,-2063.834;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;80;-246.6894,-544.6246;Inherit;False;1252.089;269.7225;Foam Calculations;7;58;49;61;60;56;78;54;;0.972549,0.9631642,0.2784313,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;76;497.104,-1639.081;Inherit;False;1080.692;474.7289;Texture Setting;8;67;3;4;71;68;63;64;70;;1,0.6082045,0.427451,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;1328.935,-2068.562;Inherit;False;UVMovement;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;551.5095,-1396.449;Inherit;True;Property;_WaterNoiseTexture;Water Noise Texture;1;0;Create;True;0;0;0;False;0;False;23602af1a02907c4a997741e2cd21321;23602af1a02907c4a997741e2cd21321;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;58;-196.6894,-466.7659;Inherit;False;Property;_FoamDistance;Foam Distance;10;0;Create;True;0;0;0;False;0;False;1;0.5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;799.1432,-1299.087;Inherit;False;66;UVMovement;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;4;1000.971,-1394.352;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;49;77.59708,-486.2654;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;92;1043.295,-1131.19;Inherit;False;1560.571;370.2094;Water Color Calculations;9;73;29;30;1;79;26;55;84;93;;1,0.6117923,0.1843137,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;61;265.1155,-390.9018;Inherit;False;Property;_FoamStrength;Foam Strength;11;0;Create;True;0;0;0;False;0;False;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;77;-345.4503,-1131.978;Inherit;False;1362.791;563.9723;Wave Height Offset Calculations;10;45;37;36;42;41;16;15;34;72;90;;0.8862745,0.5962967,0.2117647,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;1349.098,-1397.208;Inherit;False;NoiseTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;54;311.2754,-486.5816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;467.1154,-487.9018;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;1429.229,-1010.13;Inherit;False;71;NoiseTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-308.34,-825.4481;Inherit;False;Property;_WaveHeightSpeed;Wave Height Speed;6;1;[Header];Create;True;1;Wave Height Properties;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;29;1351.594,-924.9807;Inherit;False;Property;_WaterDarkLightMinMax;Water Dark/Light MinMax;12;0;Create;True;0;0;0;False;0;False;1,5;1.35,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;56;610.6133,-488.1317;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;1093.294,-1081.19;Inherit;False;Property;_WaterColor;Water Color;0;1;[Header];Create;True;1;Texture Properties;0;0;False;0;False;0.2235294,0.7215686,0.972549,0;0.400943,0.7917833,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;37;-89.61217,-821.0149;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;30;1624.004,-1004.034;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;83;1046.999,-734.4496;Inherit;False;1008.478;355.5212;Fresnel Calculations;5;32;31;74;46;81;;1,0.8352336,0,1;0;0
Node;AmplifyShaderEditor.SinOpNode;36;92.83195,-820.8792;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;42;-11.49478,-738.8478;Inherit;False;Property;_MaxWaveHeightSine;Max Wave Height Sine;7;0;Create;True;0;0;0;False;0;False;0.5,1;1,1.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;1875.283,-1074.212;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;781.3969,-494.6243;Inherit;False;FoamValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;2027.565,-1001.256;Inherit;False;78;FoamValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;16;267.5781,-1007.234;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;41;255.9803,-822.974;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;93;2062.468,-1074.882;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-295.4499,-1081.979;Inherit;False;71;NoiseTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;1096.998,-609.6743;Inherit;False;Property;_FresnelStrenght;Fresnel Strenght;8;1;[Header];Create;True;1;Visual Properties;0;0;False;0;False;0.1;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;794.1434,-1513.088;Inherit;False;66;UVMovement;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;31;1390.801,-677.7633;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;63;547.1034,-1587.327;Inherit;True;Property;_WaterNormalTexture;Water Normal Texture;2;0;Create;True;0;0;0;False;0;False;26caa126227e12444823b4ddc5e8249b;26caa126227e12444823b4ddc5e8249b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;74;1452.44,-494.9278;Inherit;False;71;NoiseTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;459.5776,-1080.234;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;2218.618,-1072.887;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;2379.865,-1076.552;Inherit;False;WaterAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;1678.206,-677.6698;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;34;633.8611,-1081.016;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;64;1001.429,-1588.846;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;1831.475,-684.4494;Inherit;False;FresnelValue;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;1353.794,-1589.081;Inherit;False;NormalTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;830.2063,-1086.299;Inherit;False;WaveHeight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;568.493,154.0753;Inherit;False;84;WaterAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;722.1735,-7.941022;Inherit;False;81;FresnelValue;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;716.3567,305.7234;Inherit;False;90;WaveHeight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;734.6517,-83.31487;Inherit;False;70;NormalTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2;635.4304,74.05257;Inherit;False;Property;_WaterSmoothness;Water Smoothness;9;0;Create;True;0;0;0;False;0;False;1;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;88;777.793,157.9752;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;85;718.8738,-174.8191;Inherit;False;84;WaterAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;976.2954,-89.48096;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Water Noise Texture;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;50;10;25;False;0.5;True;0;1;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;13;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;35;0
WireConnection;7;0;6;0
WireConnection;8;0;7;0
WireConnection;8;1;11;0
WireConnection;44;0;65;0
WireConnection;44;1;8;0
WireConnection;66;0;44;0
WireConnection;4;0;3;0
WireConnection;4;1;67;0
WireConnection;49;0;58;0
WireConnection;71;0;4;0
WireConnection;54;0;49;0
WireConnection;60;0;54;0
WireConnection;60;1;61;0
WireConnection;56;0;60;0
WireConnection;37;0;45;0
WireConnection;30;0;73;0
WireConnection;30;3;29;1
WireConnection;30;4;29;2
WireConnection;36;0;37;0
WireConnection;26;0;1;0
WireConnection;26;1;30;0
WireConnection;78;0;56;0
WireConnection;41;0;36;0
WireConnection;41;3;42;1
WireConnection;41;4;42;2
WireConnection;93;0;26;0
WireConnection;31;2;32;0
WireConnection;15;0;72;0
WireConnection;15;1;16;0
WireConnection;15;2;41;0
WireConnection;55;0;93;0
WireConnection;55;1;79;0
WireConnection;84;0;55;0
WireConnection;46;0;31;0
WireConnection;46;1;74;0
WireConnection;34;0;15;0
WireConnection;64;0;63;0
WireConnection;64;1;68;0
WireConnection;81;0;46;0
WireConnection;70;0;64;0
WireConnection;90;0;34;0
WireConnection;88;0;87;0
WireConnection;0;0;85;0
WireConnection;0;1;75;0
WireConnection;0;2;82;0
WireConnection;0;4;2;0
WireConnection;0;9;88;3
WireConnection;0;11;91;0
ASEEND*/
//CHKSM=B0DDEBB7366896E285B1BE13346F9197201FBDF7