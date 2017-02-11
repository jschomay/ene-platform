module Entity
    exposing
        ( Components
        , Entity
        , empty
        , init
        , update
        , getComponents
        , editorView
        , newEntityId
        )

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Types exposing (..)


type alias Components =
    Dict String Component


type Entity
    = Entity Components


empty : Entity
empty =
    Entity Dict.empty


init : Components -> Entity
init components =
    update empty components


update : Entity -> Components -> Entity
update (Entity oldComponents) newComponents =
    -- Note, newComponents MUST be first!
    Entity <| Dict.union newComponents oldComponents


getComponents : Entity -> Components
getComponents (Entity components) =
    components


editorView : Components -> List (Html Msg)
editorView components =
    let
        componentView componentName component =
            case component of
                Display { name, description } ->
                    div []
                        [ label
                            [ for "name-input"
                            , class "content__attributes--label"
                            ]
                            [ text "Name" ]
                        , input
                            [ id "name-input"
                            , class "content__attributes--input"
                            , value name
                            , onInput <|
                                UpdateEditor componentName
                                    component
                                    (\newVal component ->
                                        case component of
                                            Display attributes ->
                                                Display { attributes | name = newVal }

                                            _ ->
                                                component
                                    )
                            ]
                            []
                        , label
                            [ for "description-input", class "content__attributes--label" ]
                            [ text "Description" ]
                        , textarea
                            [ id "description-input"
                            , class "content__attributes--textarea"
                            , value description
                            , onInput <|
                                UpdateEditor componentName
                                    component
                                    (\newVal component ->
                                        case component of
                                            Display attributes ->
                                                Display { attributes | description = newVal }

                                            _ ->
                                                component
                                    )
                            ]
                            []
                        , button [ onClick SaveEntity ] [ text "submit" ]
                        ]

                Style { selector } ->
                    div []
                        [ label
                            [ for "selector-input"
                            , class "Components__Attributes--label"
                            ]
                            [ text "CSS Selector"
                            ]
                        , input
                            [ id "selector-input"
                            , class "Components__Attributes--input"
                            , value selector
                            , onInput <|
                                UpdateEditor componentName
                                    component
                                    (\newVal component ->
                                        case component of
                                            Style attributes ->
                                                Style { attributes | selector = newVal }

                                            _ ->
                                                component
                                    )
                            ]
                            []
                        ]
    in
        Dict.values <| Dict.map componentView components


newEntityId : TabName -> Int -> String
newEntityId tabName newId =
    toString tabName
        |> String.dropRight 3
        |> String.toLower
        |> (flip (++)) (toString newId)
