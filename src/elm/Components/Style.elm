module Components.Style exposing (..)

import PlatformTypes exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Textfield as Textfield
import Material.Options as Options
import Material


view : Material.Model -> String -> String -> Component -> Html Msg
view mdl entityId componentName component =
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
                    [ p [ class "attributesEditor__header" ] [ text "Style Component" ]
                    , div [ class "attributesEditor__item" ]
                        [ Textfield.render Mdl
                            [ 2 ]
                            mdl
                            [ Textfield.label "CSS Selector"
                            , Textfield.floatingLabel
                            , Textfield.value selector
                            , Options.onInput <| UpdateEntity entityId componentName updateSelector
                            ]
                            []
                        ]
                    ]

            _ ->
                div [] []
