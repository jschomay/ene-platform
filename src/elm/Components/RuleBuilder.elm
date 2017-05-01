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


-- updateCondition component v =
--     let
--         toCondition s =
--             case s of
--                 "Item is in inventory" ->
--                     [ ItemIsInInventory "" ]
--                 "Character is in location" ->
--                     [ CharacterIsNotInLocation "" "" ]
--                 "Character is not in location" ->
--                     [ CharacterIsNotInLocation "" "" ]
--                 _ ->
--                     []
--     in
--         case component of
--             RuleBuilder r ->
--                 RuleBuilder { r | conditions = toCondition v }
--             _ ->
--                 component
-- see http://package.elm-lang.org/packages/toastal/select-prism/1.0.1


conditionsView rule component =
    [ div [ class "attributesEditor__item" ]
        [ selectp conditionPrism (UpdateRuleConditions rule) (ItemIsInInventory "") [] conditionOptions ]
      -- [ select
      -- [ onInput <| UpdateRule rule (updateCondition component) ]
      -- [ option [] [ text "Item is in inventory" ]
      -- , option [] [ text "Character is in location" ]
      -- , option [] [ text "Character is not in location" ]
      -- ]
      -- ]
    ]


conditionOptions =
    [ ( "Item is in inventory", ItemIsInInventory "" )
    , ( "Character is in location", CharacterIsInLocation "" "" )
    , ( "Character is not in location", CharacterIsNotInLocation "" "" )
    ]


conditionPrism =
    let
        conditionFromString : String -> Maybe Condition
        conditionFromString s =
            case s of
                "Item is in inventory" ->
                    Just <| ItemIsInInventory ""

                "Character is in location" ->
                    Just <| CharacterIsNotInLocation "" ""

                "Character is not in location" ->
                    Just <| CharacterIsNotInLocation "" ""

                _ ->
                    Nothing

        conditionToString : Condition -> String
        conditionToString c =
            case c of
                ItemIsInInventory _ ->
                    "Item is in inventory"

                CharacterIsInLocation _ _ ->
                    "Character is in location"

                CharacterIsNotInLocation _ _ ->
                    "Character is not in location"
    in
        Prism conditionFromString conditionToString


view : Material.Model -> String -> Component -> Html Msg
view mdl componentName component =
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
                        ++ conditionsView "TODO get rule id here" component

            _ ->
                div [] []
