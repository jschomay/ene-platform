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



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    let
        updateActiveManifest newManifest =
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
                    updateActiveManifest updatedManifest

            UpdateName newName ->
                activeManifest model
                    |> Manifest.updateManifest
                        (\attributes -> { attributes | name = newName })
                    |> updateActiveManifest

            UpdateDescription newDescription ->
                activeManifest model
                    |> Manifest.updateManifest
                        (\attributes -> { attributes | description = newDescription })
                    |> updateActiveManifest



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
