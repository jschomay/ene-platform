module Components.Display exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onBlur)


view : String -> Component -> Html Msg
view componentName component =
    let
        updateFn newVal f =
            case component of
                Display a ->
                    Display <| f a

                _ ->
                    component

        updateDescription newVal =
            updateFn newVal (\a -> { a | description = newVal })

        updateName newVal =
            updateFn newVal (\a -> { a | name = newVal })
    in
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
                                UpdateEditor componentName updateName
                            , onBlur SaveEntity
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
                                UpdateEditor componentName updateDescription
                            , onBlur SaveEntity
                            ]
                            []
                        ]
                    ]

            _ ->
                div [] []
