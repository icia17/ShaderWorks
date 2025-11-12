// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BloomFilmShader"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_MaxWeights("Max Weights", Float) = 0.3
		_NoiseOscillationFrequency("Noise Oscillation Frequency", Range( 0 , 10)) = 1
		_NoiseSpeed("Noise Speed", Range( 0 , 10)) = 1
		_NoiseScale("Noise Scale", Range( 0 , 100)) = 35
		_BloomBrightness("Bloom Brightness", Range( 0 , 1)) = 0.25
		_BloomStepLimit("Bloom Step Limit", Range( 0 , 1)) = 0.3
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _NoiseOscillationFrequency;
			uniform float _MaxWeights;
			uniform float _NoiseSpeed;
			uniform float _NoiseScale;
			uniform float _BloomStepLimit;
			uniform float _BloomBrightness;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float mulTime17 = _Time.y * _NoiseOscillationFrequency;
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float mulTime13 = _Time.y * _NoiseSpeed;
				float2 temp_cast_0 = (mulTime13).xx;
				float dotResult4_g1 = dot( temp_cast_0 , float2( 12.9898,78.233 ) );
				float lerpResult10_g1 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g1 ) * 43758.55 ) ));
				float2 temp_cast_1 = (lerpResult10_g1).xx;
				float2 texCoord11 = i.uv.xy * temp_cast_1 + float2( 0,0 );
				float simplePerlin2D10 = snoise( texCoord11*_NoiseScale );
				simplePerlin2D10 = simplePerlin2D10*0.5 + 0.5;
				float4 temp_cast_2 = (simplePerlin2D10).xxxx;
				float layeredBlendVar12 = (0.0 + (saturate( sin( mulTime17 ) ) - 0.0) * (_MaxWeights - 0.0) / (1.0 - 0.0));
				float4 layeredBlend12 = ( lerp( tex2D( _MainTex, uv_MainTex ),temp_cast_2 , layeredBlendVar12 ) );
				float4 color32 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
				float smoothstepResult49 = smoothstep( 0.0 , _BloomStepLimit , ( 1.0 - (0.0 + (distance( layeredBlend12 , color32 ) - 0.0) * (1.0 - 0.0) / (2.0 - 0.0)) ));
				

				finalColor = ( layeredBlend12 + saturate( ( smoothstepResult49 * _BloomBrightness ) ) );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
435;73;990;604;1513.067;177.676;1.3;False;False
Node;AmplifyShaderEditor.RangedFloatNode;20;-1187.29,-170.0064;Inherit;False;Property;_NoiseOscillationFrequency;Noise Oscillation Frequency;1;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1401.931,318.3389;Inherit;False;Property;_NoiseSpeed;Noise Speed;2;0;Create;True;0;0;0;False;0;False;1;0.1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;13;-1123.937,318.455;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;17;-917.253,-164.4411;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;15;-756.7259,-164.3665;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;14;-913.184,304.5473;Inherit;False;Random Range;-1;;1;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-657.6118,-73.63789;Inherit;False;Property;_MaxWeights;Max Weights;0;0;Create;True;0;0;0;False;0;False;0.3;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;29;-891.1942,24.78689;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-785.1305,436.7389;Inherit;False;Property;_NoiseScale;Noise Scale;3;0;Create;True;0;0;0;False;0;False;35;45;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;21;-636.9259,-163.7868;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-720.5803,227.9326;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;18;-470.4844,-162.1711;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-582.3228,19.25981;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;46;-183.9199,284.7147;Inherit;False;1302.53;461.1007;Bloom, mientras el color de la imagen mas se asemeja a un blanco puro, entonces agregale MAS BLANCO!;9;32;33;39;40;45;34;27;42;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;10;-480.0803,222.7325;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.LayeredBlendNode;12;-210.2959,2.226482;Inherit;False;6;0;FLOAT;0.3;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;32;-133.9199,405.0667;Inherit;False;Constant;_White;White;5;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;33;74.0622,343.5509;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;39;233.8566,334.7147;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;435.1373,357.9841;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;284.8111,521.8041;Inherit;False;Property;_BloomStepLimit;Bloom Step Limit;5;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;479.8815,629.8154;Inherit;False;Property;_BloomBrightness;Bloom Brightness;4;0;Create;True;0;0;0;False;0;False;0.25;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;49;630.5347,411.8356;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;809.5542,418.8769;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;42;953.6103,417.6622;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;1139.151,-0.2097797;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;28;1425.677,-2.257451;Float;False;True;-1;2;ASEMaterialInspector;0;2;BloomFilmShader;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;13;0;23;0
WireConnection;17;0;20;0
WireConnection;15;0;17;0
WireConnection;14;1;13;0
WireConnection;21;0;15;0
WireConnection;11;0;14;0
WireConnection;18;0;21;0
WireConnection;18;4;19;0
WireConnection;5;0;29;0
WireConnection;10;0;11;0
WireConnection;10;1;22;0
WireConnection;12;0;18;0
WireConnection;12;1;5;0
WireConnection;12;2;10;0
WireConnection;33;0;12;0
WireConnection;33;1;32;0
WireConnection;39;0;33;0
WireConnection;40;0;39;0
WireConnection;49;0;40;0
WireConnection;49;2;45;0
WireConnection;34;0;49;0
WireConnection;34;1;27;0
WireConnection;42;0;34;0
WireConnection;31;0;12;0
WireConnection;31;1;42;0
WireConnection;28;0;31;0
ASEEND*/
//CHKSM=C1F4D6DF4EC6B47A86E169EB94B3C65D8494924A