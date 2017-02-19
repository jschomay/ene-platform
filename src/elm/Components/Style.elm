module Components.Style exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onBlur)


view : String -> Component -> Html Msg
view componentName component =
    let
        updateSelector newVal =
            updateFn newVal (\a -> { a | selector = newVal })

        updateFn newVal f =
            case component of
                Style a ->
                    Style <| f a

                _ ->
                    component
    in
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
                                UpdateEditor componentName updateSelector
                            , onBlur SaveEntity
                            ]
                            []
                        ]
                    ]

            _ ->
                div [] []
