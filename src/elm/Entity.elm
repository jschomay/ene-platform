module Entity
    exposing
        ( empty
        , init
        , update
        , getComponents
        , editorView
        , newEntityId
        )

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, on, targetValue)
import Types exposing (..)
import Component
import Json.Decode as Decode


empty : Entity
empty =
    Entity Dict.empty


init : Components -> Entity
init components =
    update empty components


update : Entity -> Components -> Entity
update (Entity oldComponents) newComponents =
    -- Note, newComponents MUST be first!
    Entity <| Dict.union newComponents oldComponents


getComponents : Entity -> Components
getComponents (Entity components) =
    components



-- TODO: test the update editor functions


editorView : Components -> List (Html Msg)
editorView components =
    let
        availableComponents =
            Component.getAvailableComponents components

        onSelect =
            -- becuase of https://github.com/elm-lang/html/issues/71
            on "change" (Decode.map AddComponent Html.Events.targetValue)

        addComponentView =
            let
                addComponentRenderer ( name, component ) =
                    option [ value name ] [ text name ]
            in
                Dict.toList availableComponents
                    |> List.map addComponentRenderer
                    |> (::) (option [ selected True, value "" ] [ text "Add Component " ])
                    |> select [ onSelect, class "addComponent" ]

        componentDropdown =
            if Dict.size availableComponents > 0 then
                addComponentView
            else
                div [] []
    in
        componentDropdown
            :: (Dict.values <|
                    Dict.map Component.view components
               )


newEntityId : TabName -> Int -> String
newEntityId tabName newId =
    toString tabName
        |> String.dropRight 3
        |> String.toLower
        |> (flip (++)) (toString newId)



-- some more data we need there: 1. list of entities the component belongs to
--                               2. Whether its default or can be deleted
-- then allAvaialbleComponents can filter out by entity that it belongs to?
