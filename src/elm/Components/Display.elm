module Components.Display exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Textfield as Textfield
import Material.Options as Options
import Material


view : Material.Model -> String -> Component -> Html Msg
view mdl componentName component =
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
                    [ p [ class "attributesEditor__header" ] [ text "Display Component" ]
                    , div [ class "attributesEditor__item" ]
                        [ Textfield.render Mdl
                            [ 0 ]
                            mdl
                            [ Textfield.label "Name"
                            , Textfield.floatingLabel
                            , Textfield.value name
                            , Options.onInput <| UpdateEditor componentName updateName
                            ]
                            []
                        ]
                    , div [ class "attributesEditor__item" ]
                        [ Textfield.render Mdl
                            [ 1 ]
                            mdl
                            [ Textfield.label "Description"
                            , Textfield.textarea
                            , Textfield.floatingLabel
                            , Textfield.value description
                            , Options.onInput <| UpdateEditor componentName updateDescription
                            ]
                            []
                        ]
                    ]

            _ ->
                div [] []


getTitle : Maybe Component -> Maybe String
getTitle component =
    case component of
        Just (Display { name }) ->
            if String.isEmpty name then
                Nothing
            else
                Just name

        _ ->
            Nothing
