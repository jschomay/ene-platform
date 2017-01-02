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
    , attributeEditor : Maybe AttributeEditor
    , lastId : Int
    }


init : Model
init =
    Model
        (Manifest.init Nothing [ ( 0, Attributes "Umbrella" "An umbrella" ), ( 1, Attributes "Red Marble" "Shiny" ) ])
        (Manifest.init Nothing [ ( 2, Attributes "house" "My house" ) ])
        (Manifest.init Nothing [ ( 3, Attributes "maor" "The one and only" ) ])
        Items
        Nothing
        3



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
                { model | activeTab = tabName, attributeEditor = Nothing }

            ChangeFocusedItem focusedItemId ->
                let
                    newEditor =
                        activeManifest model
                            |> Manifest.get focusedItemId
                            |> Maybe.andThen
                                (\{ name, description } ->
                                    Just <| AttributeEditor focusedItemId name description False
                                )
                in
                    { model | attributeEditor = newEditor }

            UpdateName newName ->
                let
                    newEditor { itemId, displayName, description, isNew } =
                        AttributeEditor itemId newName description isNew
                in
                    { model | attributeEditor = Maybe.map newEditor model.attributeEditor }

            UpdateDescription newDescription ->
                let
                    newEditor editor =
                        { editor | description = newDescription }
                in
                    { model | attributeEditor = Maybe.map newEditor model.attributeEditor }

            Save ->
                let
                    newEditor editor =
                        { editor | isNew = False }
                in
                    activeManifest model
                        |> \manifest ->
                            -- placeholder for now, crash on nonunique id
                            case
                                Manifest.save model.attributeEditor manifest
                            of
                                Err error ->
                                    Debug.crash error

                                Ok manifest ->
                                    saveActiveManifest manifest
                                        |> (\model ->
                                                { model | attributeEditor = Maybe.map newEditor model.attributeEditor }
                                           )

            Create ->
                { model | attributeEditor = Just <| AttributeEditor (model.lastId + 1) "" "" True, lastId = model.lastId + 1 }


view : Model -> Html Msg
view model =
    Views.Layout.view (activeManifest model) model.attributeEditor



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
