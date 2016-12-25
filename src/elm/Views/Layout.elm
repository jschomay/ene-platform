module Views.Layout exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Manifest exposing (..)
import Html.Events exposing (..)


view : Manifest -> Html Msg
view activeManifest =
    div [ class "editor" ]
        [ div [ class "editor__header" ] <| headerView
        , div [ class "editor__content" ] <| contentView <| activeManifest
        ]


contentView : Manifest -> List (Html Msg)
contentView manifest =
    [ div [ class "content__sidebar" ] <| sidebarView manifest
    , div [ class "content__attributes" ] <| attributesView manifest
    ]


attributesView : Manifest -> List (Html Msg)
attributesView manifest =
    let
        focusedItem =
            Manifest.focusedItem manifest
    in
        [ div []
            [ text <| toString <| focusedItem
            , div [ class "attributes__name" ]
                [ input [ class "attributes__name--input", value focusedItem.name, onInput UpdateName ] [] ]
            , div [ class "attributes__description" ]
                [ input [ class "attributes__description--input", value focusedItem.description, onInput UpdateDescription ] [] ]
            ]
        ]


headerView : List (Html Msg)
headerView =
    [ div
        [ class "header__tab"
        , onClick <| ChangeActiveTab Items
        ]
        [ text "Items" ]
    , div
        [ class "header__tab"
        , onClick <| ChangeActiveTab Locations
        ]
        [ text "Locations" ]
    , div
        [ class "header__tab"
        , onClick <| ChangeActiveTab Characters
        ]
        [ text "Characters" ]
    ]


sidebarView : Manifest -> List (Html Msg)
sidebarView manifest =
    let
        sidebarItem { name, description, id } =
            div [ class "sidebar__item", onClick <| ChangeFocusedItem id ] [ text name ]

        sidebarAddItem =
            [ div [ class "sidebar__new" ] [ text "+" ] ]

        existingSidebarItems =
            List.map sidebarItem <| Manifest.attributes manifest
    in
        existingSidebarItems ++ sidebarAddItem
