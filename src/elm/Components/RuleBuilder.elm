module Components.RuleBuilder exposing (..)

import PlatformTypes exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Textfield as Textfield
import Material.Options as Options
import Material


selectForItems =
    [ select [ onInput UpdateCondition ] [ option [ value "Fdsfd" ] [ text "Fdsfd" ] ] ]


conditionOptions =
    [ ( "itemIsInInventory", selectForItems, (\args -> ItemIsInInventory args), (\model -> model.items) )
    , ( "characterIsInLocation", (\character location -> CharacterIsInLocation character location), (\model -> model.characters) )
    ]



-- ,characterIsNotInLocation String String
-- ,currentLocationIs String
-- ,currentLocationIsNot String
-- ,itemIsInLocation String String
-- ,itemIsNotInInventory String
-- ,itemIsNotInLocation String String
-- ,hasPreviouslyInteractedWith String
-- ,hasNotPreviouslyInteractedWith String
-- ,currentSceneIs String


conditionsView =
    [ div [ class "attributesEditor__item" ]
        [ select [] [ option [ value "blah" ] [ text "blah" ] ]
        ]
    ]


view : Material.Model -> String -> Component -> Html Msg
view mdl componentName component =
    let
        updateFn newVal f =
            case component of
                RuleBuilder a ->
                    RuleBuilder <| f a

                _ ->
                    component

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
                        ++ conditionsView

            _ ->
                div [] []
