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
		[Header(Visual Properties)]_FresnelStrenght("Fresnel Strenght", Range( 0 , 1)) = 0.1
		_WaterSmoothness("Water Smoothness", Range( 0 , 1)) = 1
		_FoamDistance("Foam Distance", Range( 0 , 5)) = 1
		_FoamStrength("Foam Strength", Float) = 1
		_WaterDarkLightMinMax("Water Dark/Light MinMax", Vector) = (1,5,0,0)
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		_WaterVoronoiScale("Water Voronoi Scale", Float) = 25
		_WaterOffsetScaleY("Water Offset Scale Y", Float) = 10
		_WaterHeightSpeed("Water Height Speed", Float) = 1
		_DistortionWeight("Distortion Weight", Range( 0 , 1)) = 0.2
		_WaterFlowMapTexture("Water FlowMap Texture", 2D) = "white" {}
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

		uniform float _WaterVoronoiScale;
		uniform float _WaterHeightSpeed;
		uniform float _WaterOffsetScaleY;
		uniform sampler2D _WaterNormalTexture;
		uniform float2 _TextureTilingXY;
		uniform float _WaveSpeed;
		uniform float3 _WaveDirection;
		uniform sampler2D _WaterFlowMapTexture;
		uniform float4 _WaterFlowMapTexture_ST;
		uniform float _DistortionWeight;
		uniform float4 _WaterColor;
		uniform float2 _WaterDarkLightMinMax;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FoamDistance;
		uniform float _FoamStrength;
		uniform float _FresnelStrenght;
		uniform sampler2D _WaterNoiseTexture;
		uniform float _WaterSmoothness;
		uniform float _EdgeLength;


		float2 voronoihash122( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi122( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash122( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float mulTime126 = _Time.y * _WaterHeightSpeed;
			float time122 = mulTime126;
			float2 coords122 = v.texcoord.xy * _WaterVoronoiScale;
			float2 id122 = 0;
			float2 uv122 = 0;
			float voroi122 = voronoi122( coords122, time122, id122, uv122, 0 );
			float4 WaterVoronoiTexture133 = ( voroi122 * float4(0,1,0,0) * _WaterOffsetScaleY );
			v.vertex.xyz += WaterVoronoiTexture133.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime7 = _Time.y * _WaveSpeed;
			float3 normalizeResult11 = normalize( _WaveDirection );
			float2 uv_TexCoord44 = i.uv_texcoord * _TextureTilingXY + ( mulTime7 * normalizeResult11 ).xy;
			float2 UVMovement66 = uv_TexCoord44;
			float2 uv_WaterFlowMapTexture = i.uv_texcoord * _WaterFlowMapTexture_ST.xy + _WaterFlowMapTexture_ST.zw;
			float4 tex2DNode97 = tex2D( _WaterFlowMapTexture, uv_WaterFlowMapTexture );
			float2 appendResult100 = (float2(tex2DNode97.r , tex2DNode97.g));
			float2 lerpResult104 = lerp( UVMovement66 , ( appendResult100 + UVMovement66 ) , _DistortionWeight);
			float2 DistortedUVMovement111 = lerpResult104;
			float4 NormalTex70 = tex2D( _WaterNormalTexture, DistortedUVMovement111 );
			o.Normal = NormalTex70.rgb;
			float mulTime126 = _Time.y * _WaterHeightSpeed;
			float time122 = mulTime126;
			float2 coords122 = i.uv_texcoord * _WaterVoronoiScale;
			float2 id122 = 0;
			float2 uv122 = 0;
			float voroi122 = voronoi122( coords122, time122, id122, uv122, 0 );
			float4 WaterVoronoiTexture133 = ( voroi122 * float4(0,1,0,0) * _WaterOffsetScaleY );
			float4 temp_cast_2 = (_WaterDarkLightMinMax.x).xxxx;
			float4 temp_cast_3 = (_WaterDarkLightMinMax.y).xxxx;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth49 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth49 = abs( ( screenDepth49 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _FoamDistance ) );
			float FoamValue78 = saturate( ( ( 1.0 - distanceDepth49 ) * _FoamStrength ) );
			float4 WaterAlbedo84 = ( saturate( ( _WaterColor * (temp_cast_2 + (WaterVoronoiTexture133 - float4( 0,0,0,0 )) * (temp_cast_3 - temp_cast_2) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) ) ) + FoamValue78 );
			o.Albedo = WaterAlbedo84.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV31 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode31 = ( 0.0 + _FresnelStrenght * pow( 1.0 - fresnelNdotV31, 5.0 ) );
			float4 NoiseTex71 = tex2D( _WaterNoiseTexture, DistortedUVMovement111 );
			float4 FresnelValue81 = ( fresnelNode31 * NoiseTex71 );
			o.Emission = FresnelValue81.rgb;
			o.Smoothness = _WaterSmoothness;
			o.Alpha = 1;
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
623;73;890;665;1309.558;1480.348;3.886852;True;False
Node;AmplifyShaderEditor.CommentaryNode;69;519.9528,-2346.24;Inherit;False;1030.315;459.1963;UV Movement (Water Wave Simulation);8;6;35;7;11;8;65;44;66;;1,0,0.06448603,1;0;0
Node;AmplifyShaderEditor.Vector3Node;35;567.8903,-2073.442;Inherit;False;Property;_WaveDirection;Wave Direction;5;0;Create;True;0;0;0;False;0;False;1,0,1;-1,0,-0.05;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;6;569.9531,-2169.183;Inherit;False;Property;_WaveSpeed;Wave Speed;4;1;[Header];Create;True;1;Wave Speed Properties;0;0;False;0;False;1;0.035;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;11;769.7507,-2070.954;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;7;752.9974,-2163.204;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;940.7518,-2155.955;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;112;298.1487,-1850.503;Inherit;False;1505.243;459.8985;Wave Distortion Calculations;8;111;104;101;106;105;100;97;96;;1,0.4268636,0.2622641,1;0;0
Node;AmplifyShaderEditor.Vector2Node;65;884.6669,-2296.24;Inherit;False;Property;_TextureTilingXY;Texture Tiling XY;3;0;Create;True;0;0;0;False;0;False;1.25,1.25;6,6;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;96;348.1485,-1800.503;Inherit;True;Property;_WaterFlowMapTexture;Water FlowMap Texture;20;0;Create;True;0;0;0;False;0;False;2318775c5cee59b40bacb79fa5fd4571;2318775c5cee59b40bacb79fa5fd4571;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;1092.568,-2285.111;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;132;-637.7894,-500.1586;Inherit;False;Property;_WaterHeightSpeed;Water Height Speed;18;0;Create;True;0;0;0;False;0;False;1;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;1326.269,-2289.839;Inherit;False;UVMovement;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;97;623.0448,-1800.206;Inherit;True;Property;_TextureSample0;Texture Sample 0;18;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;80;-234.3539,-864.3194;Inherit;False;1252.089;269.7225;Foam Calculations;7;58;49;61;60;56;78;54;;0.972549,0.9631642,0.2784313,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;823.6581,-1579.939;Inherit;False;66;UVMovement;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;100;963.6022,-1691.894;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;126;-405.4837,-495.2032;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-443.8835,-412.0032;Inherit;False;Property;_WaterVoronoiScale;Water Voronoi Scale;16;0;Create;True;0;0;0;False;0;False;25;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;1005.903,-1487.639;Inherit;False;Property;_DistortionWeight;Distortion Weight;19;0;Create;True;0;0;0;False;0;False;0.2;0.375;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;1151.906,-1648.236;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-184.3539,-786.4608;Inherit;False;Property;_FoamDistance;Foam Distance;8;0;Create;True;0;0;0;False;0;False;1;0.6;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-247.0835,-216.8031;Inherit;False;Property;_WaterOffsetScaleY;Water Offset Scale Y;17;0;Create;True;0;0;0;False;0;False;10;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;122;-203.291,-519.6447;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;25;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.Vector4Node;116;-199.5135,-397.3714;Inherit;False;Constant;_Vector0;Vector 0;16;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;49;89.93266,-805.9603;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-6.073185,-451.1313;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;104;1347.094,-1572.679;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;92;1055.631,-1366.799;Inherit;False;1560.571;370.2094;Water Color Calculations;9;73;29;30;1;79;26;55;84;93;;1,0.6117923,0.1843137,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;54;323.611,-806.2764;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;277.4511,-710.5967;Inherit;False;Property;_FoamStrength;Foam Strength;9;0;Create;True;0;0;0;False;0;False;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;76;-62.96405,-1363.413;Inherit;False;1080.692;474.7289;Texture Setting;8;67;3;4;71;68;63;64;70;;0.8862745,0.5960785,0.2117647,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;1546.527,-1578.561;Inherit;False;DistortedUVMovement;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;130.3495,-443.6155;Inherit;False;WaterVoronoiTexture;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;199.0753,-1029.221;Inherit;False;111;DistortedUVMovement;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;479.451,-807.5966;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;29;1363.93,-1160.59;Inherit;False;Property;_WaterDarkLightMinMax;Water Dark/Light MinMax;10;0;Create;True;0;0;0;False;0;False;1,5;0.45,0.7;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;3;-8.55864,-1108.183;Inherit;True;Property;_WaterNoiseTexture;Water Noise Texture;1;0;Create;True;0;0;0;False;0;False;23602af1a02907c4a997741e2cd21321;23602af1a02907c4a997741e2cd21321;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;73;1352.315,-1253.946;Inherit;False;133;WaterVoronoiTexture;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;56;622.9489,-807.8265;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;30;1636.34,-1239.643;Inherit;False;5;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,1,1,1;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;1,1,1,1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;83;1056.875,-962.68;Inherit;False;1008.478;355.5212;Fresnel Calculations;5;32;31;74;46;81;;1,0.8352336,0,1;0;0
Node;AmplifyShaderEditor.SamplerNode;4;440.9033,-1106.086;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1;1105.63,-1316.799;Inherit;False;Property;_WaterColor;Water Color;0;1;[Header];Create;True;1;Texture Properties;0;0;False;0;False;0.2235294,0.7215686,0.972549,0;0.4009424,0.7917833,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;1106.874,-837.9048;Inherit;False;Property;_FresnelStrenght;Fresnel Strenght;6;1;[Header];Create;True;1;Visual Properties;0;0;False;0;False;0.1;0.268;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;793.7325,-814.3191;Inherit;False;FoamValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;1887.619,-1309.821;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;789.0305,-1108.942;Inherit;False;NoiseTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;63;-12.96477,-1299.061;Inherit;True;Property;_WaterNormalTexture;Water Normal Texture;2;0;Create;True;0;0;0;False;0;False;26caa126227e12444823b4ddc5e8249b;26caa126227e12444823b4ddc5e8249b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FresnelNode;31;1400.677,-905.9938;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;202.0755,-1224.022;Inherit;False;111;DistortedUVMovement;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;1462.316,-723.1581;Inherit;False;71;NoiseTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;2039.901,-1236.865;Inherit;False;78;FoamValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;93;2074.803,-1310.491;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;2230.953,-1308.496;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;1688.082,-905.9003;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;64;441.3613,-1300.58;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;2392.2,-1312.161;Inherit;False;WaterAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;1841.351,-912.6799;Inherit;False;FresnelValue;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;793.7264,-1300.815;Inherit;False;NormalTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;674.3042,276.1874;Inherit;False;133;WaterVoronoiTexture;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;734.6517,-83.31487;Inherit;False;70;NormalTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;718.8738,-174.8191;Inherit;False;84;WaterAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;722.1735,-7.941022;Inherit;False;81;FresnelValue;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2;635.4304,74.05257;Inherit;False;Property;_WaterSmoothness;Water Smoothness;7;0;Create;True;0;0;0;False;0;False;1;0.65;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;976.2954,-89.48096;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Water Noise Texture;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;2;10;25;False;0.5;True;0;1;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;11;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;35;0
WireConnection;7;0;6;0
WireConnection;8;0;7;0
WireConnection;8;1;11;0
WireConnection;44;0;65;0
WireConnection;44;1;8;0
WireConnection;66;0;44;0
WireConnection;97;0;96;0
WireConnection;100;0;97;1
WireConnection;100;1;97;2
WireConnection;126;0;132;0
WireConnection;101;0;100;0
WireConnection;101;1;105;0
WireConnection;122;1;126;0
WireConnection;122;2;128;0
WireConnection;49;0;58;0
WireConnection;115;0;122;0
WireConnection;115;1;116;0
WireConnection;115;2;130;0
WireConnection;104;0;105;0
WireConnection;104;1;101;0
WireConnection;104;2;106;0
WireConnection;54;0;49;0
WireConnection;111;0;104;0
WireConnection;133;0;115;0
WireConnection;60;0;54;0
WireConnection;60;1;61;0
WireConnection;56;0;60;0
WireConnection;30;0;73;0
WireConnection;30;3;29;1
WireConnection;30;4;29;2
WireConnection;4;0;3;0
WireConnection;4;1;67;0
WireConnection;78;0;56;0
WireConnection;26;0;1;0
WireConnection;26;1;30;0
WireConnection;71;0;4;0
WireConnection;31;2;32;0
WireConnection;93;0;26;0
WireConnection;55;0;93;0
WireConnection;55;1;79;0
WireConnection;46;0;31;0
WireConnection;46;1;74;0
WireConnection;64;0;63;0
WireConnection;64;1;68;0
WireConnection;84;0;55;0
WireConnection;81;0;46;0
WireConnection;70;0;64;0
WireConnection;0;0;85;0
WireConnection;0;1;75;0
WireConnection;0;2;82;0
WireConnection;0;4;2;0
WireConnection;0;11;134;0
ASEEND*/
//CHKSM=9538E4F3CA8835954E13B3194CCA8CE1892A67C2