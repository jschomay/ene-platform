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
import Html.Events exposing (onInput, onClick)
import Types exposing (..)
import Component


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
        submitButton =
            case Dict.size components of
                0 ->
                    []

                _ ->
                    [ button [ onClick SaveEntity ] [ text "submit" ] ]
    in
        addComponentView components
            :: (Dict.values <|
                    Dict.map Component.view components
               )
            ++ submitButton


addComponentView : Components -> Html Msg
addComponentView existingComponents =
    let
        availableComponents =
            Component.getAvailableComponents existingComponents

        addComponentRenderer ( name, component ) =
            div []
                [ button
                    [ onClick <|
                        AddComponent name component
                    ]
                    [ text <| "add " ++ name ]
                ]
    in
        Dict.toList availableComponents
            |> List.map addComponentRenderer
            |> div [ class "addComponent" ]


newEntityId : TabName -> Int -> String
newEntityId tabName newId =
    toString tabName
        |> String.dropRight 3
        |> String.toLower
        |> (flip (++)) (toString newId)



-- some more data we need there: 1. list of entities the component belongs to
--                               2. Whether its default or can be deleted
-- then allAvaialbleComponents can filter out by entity that it belongs to?
