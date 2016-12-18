module Main exposing (..)

import Html exposing (..)
import Types exposing (..)
import Views.Layout
import Manifest


-- APP


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = init, view = view, update = update }


type alias Model =
    { items : Manifest.Manifest
    , locations : Manifest.Manifest
    , characters : Manifest.Manifest
    , activeTab : TabName
    }


init : Model
init =
    Model
        (Manifest.init [ Attributes "Umbrella" "An umbrella" "0", Attributes "Red Marble" "Shiny" "1" ])
        (Manifest.init [ Attributes "house" "My house" "0" ])
        (Manifest.init [ Attributes "maor" "The one and only" "0" ])
        Items


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        ChangeActiveTab tabName ->
            { model | activeTab = tabName }


view : Model -> Html Msg
view model =
    let
        activeManifest =
            case model.activeTab of
                Items ->
                    model.items

                Locations ->
                    model.locations

                Characters ->
                    model.characters
    in
        Views.Layout.view activeManifest
