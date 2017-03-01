module Views.Layout exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Entity as Entity
import Dict exposing (Dict)
import Http exposing (encodeUri)


view : TabName -> String -> Dict String Entity -> Maybe { entityId : String, editor : Components, showingComponents : Bool } -> Html Msg
view activeTab exportJson items focusedEntity =
    div [ class "editor" ]
        [ div [ class "editor__header" ] <| headerView activeTab
        , div [ class "editor__content" ] <| accordionView items focusedEntity
        , a
            [ type_ "button"
            , href <| "data:text/plain;charset=utf-8," ++ encodeUri exportJson
            , downloadAs "output.json"
            , class "export"
            ]
            [ text "Download" ]
        ]


headerView : TabName -> List (Html Msg)
headerView activeTab =
    let
        classes active =
            classList [ ( "headerTab", True ), ( "headerTab--active", active ) ]
    in
        [ div
            [ classes <| activeTab == ItemsTab
            , onClick <| ChangeActiveTab ItemsTab
            ]
            [ text "Items" ]
        , div
            [ classes <| activeTab == LocationsTab
            , onClick <| ChangeActiveTab LocationsTab
            ]
            [ text "Locations" ]
        , div
            [ classes <| activeTab == CharactersTab
            , onClick <| ChangeActiveTab CharactersTab
            ]
            [ text "Characters" ]
        ]


accordionView : Dict String Entity -> Maybe { entityId : String, editor : Components, showingComponents : Bool } -> List (Html Msg)
accordionView entities focusedEntity =
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

        editorView id =
            case focusedEntity of
                Nothing ->
                    [ div [] [ text "nothing here" ] ]

                Just { entityId, editor, showingComponents } ->
                    Entity.editorView editor showingComponents

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
                , div [ classes "accordionPanel" id ]
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
