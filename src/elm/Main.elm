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
        (Manifest.init (Just "umbrella") [ ( "umbrella", Attributes "Umbrella" "An umbrella" ), ( "marble", Attributes "Red Marble" "Shiny" ) ])
        (Manifest.init (Just "house") [ ( "house", Attributes "house" "My house" ) ])
        (Manifest.init (Just "maor") [ ( "maor", Attributes "maor" "The one and only" ) ])
        Items



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    let
        saveActiveManifest newManifest =
            case model.activeTab of
                Items ->
                    { model | items = newManifest }

                Locations ->
                    { model | locations = newManifest }

                Characters ->
                    { model | characters = newManifest }
    in
        case msg of
            NoOp ->
                model

            ChangeActiveTab tabName ->
                { model | activeTab = tabName }

            ChangeFocusedItem focusedItemId ->
                let
                    updatedManifest =
                        Manifest.changeFocusedItem focusedItemId <| activeManifest model
                in
                    saveActiveManifest updatedManifest

            UpdateName newName ->
                activeManifest model
                    |> Manifest.update
                        (\attributes -> { attributes | name = newName })
                    |> saveActiveManifest

            UpdateDescription newDescription ->
                activeManifest model
                    |> Manifest.update
                        (\attributes -> { attributes | description = newDescription })
                    |> saveActiveManifest



-- VIEW


view : Model -> Html Msg
view model =
    Views.Layout.view <| activeManifest model



-- HELPERS


activeManifest : Model -> Manifest.Manifest
activeManifest model =
    case model.activeTab of
        Items ->
            model.items

        Locations ->
            model.locations

        Characters ->
            model.characters
