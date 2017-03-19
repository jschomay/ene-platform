module Views.Layout exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Entity as Entity
import Dict exposing (Dict)
import Http exposing (encodeUri)
import Material.Grid exposing (..)
import Material.Tabs as Tabs
import Material.Options as Options
import Material.Icon as Icon
import Material.Elevation as Elevation
import Material.Button as Button
import Material


view : Material.Model -> TabName -> String -> Dict String Entity -> Maybe { entityId : String, editor : Components, showingComponents : Bool } -> Html Msg
view mdl activeTab exportJson items focusedEntity =
    let
        activeTabIdx =
            case activeTab of
                ItemsTab ->
                    0

                LocationsTab ->
                    1

                CharactersTab ->
                    2
    in
        grid [ Options.css "justify-content" "space-around" ]
            [ cell [ Material.Grid.size All 6 ]
                [ div [ class "editor__header" ] <| headerView mdl activeTabIdx items focusedEntity
                , div []
                    [ Button.render Mdl
                        [ 9, 0, 0, 1 ]
                        mdl
                        [ Button.colored
                        , Button.raised
                        , Button.link <| "data:text/plain;charset=utf-8," ++ encodeUri exportJson
                        , Options.attribute <| downloadAs "output.json"
                        ]
                        [ text "Download" ]
                    ]
                ]
            ]


headerView : Material.Model -> Int -> Dict String Entity -> Maybe { entityId : String, editor : Components, showingComponents : Bool } -> List (Html Msg)
headerView mdl activeTab items focusedEntity =
    [ Tabs.render Mdl
        [ 0 ]
        mdl
        [ Tabs.activeTab activeTab
        , Tabs.onSelectTab ChangeActiveTab
        ]
        [ Tabs.label
            [ Options.center ]
            [ Icon.i "card_travel"
            , Options.span [ Options.css "width" "4px" ] []
            , text "Items"
            ]
        , Tabs.label
            [ Options.center ]
            [ Icon.i "my_location"
            , Options.span [ Options.css "width" "4px" ] []
            , text "Locations"
            ]
        , Tabs.label
            [ Options.center ]
            [ Icon.i "person"
            , Options.span [ Options.css "width" "4px" ] []
            , text "Characters"
            ]
        ]
        [ Options.div
            [ Options.css "margin" "24px auto"
            , Options.css "flex-direction" "column"
            , Options.css "flex" "1 1 0"
            ]
          <|
            accordionView mdl items focusedEntity
        ]
    ]


accordionView : Material.Model -> Dict String Entity -> Maybe { entityId : String, editor : Components, showingComponents : Bool } -> List (Html Msg)
accordionView mdl entities focusedEntity =
    let
        focusedEntityId =
            Maybe.withDefault
                { entityId = "", editor = Dict.empty, showingComponents = False }
                focusedEntity
                |> .entityId

        classes baseClass entityId =
            classList
                [ ( baseClass, True )
                , ( baseClass ++ "--active", entityId == focusedEntityId )
                ]

        wipShouldChangeThisOptionCs baseClass entityId =
            if entityId == focusedEntityId then
                Options.cs <| baseClass ++ "--active"
            else
                Options.cs <| baseClass

        editorView id =
            case focusedEntity of
                Nothing ->
                    [ div [] [ text "nothing here" ] ]

                Just { entityId, editor, showingComponents } ->
                    Entity.editorView mdl editor showingComponents

        clickEvent id =
            if id == focusedEntityId then
                UnfocusEntity
            else
                ChangeFocusedEntity id

        accordionItem ( id, entity ) =
            div [ class "entity" ]
                [ div
                    [ classes "accordionButton" id
                    , onClick <| clickEvent id
                    ]
                    [ text <| Entity.entityTitle id entity ]
                , Options.div
                    [ wipShouldChangeThisOptionCs "accordionPanel" id
                    , Elevation.e6
                      --classes "accordionPanel" id
                    ]
                    (editorView id)
                ]

        accordionItems =
            entities
                |> Dict.toList
                |> List.sortBy (uncurry Entity.entityTitle)
                |> List.map accordionItem

        -- Dict.values <| Dict.map accordionItem <| entities
        newItem =
            [ div [ class "entity" ]
                [ div [ class "accordionButton", onClick NewEntity ] [ text "Add new" ] ]
            ]
    in
        accordionItems ++ newItem
