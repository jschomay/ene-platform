module Entity exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Types exposing (..)


type Entity
    = Entity (Dict String Component)


empty : Entity
empty =
    Entity Dict.empty


init : Dict String Component -> Entity
init components =
    update empty components


update : Entity -> Dict String Component -> Entity
update (Entity oldComponents) newComponents =
    -- Note, newComponents MUST be first!
    Entity <| Dict.union newComponents oldComponents


getComponents : Entity -> Dict String Component
getComponents (Entity components) =
    components


editorView : Dict String Component -> List (Html Msg)
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
