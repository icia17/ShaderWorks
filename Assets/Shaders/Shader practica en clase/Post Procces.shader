// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Post Procces"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Vector0("Vector 0", Vector) = (0.5,0.5,0,0)

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
			
			uniform float2 _Vector0;


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
				float grayscale3 = Luminance(0);
				float4 color11 = IsGammaSpace() ? float4(0.7735849,0.7735849,0.7735849,0) : float4(0.5600193,0.5600193,0.5600193,0);
				float2 texCoord5 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult14 = smoothstep( -1.0 , 1.0 , distance( texCoord5 , _Vector0 ));
				float lerpResult6 = lerp( grayscale3 , color11.r , ( 1.0 - smoothstepResult14 ));
				float4 temp_cast_1 = (lerpResult6).xxxx;
				

				finalColor = temp_cast_1;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
672;81;760;755;777.2441;139.5563;1.259201;True;False
Node;AmplifyShaderEditor.CommentaryNode;13;-957.3937,235.2038;Inherit;False;485.1677;425.5164;Vignette;3;9;5;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;9;-863.3212,499.2397;Inherit;False;Property;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-907.3937,285.2037;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;4;-645.2255,391.3885;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;2;-599.6154,-53.20346;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;14;-369.4968,344.7639;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;3;-299.6465,-3.455143;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;-61.84432,539.1072;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0.7735849,0.7735849,0.7735849,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;15;-136.3105,243.241;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;6;136.2646,-16.67421;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;387.9045,-13.63956;Float;False;True;-1;2;ASEMaterialInspector;0;2;Post Procces;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;4;0;5;0
WireConnection;4;1;9;0
WireConnection;14;0;4;0
WireConnection;3;0;2;0
WireConnection;15;0;14;0
WireConnection;6;0;3;0
WireConnection;6;1;11;1
WireConnection;6;2;15;0
WireConnection;0;0;6;0
ASEEND*/
//CHKSM=8241BD5F418EBDC5657A15B175D2ECA4B0FD38DE