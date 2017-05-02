module Components.RuleBuilder exposing (..)

import PlatformTypes exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Material.Textfield as Textfield
import Material.Options as Options
import Material
import Monocle.Prism exposing (Prism)
import Html.SelectPrism exposing (selectp)


updateCondition component v =
    let
        toCondition s =
            case s of
                "Item is in inventory" ->
                    [ ItemIsInInventory "" ]

                "Character is in location" ->
                    [ CharacterIsNotInLocation "" "" ]

                "Character is not in location" ->
                    [ CharacterIsNotInLocation "" "" ]

                _ ->
                    []
    in
        case component of
            RuleBuilder r ->
                RuleBuilder { r | conditions = toCondition v }

            _ ->
                component


conditionsView entityId componentName component =
    [ div [ class "attributesEditor__item" ]
        [ select
            [ onInput <| UpdateEntity entityId componentName (updateCondition component) ]
            [ option [] [ text "Item is in inventory" ]
            , option [] [ text "Character is in location" ]
            , option [] [ text "Character is not in location" ]
            ]
        ]
    ]



-- conditionOptions =
--     [ ( "Item is in inventory", ItemIsInInventory "" )
--     , ( "Character is in location", CharacterIsInLocation "" "" )
--     , ( "Character is not in location", CharacterIsNotInLocation "" "" )
--     ]


view : Material.Model -> String -> String -> Component -> Html Msg
view mdl entityId componentName component =
    let
        componentId interactionMatcher =
            case interactionMatcher of
                With id ->
                    "interacting with " ++ id

                _ ->
                    "withanything matcher"
    in
        case component of
            RuleBuilder { interactionMatcher } ->
                div [ class "attributesEditor" ] <|
                    [ p [ class "attributesEditor__header" ] [ text "Rules component" ]
                    , div [ class "attributesEditor__item" ]
                        [ text <| componentId interactionMatcher ]
                    ]
                        ++ conditionsView entityId componentName component

            _ ->
                div [] []
