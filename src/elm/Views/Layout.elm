module Views.Layout exposing (..)

import PlatformTypes exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Entity
import Tabs
import Dict exposing (Dict)
import Http exposing (encodeUri)
import Material.Grid as Grid
import Material.Layout as Layout
import Material.Tabs as MdlTabs
import Material.Options as Options
import Material.Elevation as Elevation
import Material.Button as Button
import Material


view :
    { mdl : Material.Model
    , activeTab : TabName
    , exportJson : String
    , items : Dict String Entity
    , focusedEntity :
        Maybe
            { entityId : String
            , editor : Components
            , entityClass : EntityClasses
            , showingComponents : Bool
            }
    }
    -> Html Msg
view { mdl, activeTab, exportJson, items, focusedEntity } =
    let
        activeTabIdx =
            Tabs.tabToIndex activeTab

        drawer =
            [ Layout.title [] [ text "ENE Platform" ]
            , Layout.navigation
                []
                [ Layout.link
                    [ Layout.href <| "data:text/plain;charset=utf-8," ++ encodeUri exportJson
                    , Options.attribute <| downloadAs "export.json"
                    ]
                    [ text "Export" ]
                ]
            ]

        grid =
            Grid.grid [ Options.css "justify-content" "space-around" ]
                [ Grid.cell [ Grid.size Grid.All 6 ]
                    [ div [ class "editor__header" ] <| headerView mdl activeTabIdx items focusedEntity
                    ]
                ]
    in
        Layout.render Mdl
            mdl
            [ Layout.fixedHeader ]
            { header = [ text "" ]
            , drawer = drawer
            , tabs = ( [], [] )
            , main = [ grid ]
            }


headerView :
    Material.Model
    -> Int
    -> Dict String Entity
    -> Maybe
        { entityId : String
        , entityClass : EntityClasses
        , editor : Components
        , showingComponents : Bool
        }
    -> List (Html Msg)
headerView mdl activeTab items focusedEntity =
    let
        tabContent =
            Tabs.render mdl activeTab items focusedEntity
    in
        [ MdlTabs.render Mdl
            [ 0 ]
            mdl
            [ MdlTabs.activeTab activeTab
            , MdlTabs.onSelectTab ChangeActiveTab
            ]
            tabContent
            [ Options.div
                [ Options.css "margin" "24px auto"
                , Options.css "flex-direction" "column"
                , Options.css "flex" "1 1 0"
                ]
              <|
                accordionView mdl items focusedEntity
            ]
        ]


accordionView :
    Material.Model
    -> Dict String Entity
    -> Maybe
        { entityId : String
        , editor : Components
        , entityClass : EntityClasses
        , showingComponents : Bool
        }
    -> List (Html Msg)
accordionView mdl entities focusedEntity =
    let
        focusedEntityId =
            Maybe.withDefault
                { entityId = "", entityClass = Item, editor = Dict.empty, showingComponents = False }
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

        editorView id =
            case focusedEntity of
                Nothing ->
                    [ div [] [ text "nothing here" ] ]

                Just { entityId, editor, entityClass, showingComponents } ->
                    Entity.editorView mdl entityClass editor showingComponents

        clickEvent id =
            if id == focusedEntityId then
                UnfocusEntity
            else
                ChangeFocusedEntity id

        accordionItem ( id, entity ) =
            div [ class "entity" ]
                [ div
                    [ buttonClasses "accordionButton" id
                    , onClick <| clickEvent id
                    ]
                    [ text <| Entity.entityTitle id entity ++ " (id: " ++ id ++ ")" ]
                , Options.div
                    [ panelClass "accordionPanel" id
                    , Elevation.e6
                    ]
                    (editorView id)
                ]

        accordionItems =
            entities
                |> Dict.toList
                |> List.map accordionItem

        newItem =
            [ div [ class "entity" ]
                [ Button.render Mdl
                    [ 0 ]
                    mdl
                    [ Button.colored
                    , Options.onClick NewEntity
                    ]
                    [ text "Add New" ]
                ]
            ]
    in
        accordionItems ++ newItem
