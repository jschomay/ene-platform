module Views.Layout exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Entity as Entity
import Dict exposing (Dict)
import Http exposing (encodeUri)


view : String -> Dict String Entity -> Maybe { entityId : String, editor : Components } -> Html Msg
view exportJson items focusedEntity =
    div [ class "editor" ]
        [ div [ class "editor__header" ] <| headerView
        , div [ class "editor__content" ] <| accordionView items focusedEntity
        , a
            [ type_ "button"
            , href <| "data:text/plain;charset=utf-8," ++ encodeUri exportJson
            , downloadAs "output.json"
            , class "export"
            ]
            [ text "Download" ]
        ]


headerView : List (Html Msg)
headerView =
    [ div
        [ class "headerTab"
        , onClick <| ChangeActiveTab ItemsTab
        ]
        [ text "Items" ]
    , div
        [ class "headerTab"
        , onClick <| ChangeActiveTab LocationsTab
        ]
        [ text "Locations" ]
    , div
        [ class "headerTab"
        , onClick <| ChangeActiveTab CharactersTab
        ]
        [ text "Characters" ]
    ]


sidebarView : Dict String Entity -> List (Html Msg)
sidebarView items =
    let
        sidebarEntity id _ =
            div [ class "sidebar__item", onClick <| ChangeFocusedEntity id ] [ text id ]

        sidebarAddEntity =
            [ div [ class "sidebar__new", onClick NewEntity ] [ text "+" ] ]

        existingSidebarEntity =
            Dict.values <| Dict.map sidebarEntity <| items
    in
        existingSidebarEntity ++ sidebarAddEntity


accordionView : Dict String Entity -> Maybe { entityId : String, editor : Components } -> List (Html Msg)
accordionView entities focusedEntity =
    let
        focusedEntityId =
            Maybe.withDefault
                { entityId = "", editor = Dict.empty }
                focusedEntity
                |> .entityId

        classes baseClass entityId =
            [ ( baseClass, True )
            , ( "active", entityId == focusedEntityId )
            ]

        editorView id =
            case focusedEntity of
                Nothing ->
                    [ div [] [ text "nothing here" ] ]

                Just { entityId, editor } ->
                    Entity.editorView editor

        clickEvent id =
            if id == focusedEntityId then
                UnfocusEntity
            else
                ChangeFocusedEntity id

        accordionItem id entity =
            div [ class "entity" ]
                [ div [ classList <| classes "accordionButton" id, onClick <| clickEvent id ] [ text <| Entity.entityTitle id entity ]
                , div [ classList <| classes "accordionPanel" id ]
                    (editorView id)
                ]

        accordionItems =
            Dict.values <| Dict.map accordionItem <| entities

        newItem =
            [ div [ class "entity" ]
                [ div [ class "accordionButton", onClick NewEntity ] [ text "Add new" ] ]
            ]
    in
        accordionItems ++ newItem
