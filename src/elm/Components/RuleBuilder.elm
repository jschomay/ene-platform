module Components.RuleBuilder exposing (..)

import PlatformTypes exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Textfield as Textfield
import Material.Options as Options
import Material


view : Material.Model -> String -> Component -> Html Msg
view mdl componentName component =
    let
        updateFn newVal f =
            case component of
                RuleBuilder a ->
                    RuleBuilder <| f a

                _ ->
                    component

        updateAThing newVal =
            updateFn newVal (\a -> { a | interactionMatcher = newVal })

        componentId interactionMatcher =
            case interactionMatcher of
                With id ->
                    "interacting with " ++ id

                _ ->
                    "withanything matcher"
    in
        case component of
            RuleBuilder { interactionMatcher } ->
                div [ class "attributesEditor" ]
                    [ p [ class "attributesEditor__header" ] [ text "Rules component" ]
                    , div [ class "attributesEditor__item" ]
                        [ text <| componentId interactionMatcher ]
                    ]

            _ ->
                div [] []
