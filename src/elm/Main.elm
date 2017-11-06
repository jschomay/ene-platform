module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Views.InteractablesList


-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscribe
        }



-- MODEL


type alias Model =
    { story : Story }


type alias Story =
    { title : String }


init : ( Model, Cmd Msg )
init =
    ( { story = { title = "My story title" } }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


subscribe : Model -> Sub Msg
subscribe model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        header =
            nav [ class "navbar navbar-expand navbar-dark bg-dark" ]
                [ span [ class "navbar-brand" ] [ text <| "\"" ++ model.story.title ++ "\"" ]
                , div [ class "collapse navbar-collapse" ]
                    [ ul [ class "navbar-nav align-items-center" ]
                        [ li [ class "nav-item active" ]
                            [ a [ class "nav-link", href "#" ]
                                [ text "Editor " ]
                            ]
                        , li [ class "nav-item" ]
                            [ a [ class "nav-link disabled", href "#" ]
                                [ text "Preview" ]
                            ]
                        , li [ class "nav-item" ]
                            [ a [ class "nav-link disabled", href "#" ]
                                [ text "Settings / Export" ]
                            ]
                        ]
                    ]
                , span [ class "navbar-text" ] [ a [ href "http://elmnarrativeengine.com/", target "blank" ] [ text "Elm Narrative Engine Platform" ] ]
                ]

        body =
            div [ class "container pt-3" ]
                [ div [ class "card" ]
                    [ div [ class "card-header" ]
                        [ ul [ class "nav nav-tabs nav-fill card-header-tabs" ]
                            [ li [ class "nav-item" ]
                                [ span [ class "nav-link" ]
                                    [ span [ class "oi oi-home mr-2" ] [], text "Locations" ]
                                ]
                            , li [ class "nav-item" ]
                                [ span [ class "nav-link" ]
                                    [ span [ class "oi oi-person mr-2" ] [], text "Characters" ]
                                ]
                            , li [ class "nav-item" ]
                                [ span [ class "nav-link active" ]
                                    [ span [ class "oi oi-briefcase mr-2" ] [], text "Items" ]
                                ]
                            ]
                        ]
                    , div [ class "card-body" ]
                        [ Views.InteractablesList.view
                        , button [ class "btn btn-primary btn-sm" ] [ small [ class "oi oi-plus mr-2" ] [], text "add item" ]
                        ]
                    ]
                ]
    in
        div [] [ header, body ]
