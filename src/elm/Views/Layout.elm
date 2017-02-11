module Views.Layout exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Entity as Entity exposing (Entity)
import Dict exposing (Dict)


view : Dict String Entity -> Maybe String -> Maybe (Dict String Component) -> Html Msg
view items focusedEntity components =
    div [ class "editor" ]
        [ div [ class "editor__header" ] <| headerView
        , div [ class "editor__content" ] <| contentView items focusedEntity components
        ]


contentView : Dict String Entity -> Maybe String -> Maybe (Dict String Component) -> List (Html Msg)
contentView items focusedEntity components =
    [ div [ class "content__sidebar" ] <| sidebarView items focusedEntity
    , div [ class "content__attributes" ] <|
        case components of
            Nothing ->
                [ text "Hey, make something useful" ]

            Just components ->
                Entity.editorView components
    ]


headerView : List (Html Msg)
headerView =
    [ div
        [ class "header__tab"
        , onClick <| ChangeActiveTab ItemsTab
        ]
        [ text "Items" ]
    , div
        [ class "header__tab"
        , onClick <| ChangeActiveTab LocationsTab
        ]
        [ text "Locations" ]
    , div
        [ class "header__tab"
        , onClick <| ChangeActiveTab CharactersTab
        ]
        [ text "Characters" ]
    ]


sidebarView : Dict String Entity -> Maybe String -> List (Html Msg)
sidebarView items focusedEntity =
    let
        sidebarEntity id _ =
            div [ class "sidebar__item", onClick <| ChangeFocusedEntity id ] [ text id ]

        sidebarAddEntity =
            [ div [ class "sidebar__new", onClick NewEntity ] [ text "+" ] ]

        existingSidebarEntity =
            Dict.values <| Dict.map sidebarEntity <| items
    in
        existingSidebarEntity ++ sidebarAddEntity
