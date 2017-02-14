module Views.Layout exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Entity as Entity
import Dict exposing (Dict)


view : Dict String Entity -> Maybe { entityId : String, editor : Components } -> Html Msg
view items focusedEntity =
    div [ class "editor" ]
        [ div [ class "editor__header" ] <| headerView
        , div [ class "editor__content" ] <| contentView items focusedEntity
        ]


contentView : Dict String Entity -> Maybe { entityId : String, editor : Components } -> List (Html Msg)
contentView items focusedEntity =
    [ div [ class "sidebar" ] <| sidebarView items
    , div [ class "attributes" ] <|
        case focusedEntity of
            Nothing ->
                [ text "Hey, make something useful" ]

            Just { entityId, editor } ->
                Entity.editorView editor
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
