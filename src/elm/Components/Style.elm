module Components.Style exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


view : String -> Component -> Html Msg
view componentName component =
    case component of
        Style { selector } ->
            div [ class "attributesEditor" ]
                [ div [ class "attributesEditor__item" ]
                    [ label
                        [ for "selector-input"
                        , class "Components__Attributes--label"
                        ]
                        [ text "CSS Selector"
                        ]
                    , input
                        [ id "selector-input"
                        , class "Components__Attributes--input"
                        , value selector
                        , onInput <|
                            UpdateEditor componentName
                                component
                                (\newVal component ->
                                    case component of
                                        Style attributes ->
                                            Style { attributes | selector = newVal }

                                        _ ->
                                            component
                                )
                        ]
                        []
                    ]
                ]

        _ ->
            div [] []
