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
        , getAvailableComponents
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



-- TODO: test the update editor functions


editorView : Components -> List (Html Msg)
editorView components =
    let
        componentView componentName component =
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

                Style { selector } ->
                    div [ class "attributesEditor" ]
                        [ div [ class "attributesEditor__item" ]
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
                        ]

        submitButton =
            case Dict.size components of
                0 ->
                    []

                _ ->
                    [ button [ onClick SaveEntity ] [ text "submit" ] ]
    in
        addComponentView components
            :: (Dict.values <|
                    Dict.map componentView components
               )
            ++ submitButton


addComponentView : Components -> Html Msg
addComponentView existingComponents =
    let
        availableComponents =
            getAvailableComponents existingComponents

        addComponentRenderer ( name, component ) =
            div []
                [ button
                    [ onClick <|
                        AddComponent name component
                    ]
                    [ text <| "add " ++ name ]
                ]
    in
        Dict.toList availableComponents
            |> List.map addComponentRenderer
            |> div [ class "addComponent" ]



-- [ , button [ onClick <| AddComponent "style" (Style { selector = "" }) ] [] ]


newEntityId : TabName -> Int -> String
newEntityId tabName newId =
    toString tabName
        |> String.dropRight 3
        |> String.toLower
        |> (flip (++)) (toString newId)


getAvailableComponents : Components -> Components
getAvailableComponents components =
    let
        allAvailableComponents =
            Dict.fromList [ ( "display", Display { name = "", description = "" } ), ( "style", Style { selector = "" } ) ]
    in
        Dict.diff allAvailableComponents components
