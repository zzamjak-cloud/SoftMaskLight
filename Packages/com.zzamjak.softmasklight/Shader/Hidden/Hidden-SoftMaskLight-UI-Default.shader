// [OptionalShader] SoftMaskLight: UI/Default
// UI/Default 셰이더에 SoftMaskLight 마스킹을 항상 활성화한 Hidden 변형
Shader "Hidden/UI/Default (SoftMaskLight)"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        // UI 스텐실/마스크 설정
        [HideInInspector] _StencilComp ("Stencil Comparison", Float) = 8
        [HideInInspector] _Stencil ("Stencil ID", Float) = 0
        [HideInInspector] _StencilOp ("Stencil Operation", Float) = 0
        [HideInInspector] _StencilWriteMask ("Stencil Write Mask", Float) = 255
        [HideInInspector] _StencilReadMask ("Stencil Read Mask", Float) = 255
        [HideInInspector] _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0

        // RectMask2D: 기본값을 넓게 두어 미주입 시 전체가 사라지지 않게 함
        [HideInInspector] _ClipRect ("Clip Rect", Vector) = (-32767, -32767, 32767, 32767)

        // SoftMaskLight 프로퍼티
        [HideInInspector] _MaskTex ("Mask Texture", 2D) = "white" {}
        [HideInInspector] _SoftnessRcp ("Softness Rcp", Float) = 10
        [HideInInspector] _InvertMask ("Invert Mask", Float) = 0
        [HideInInspector] _MaskUVRect ("Mask UV Rect", Vector) = (0, 0, 1, 1)
        [HideInInspector] _MaskSliceBorder ("Mask Slice Border", Vector) = (0, 0, 1, 1)
        [HideInInspector] _MaskSliceInnerUV ("Mask Slice Inner UV", Vector) = (0, 0, 1, 1)
        [HideInInspector] _MaskSliceSlopeX ("Mask Slice Slope X", Vector) = (0, 1, 0, 0.9999)
        [HideInInspector] _MaskSliceSlopeY ("Mask Slice Slope Y", Vector) = (0, 1, 0, 0.9999)
        [HideInInspector] _MaskFillLineA ("Mask Fill Line A", Vector) = (0, 0, 1, 0)
        [HideInInspector] _MaskFillLineB ("Mask Fill Line B", Vector) = (0, 0, 1, 10000)
        [HideInInspector] _MaskTex2 ("Mask Texture 2", 2D) = "white" {}
        [HideInInspector] _SoftnessRcp2 ("Softness Rcp 2", Float) = 10
        [HideInInspector] _InvertMask2 ("Invert Mask 2", Float) = 0
        [HideInInspector] _MaskUVRect2 ("Mask UV Rect 2", Vector) = (0, 0, 1, 1)
        [HideInInspector] _MaskSliceBorder2 ("Mask Slice Border 2", Vector) = (0, 0, 1, 1)
        [HideInInspector] _MaskSliceInnerUV2 ("Mask Slice Inner UV 2", Vector) = (0, 0, 1, 1)
        [HideInInspector] _MaskSliceSlopeX2 ("Mask Slice Slope X 2", Vector) = (0, 1, 0, 0.9999)
        [HideInInspector] _MaskSliceSlopeY2 ("Mask Slice Slope Y 2", Vector) = (0, 1, 0, 0.9999)
        [HideInInspector] _MaskFillLineA2 ("Mask Fill Line A 2", Vector) = (0, 0, 1, 0)
        [HideInInspector] _MaskFillLineB2 ("Mask Fill Line B 2", Vector) = (0, 0, 1, 10000)
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask [_ColorMask]

        Pass
        {
            Name "Default"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP
            // _CAT_SOFTMASK multi_compile 없음 (항상 활성)
            #pragma multi_compile_local _ _SOFTMASK_NESTED
            #pragma multi_compile_local _ _SOFTMASK_SLICE

            // SoftMaskLight 항상 활성화
            #define _CAT_SOFTMASK 1
            #include "../SoftMaskLight_Core.cginc"

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"
            #include "../SoftMaskLight_UIClip.cginc"

            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex        : SV_POSITION;
                fixed4 color         : COLOR;
                float2 texcoord      : TEXCOORD0;
                CAT_UI_CLIP_COORDS(1)
                CAT_SOFTMASK_COORDS(2, 3)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _MainTex_ST;
            int _UIVertexColorAlwaysGammaSpace;

            v2f vert(appdata_t v)
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
                OUT.vertex = UnityObjectToClipPos(v.vertex);
                OUT.uiClipMask = CAT_UI_ComputeClipMask(OUT.vertex, v.vertex.xy);
                OUT.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

                if (_UIVertexColorAlwaysGammaSpace)
                {
                    if (!IsGammaSpace())
                        v.color.rgb = GammaToLinearSpace(v.color.rgb);
                }
                OUT.color = v.color * _Color;

                // SoftMaskLight 버텍스 처리 (항상 활성)
                CAT_SOFTMASK_VERT(v.vertex.xyz, OUT)
                return OUT;
            }

            half4 frag(v2f IN) : SV_Target
            {
                half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;

                CAT_UI_ApplyClipRect(color, IN.uiClipMask);

                // SoftMaskLight 적용 (항상 활성)
                color.a *= CAT_SOFTMASK_FRAG(IN);

                #ifdef UNITY_UI_ALPHACLIP
                clip(color.a - 0.001);
                #endif

                return color;
            }
            ENDCG
        }
    }
}
