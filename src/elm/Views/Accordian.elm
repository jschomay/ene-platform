module Views.Accordian exposing (..)

import PlatformTypes exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)
import Material.Options as Options
import Material.Elevation as Elevation
import Material


accordionView :
    Material.Model
    -> Dict String Entity
    -> String
    -> (Material.Model -> String -> EntityClasses -> Components -> Bool -> List (Html Msg))
    -> Html Msg
    -> Maybe
        { entityId : String
        , entityClass : EntityClasses
        , showingComponents : Bool
        }
    -> List (Html Msg)
accordionView mdl entities title editorView newItem focusedEntity =
    let
        focusedEntityId =
            Maybe.withDefault
                { entityId = "", entityClass = Item, showingComponents = False }
                focusedEntity
                |> .entityId

        buttonClasses baseClass entityId =
            classList
                [ ( baseClass, True )
                , ( baseClass ++ "--active", entityId == focusedEntityId )
                ]

        panelClass baseClass entityId =
            if entityId == focusedEntityId then
                Options.cs <| baseClass ++ "--active"
            else
                Options.cs <| baseClass

        editorView_ { entityId, entityClass, showingComponents } =
            let
                components =
                    Dict.get entityId entities
                        |> Maybe.map (\(Entity components) -> components)
                        |> Maybe.withDefault Dict.empty
            in
                editorView mdl entityId entityClass components showingComponents

        clickEvent entityId =
            if entityId == focusedEntityId then
                UnfocusEntity
            else
                ChangeFocusedEntity entityId

        accordionItem ( entityId, entity ) =
            div [ class "entity" ]
                [ div
                    [ buttonClasses "accordionButton" entityId
                    , onClick <| clickEvent entityId
                    ]
                    -- [ text <| Entity.entityTitle entityId entity ++ " (id: " ++ entityId ++ ")" ]
                    [ text <| title ]
                , Options.div
                    [ panelClass "accordionPanel" entityId
                    , Elevation.e6
                    ]
                    (Maybe.map editorView_ focusedEntity |> Maybe.withDefault [])
                ]

        accordionItems =
            entities
                |> Dict.toList
                |> List.map accordionItem
    in
        accordionItems ++ [ newItem ]
