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
import Views.Accordian exposing (..)
import PlatformTypes exposing (..)
import Component
import Material.Menu as Menu
import Material.Button as Button
import Material.Options as Options
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


editorView : Material.Model -> String -> EntityClasses -> Components -> Bool -> List (Html Msg)
editorView mdl entityId entity components showingComponents =
    let
        availableComponents =
            Component.getAvailableComponents entity components

        componentOptionClasses =
            classList [ ( "addComponent__item", True ), ( "addComponent__item--visible", showingComponents ) ]

        addComponentView =
            let
                addComponentRenderer ( name, component ) =
                    Menu.item
                        [ Menu.onSelect <| AddComponent entityId name ]
                        [ text name ]
            in
                Dict.toList availableComponents
                    |> List.map addComponentRenderer
                    |> \menuItems ->
                        div [ class "addComponent" ]
                            [ span [] [ text "Add component" ]
                            , Menu.render Mdl [ 0 ] mdl [ Menu.bottomRight ] menuItems
                            ]

        componentDropdown =
            if Dict.size availableComponents > 0 then
                addComponentView
            else
                div [] []

        newItem =
            div [ class "entity" ]
                [ Button.render Mdl
                    [ 0 ]
                    mdl
                    [ Button.colored
                    , Options.onClick <| AddRule entityId
                    ]
                    [ text "Add Rule" ]
                ]

        associatedRules =
            --TODO need to get the real rules here...
            Dict.fromList [ ( "rule1", Entity Dict.empty ), ( "rule2", Entity Dict.empty ) ]

        rulesEl =
            div [ class "attributesEditor" ] <|
                [ p [] [ text <| "Rules for this " ++ toString entity ] ]
                    -- TODO need to pass in the focused rule somehow, also the collapse action needs to apply to the focused rule, not the focused entity
                    ++
                        (accordionView mdl associatedRules "my title" editorView newItem Nothing)
    in
        componentDropdown
            :: (Dict.values <| Dict.map (Component.view mdl entityId) components)
            ++ [ rulesEl ]



-- TODO
-- showing matching rules in item editor
-- restore titles
-- clean up accordian view signature?


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
        |> Maybe.withDefault "Unnamed"
