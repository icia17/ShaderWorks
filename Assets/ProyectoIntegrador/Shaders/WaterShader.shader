// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/WaterShader"
{
	Properties
	{
		_WaveSpeed("Wave Speed", Float) = 1
		_WaveDirection("Wave Direction", Vector) = (1,0,1,0)
		_Texture0("Texture 0", 2D) = "white" {}
		_TextureTIlling("Texture TIlling ", Vector) = (1.5,1.5,0,0)
		_WaterNormalTexture("Water Normal Texture", 2D) = "white" {}
		_WaterNoiseTexture("Water Noise Texture", 2D) = "white" {}
		_DistortionWeight("Distortion Weight", Range( 0 , 1)) = 0
		_WaterColor("Water Color", Color) = (0,0.6418293,0.8773585,0)
		_DarkLightWater("Dark/Light Water", Vector) = (1,5,0,0)
		_WaterHeightspeed("Water Height speed", Float) = 1
		_WaterVoronoiScale("Water Voronoi Scale", Float) = 30
		_WaterOffsetY("Water Offset Y", Float) = 10
		_FresnelStrength("FresnelStrength", Range( 0 , 1)) = 0
		_FoamDistance("FoamDistance", Range( 0 , 5)) = 1
		_FoamStregth("FoamStregth", Float) = 0
		_WaterSmoothness("Water Smoothness", Range( 0 , 1)) = 0
		_WaterOpacity("Water Opacity", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
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
		uniform float _WaterHeightspeed;
		uniform float _WaterOffsetY;
		uniform sampler2D _WaterNormalTexture;
		uniform float2 _TextureTIlling;
		uniform float _WaveSpeed;
		uniform float3 _WaveDirection;
		uniform sampler2D _Texture0;
		uniform float4 _Texture0_ST;
		uniform float _DistortionWeight;
		uniform float4 _WaterColor;
		uniform float2 _DarkLightWater;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FoamDistance;
		uniform float _FoamStregth;
		uniform float _FresnelStrength;
		uniform sampler2D _WaterNoiseTexture;
		uniform float _WaterSmoothness;
		uniform float _WaterOpacity;


		float2 voronoihash46( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi46( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash46( n + g );
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime44 = _Time.y * _WaterHeightspeed;
			float time46 = mulTime44;
			float2 coords46 = v.texcoord.xy * _WaterVoronoiScale;
			float2 id46 = 0;
			float2 uv46 = 0;
			float voroi46 = voronoi46( coords46, time46, id46, uv46, 0 );
			float4 VoronoiWaterTex50 = ( voroi46 * float4(0,1,0,0) * _WaterOffsetY );
			v.vertex.xyz += VoronoiWaterTex50.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime2 = _Time.y * _WaveSpeed;
			float3 normalizeResult3 = normalize( _WaveDirection );
			float2 uv_TexCoord7 = i.uv_texcoord * _TextureTIlling + ( mulTime2 * normalizeResult3 ).xy;
			float2 UVMovement8 = uv_TexCoord7;
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float4 tex2DNode12 = tex2D( _Texture0, uv_Texture0 );
			float4 appendResult13 = (float4(tex2DNode12.r , tex2DNode12.g , 0.0 , 0.0));
			float4 lerpResult16 = lerp( float4( UVMovement8, 0.0 , 0.0 ) , ( appendResult13 + float4( UVMovement8, 0.0 , 0.0 ) ) , _DistortionWeight);
			float4 DisortedUVMov18 = lerpResult16;
			float4 NormalTex23 = tex2D( _WaterNormalTexture, DisortedUVMov18.xy );
			o.Normal = NormalTex23.rgb;
			float mulTime44 = _Time.y * _WaterHeightspeed;
			float time46 = mulTime44;
			float2 coords46 = i.uv_texcoord * _WaterVoronoiScale;
			float2 id46 = 0;
			float2 uv46 = 0;
			float voroi46 = voronoi46( coords46, time46, id46, uv46, 0 );
			float4 VoronoiWaterTex50 = ( voroi46 * float4(0,1,0,0) * _WaterOffsetY );
			float4 temp_cast_5 = (_DarkLightWater.x).xxxx;
			float4 temp_cast_6 = (_DarkLightWater.y).xxxx;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth59 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth59 = abs( ( screenDepth59 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _FoamDistance ) );
			float FoamValue64 = saturate( ( ( 1.0 - distanceDepth59 ) * _FoamStregth ) );
			float4 WaterColor40 = ( saturate( ( _WaterColor * (temp_cast_5 + (VoronoiWaterTex50 - float4( 0,0,0,0 )) * (temp_cast_6 - temp_cast_5) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) ) ) + FoamValue64 );
			o.Albedo = WaterColor40.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV53 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode53 = ( 0.0 + _FresnelStrength * pow( 1.0 - fresnelNdotV53, 5.0 ) );
			float4 NoiseTex30 = tex2D( _WaterNoiseTexture, DisortedUVMov18.xy );
			float4 FresnelVal56 = ( fresnelNode53 * NoiseTex30 );
			o.Emission = FresnelVal56.rgb;
			o.Smoothness = _WaterSmoothness;
			o.Alpha = _WaterOpacity;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				vertexDataFunc( v, customInputData );
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
1136;73;343;524;2210.633;5.458252;2.874644;False;False
Node;AmplifyShaderEditor.CommentaryNode;9;-1195.896,-973.9551;Inherit;False;1272.335;484.8524;UV Movement;8;1;2;3;4;5;7;8;6;;0.05842829,0.8331259,0.9528302,1;0;0
Node;AmplifyShaderEditor.Vector3Node;4;-1145.896,-677.1027;Inherit;False;Property;_WaveDirection;Wave Direction;1;0;Create;True;0;0;0;False;0;False;1,0,1;-1,0,-0.05;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1;-1106.479,-839.5221;Inherit;False;Property;_WaveSpeed;Wave Speed;0;0;Create;True;0;0;0;False;0;False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;3;-883.7909,-671.3591;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-902.9175,-839.8439;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;19;-1237.421,-328.6209;Inherit;False;1510.103;479.8169;Wave Disroted;8;14;15;16;18;17;13;12;10;;0.4150943,0.03328587,0.3153529,1;0;0
Node;AmplifyShaderEditor.Vector2Node;6;-682.2633,-923.9551;Inherit;False;Property;_TextureTIlling;Texture TIlling ;3;0;Create;True;0;0;0;False;0;False;1.5,1.5;6,6;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-697.8955,-753.1027;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;51;-1852.996,982.8837;Inherit;False;1189.129;394;Voronoi ;8;43;46;44;45;50;49;47;48;;0.5849056,0.4051798,0.1020826,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-468.36,-817.3359;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;10;-1187.421,-272.0701;Inherit;True;Property;_Texture0;Texture 0;2;0;Create;True;0;0;0;False;0;False;2318775c5cee59b40bacb79fa5fd4571;2318775c5cee59b40bacb79fa5fd4571;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;12;-947.0829,-278.6209;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-1802.996,1060.671;Inherit;False;Property;_WaterHeightspeed;Water Height speed;9;0;Create;True;0;0;0;False;0;False;1;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-147.5603,-820.813;Inherit;False;UVMovement;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-592.7079,-249.2438;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1756.866,1172.884;Inherit;False;Property;_WaterVoronoiScale;Water Voronoi Scale;10;0;Create;True;0;0;0;False;0;False;30;20.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;44;-1579.866,1041.884;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-922.3519,-26.02139;Inherit;False;8;UVMovement;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;65;-606.9724,1356.049;Inherit;False;1446.17;297;Foam;7;58;59;62;64;63;61;60;;0.3948356,0.7075472,0.02336242,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-646.0314,35.196;Inherit;False;Property;_DistortionWeight;Distortion Weight;6;0;Create;True;0;0;0;False;0;False;0;0.375;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-556.9724,1421.291;Inherit;False;Property;_FoamDistance;FoamDistance;13;0;Create;True;0;0;0;False;0;False;1;0.73;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-363.2554,-160.6669;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1182.866,1232.884;Inherit;False;Property;_WaterOffsetY;Water Offset Y;11;0;Create;True;0;0;0;False;0;False;10;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;47;-1374.866,1164.884;Inherit;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;46;-1361.866,1032.884;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.LerpOp;16;-201.2165,-52.54245;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DepthFade;59;-236.7479,1406.049;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1099.867,1075.884;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;43.68219,-25.02212;Inherit;False;DisortedUVMov;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;29;-1844.443,349.68;Inherit;False;1113.642;510.5858;Tex Settings;8;23;21;22;20;25;26;27;30;;0.8490566,0.6447907,0.1642043,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;62;26.25224,1537.049;Inherit;False;Property;_FoamStregth;FoamStregth;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;60;25.38068,1416.003;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;42;-590.3685,348.8975;Inherit;False;1497;461.1459;Water Color;9;32;33;37;39;40;36;35;34;41;;0,0.08953232,0.745283,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-902.8667,1085.884;Inherit;False;VoronoiWaterTex;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-398.7963,585.0082;Inherit;False;50;VoronoiWaterTex;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;25;-1794.443,626.5523;Inherit;True;Property;_WaterNoiseTexture;Water Noise Texture;5;0;Create;True;0;0;0;False;0;False;23602af1a02907c4a997741e2cd21321;23602af1a02907c4a997741e2cd21321;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector2Node;35;-374.8924,666.043;Inherit;False;Property;_DarkLightWater;Dark/Light Water;8;0;Create;True;0;0;0;False;0;False;1,5;0.5,0.88;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;222.6559,1413.912;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-1572.072,713.8452;Inherit;False;18;DisortedUVMov;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;63;408.0595,1410.223;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;57;-558.8627,882.3535;Inherit;False;1140.173;414;Fresnel;5;52;53;54;55;56;;0.5754717,0.04071733,0.4248191,1;0;0
Node;AmplifyShaderEditor.ColorNode;32;-540.3687,398.8975;Inherit;False;Property;_WaterColor;Water Color;7;0;Create;True;0;0;0;False;0;False;0,0.6418293,0.8773585,0;0,0.6418293,0.8773585,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-1384.973,630.2658;Inherit;True;Property;_TextureSample2;Texture Sample 2;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;36;-151.0262,532.4907;Inherit;False;5;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,1,1,1;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;1,1,1,1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;41.63112,414.8975;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-947.1115,676.7802;Inherit;False;NoiseTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-508.8626,990.611;Inherit;False;Property;_FresnelStrength;FresnelStrength;12;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;615.1974,1436.361;Inherit;False;FoamValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-88.69006,1180.354;Inherit;False;30;NoiseTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;53;-122.6901,932.3535;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-1552.605,499.2485;Inherit;False;18;DisortedUVMov;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;225.3339,510.2345;Inherit;False;64;FoamValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;20;-1791.714,399.68;Inherit;True;Property;_WaterNormalTexture;Water Normal Texture;4;0;Create;True;0;0;0;False;0;False;26caa126227e12444823b4ddc5e8249b;24c6819a01b88be4b9931b96a3b8c48b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SaturateNode;37;249.6313,410.8975;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;460.6312,408.8975;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;165.3099,963.3535;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;21;-1313.244,402.3935;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;682.6312,417.8975;Inherit;False;WaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;357.3099,984.3535;Inherit;False;FresnelVal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-1008.072,423.8452;Inherit;False;NormalTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;72;1143.978,406.7433;Inherit;False;Property;_WaterOpacity;Water Opacity;16;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;1097.978,52.74326;Inherit;False;40;WaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;1107.978,132.7433;Inherit;False;23;NormalTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;1103.978,225.7433;Inherit;False;56;FresnelVal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;71;1159.978,315.7433;Inherit;False;Property;_WaterSmoothness;Water Smoothness;15;0;Create;True;0;0;0;False;0;False;0;0.545;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;1168.978,511.7433;Inherit;False;50;VoronoiWaterTex;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1416.564,107.9064;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Custom/WaterShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;4;0
WireConnection;2;0;1;0
WireConnection;5;0;2;0
WireConnection;5;1;3;0
WireConnection;7;0;6;0
WireConnection;7;1;5;0
WireConnection;12;0;10;0
WireConnection;8;0;7;0
WireConnection;13;0;12;1
WireConnection;13;1;12;2
WireConnection;44;0;43;0
WireConnection;15;0;13;0
WireConnection;15;1;14;0
WireConnection;46;1;44;0
WireConnection;46;2;45;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;16;2;17;0
WireConnection;59;0;58;0
WireConnection;49;0;46;0
WireConnection;49;1;47;0
WireConnection;49;2;48;0
WireConnection;18;0;16;0
WireConnection;60;0;59;0
WireConnection;50;0;49;0
WireConnection;61;0;60;0
WireConnection;61;1;62;0
WireConnection;63;0;61;0
WireConnection;26;0;25;0
WireConnection;26;1;27;0
WireConnection;36;0;34;0
WireConnection;36;3;35;1
WireConnection;36;4;35;2
WireConnection;33;0;32;0
WireConnection;33;1;36;0
WireConnection;30;0;26;0
WireConnection;64;0;63;0
WireConnection;53;2;52;0
WireConnection;37;0;33;0
WireConnection;39;0;37;0
WireConnection;39;1;41;0
WireConnection;55;0;53;0
WireConnection;55;1;54;0
WireConnection;21;0;20;0
WireConnection;21;1;22;0
WireConnection;40;0;39;0
WireConnection;56;0;55;0
WireConnection;23;0;21;0
WireConnection;0;0;66;0
WireConnection;0;1;67;0
WireConnection;0;2;68;0
WireConnection;0;4;71;0
WireConnection;0;9;72;0
WireConnection;0;11;70;0
ASEEND*/
//CHKSM=33E92549E40CD9D29FD3EF4732883706F5D84C5B