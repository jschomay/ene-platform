module Entity
    exposing
        ( empty
        , init
        , update
        , getComponents
        , editorView
        , newEntityId
        , entityTitle
        )

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Component
import Material.Menu as Menu
import Material


empty : EntityClasses -> Entity
empty entity =
    Entity <| Component.getDefaultComponentsFor entity


init : EntityClasses -> Components -> Entity
init entity components =
    update (empty entity) components


update : Entity -> Components -> Entity
update (Entity oldComponents) newComponents =
    -- Note, newComponents MUST be first!
    Entity <| Dict.union newComponents oldComponents


getComponents : Entity -> Components
getComponents (Entity components) =
    components



-- TODO: test the update editor functions


editorView : Material.Model -> Components -> Bool -> List (Html Msg)
editorView mdl components showingComponents =
    let
        availableComponents =
            Component.getAvailableComponents components

        componentOptionClasses =
            classList [ ( "addComponent__item", True ), ( "addComponent__item--visible", showingComponents ) ]

        addComponentView =
            let
                addComponentRenderer ( name, component ) =
                    Menu.item
                        [ Menu.onSelect <| AddComponent name ]
                        [ text name ]
            in
                Dict.toList availableComponents
                    |> List.map addComponentRenderer
                    |> \menuItems ->
                        div [ class "addComponent" ]
                            [ span [] []
                            , Menu.render Mdl [ 0 ] mdl [ Menu.topRight ] menuItems
                            ]

        componentDropdown =
            if Dict.size availableComponents > 0 then
                addComponentView
            else
                div [] []
    in
        (Dict.values <|
            Dict.map (Component.view mdl) components
        )
            ++ [ componentDropdown ]


newEntityId : TabName -> Int -> String
newEntityId tabName newId =
    toString tabName
        |> String.dropRight 3
        |> String.toLower
        |> (flip (++)) (toString newId)


entityTitle : String -> Entity -> String
entityTitle defaultTitle entity =
    getComponents entity
        |> Component.getTitle
        |> Maybe.withDefault defaultTitle
