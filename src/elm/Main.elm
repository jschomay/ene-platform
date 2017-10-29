module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


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
    div []
        [ nav [ class "navbar navbar-expand navbar-dark bg-dark" ]
            [ span [ class "navbar-brand" ] [ text <| "\"" ++ model.story.title ++ "\"" ]
            , div [ class "collapse navbar-collapse" ]
                [ ul [ class "navbar-nav" ]
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
        , div [ class "container pt-3" ]
            [ div [ class "card" ]
                [ div [ class "card-header" ]
                    [ ul [ class "nav nav-tabs nav-fill card-header-tabs" ]
                        [ li [ class "nav-item" ]
                            [ span [ class "nav-link active" ]
                                [ text "Locations" ]
                            ]
                        , li [ class "nav-item" ]
                            [ span [ class "nav-link" ]
                                [ text "Characters" ]
                            ]
                        , li [ class "nav-item" ]
                            [ span [ class "nav-link" ]
                                [ text "Items" ]
                            ]
                        ]
                    ]
                , div [ class "card-body" ]
                    [ div [ id "accordion", attribute "role" "tablist" ]
                        [ div [ class "card" ]
                            [ div [ class "card-header", id "headingOne", attribute "role" "tab" ]
                                [ h5 [ class "mb-0" ]
                                    [ a [ attribute "aria-controls" "collapseOne", attribute "aria-expanded" "true", attribute "data-toggle" "collapse", href "#collapseOne" ]
                                        [ text "Collapsible Group Item #1        " ]
                                    ]
                                ]
                            , div [ attribute "aria-labelledby" "headingOne", class "collapse show", attribute "data-parent" "#accordion", id "collapseOne", attribute "role" "tabpanel" ]
                                [ div [ class "card-body" ]
                                    [ text "Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.      " ]
                                ]
                            ]
                        , div [ class "card" ]
                            [ div [ class "card-header", id "headingTwo", attribute "role" "tab" ]
                                [ h5 [ class "mb-0" ]
                                    [ a [ attribute "aria-controls" "collapseTwo", attribute "aria-expanded" "false", class "collapsed", attribute "data-toggle" "collapse", href "#collapseTwo" ]
                                        [ text "Collapsible Group Item #2        " ]
                                    ]
                                ]
                            , div [ attribute "aria-labelledby" "headingTwo", class "collapse", attribute "data-parent" "#accordion", id "collapseTwo", attribute "role" "tabpanel" ]
                                [ div [ class "card-body" ]
                                    [ text "Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.      " ]
                                ]
                            ]
                        , div [ class "card" ]
                            [ div [ class "card-header", id "headingThree", attribute "role" "tab" ]
                                [ h5 [ class "mb-0" ]
                                    [ a [ attribute "aria-controls" "collapseThree", attribute "aria-expanded" "false", class "collapsed", attribute "data-toggle" "collapse", href "#collapseThree" ]
                                        [ text "Collapsible Group Item #3        " ]
                                    ]
                                ]
                            , div [ attribute "aria-labelledby" "headingThree", class "collapse", attribute "data-parent" "#accordion", id "collapseThree", attribute "role" "tabpanel" ]
                                [ div [ class "card-body" ]
                                    [ text "Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.      " ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
