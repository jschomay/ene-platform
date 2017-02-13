module Components.Display exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


view : String -> Component -> Html Msg
view componentName component =
    case component of
        Display { name, description } ->
            div [ class "attributesEditor" ]
                [ div [ class "attributesEditor__item" ]
                    [ label
                        [ for "name-input"
                        ]
                        [ text "Name" ]
                    , input
                        [ id "name-input"
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
                    ]
                , div [ class "attributesEditor__item" ]
                    [ label
                        [ for "description-input" ]
                        [ text "Description" ]
                    , textarea
                        [ id "description-input"
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
                    ]
                ]

        _ ->
            div [] []
