module Main exposing (..)

import Html exposing (..)
import Types exposing (..)
import Views.Layout
import Dict exposing (Dict)
import Entity exposing (..)


-- APP


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = init, view = view, update = update }


type alias Model =
    { items : Dict String Entity
    , locations : Dict String Entity
    , characters : Dict String Entity
    , activeTab : TabName
    , lastId : Int
    , focusedEntity :
        -- TODO, maybe rull into editor field?
        Maybe String
    , editor : Maybe (Dict String Component)
    }


init : Model
init =
    Model
        (Dict.singleton "item1" <| Entity.init (Dict.singleton "display" (Display { name = "item1", description = "my item" })))
        (Dict.singleton "location1" <|
            Entity.init
                (Dict.fromList
                    [ ( "display", Display { name = "location1", description = "my location" } )
                    , ( "style", Style { selector = "mySelector" } )
                    ]
                )
        )
        (Dict.singleton "character1" Entity.empty)
        ItemsTab
        3
        Nothing
        Nothing



-- UPDATE


getActiveEntities : Model -> Dict String Entity
getActiveEntities model =
    case model.activeTab of
        ItemsTab ->
            model.items

        LocationsTab ->
            model.locations

        CharactersTab ->
            model.characters


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        ChangeActiveTab tabName ->
            { model
                | activeTab = tabName
                , focusedEntity = Nothing
                , editor = Nothing
            }

        ChangeFocusedEntity focusedEntity ->
            let
                currentEntities =
                    getActiveEntities model
            in
                { model
                    | focusedEntity = Just focusedEntity
                    , editor =
                        Just (Entity.getComponents (Dict.get focusedEntity currentEntities |> Maybe.withDefault Entity.empty))
                        -- TODO , maybe just crash?
                }

        SaveEntity ->
            case ( model.editor, model.focusedEntity ) of
                ( Just editor, Just entityId ) ->
                    case model.activeTab of
                        ItemsTab ->
                            { model | items = Dict.insert entityId (Entity.update Entity.empty editor) model.items }

                        LocationsTab ->
                            { model | locations = Dict.insert entityId (Entity.update Entity.empty editor) model.locations }

                        CharactersTab ->
                            { model | characters = Dict.insert entityId (Entity.update Entity.empty editor) model.characters }

                _ ->
                    model

        NewEntity ->
            let
                newId =
                    model.lastId + 1

                entityPrefix =
                    case model.activeTab of
                        ItemsTab ->
                            "item"

                        LocationsTab ->
                            "location"

                        CharactersTab ->
                            "character"
            in
                { model
                    | focusedEntity = Just <| entityPrefix ++ toString newId
                    , editor = Just <| Dict.singleton "display" (Display { name = "", description = "" })
                    , lastId = newId
                }

        UpdateComponentProperties string component ->
            { model
                | editor = Nothing
            }

        UpdateEditor componentName componentToUpdate f newVal ->
            let
                updateHelper editor =
                    Dict.insert componentName (f newVal componentToUpdate) editor
            in
                ({ model | editor = Maybe.map updateHelper model.editor })


view : Model -> Html Msg
view model =
    let
        currentEntities =
            case model.activeTab of
                ItemsTab ->
                    model.items

                LocationsTab ->
                    model.locations

                CharactersTab ->
                    model.characters
    in
        Views.Layout.view currentEntities model.focusedEntity model.editor
