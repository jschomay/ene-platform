module Views.Layout exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Manifest exposing (..)
import Html.Events exposing (..)


view : Manifest -> Maybe AttributeEditor -> Html Msg
view manifest editor =
    div [ class "editor" ]
        [ div [ class "editor__header" ] <| headerView
        , div [ class "editor__content" ] <| contentView manifest editor
        ]


contentView : Manifest -> Maybe AttributeEditor -> List (Html Msg)
contentView manifest editor =
    [ div [ class "content__sidebar" ] <| sidebarView manifest
    , div [ class "content__attributes" ] <| attributesView editor
    ]


attributesView : Maybe AttributeEditor -> List (Html Msg)
attributesView editor =
    case editor of
        Nothing ->
            []

        Just { itemId, displayName, description } ->
            [ label
                [ for "name-input"
                , class "content__attributes--label"
                ]
                [ text "Name" ]
            , input
                [ id "name-input"
                , class "content__attributes--input"
                , value displayName
                , onInput UpdateName
                ]
                []
            , label
                [ for "description-input", class "content__attributes--label" ]
                [ text "Description" ]
            , textarea
                [ id "description-input"
                , class "content__attributes--textarea"
                , value description
                , onInput UpdateDescription
                ]
                []
            , button [ onClick Save ] [ text "submit" ]
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


sidebarView : Manifest -> List (Html Msg)
sidebarView manifest =
    let
        sidebarItem ( id, { name, description } ) =
            div [ class "sidebar__item", onClick <| ChangeFocusedItem id ] [ text name ]

        sidebarAddItem =
            [ div [ class "sidebar__new", onClick Create ] [ text "+" ] ]

        existingSidebarItems =
            List.map sidebarItem <| Manifest.attributes manifest
    in
        existingSidebarItems ++ sidebarAddItem
