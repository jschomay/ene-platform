module Main exposing (..)

import Html exposing (..)
import Types exposing (..)
import Views.Layout
import Dict exposing (Dict)
import Entity exposing (..)
import Encode


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
        Maybe
            { entityId : String
            , editor : Components
            }
    , exportJson : String
    }


init : Model
init =
    let
        items =
            (Dict.singleton "items1" <| Entity.init (Dict.singleton "display" (Display { name = "item1", description = "my item" })))

        locations =
            (Dict.singleton "locations1" <|
                Entity.init
                    (Dict.fromList
                        [ ( "display", Display { name = "location1", description = "my location" } )
                        , ( "style", Style { selector = "mySelector" } )
                        ]
                    )
            )

        characters =
            (Dict.singleton "characters1" Entity.empty)
    in
        Model
            items
            locations
            characters
            ItemsTab
            3
            Nothing
        <|
            Encode.toJson
                { items = items, locations = locations, characters = characters }



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
            }

        ChangeFocusedEntity focusedEntity ->
            let
                currentEntities =
                    getActiveEntities model
            in
                { model
                    | focusedEntity =
                        Just
                            { entityId = focusedEntity
                            , editor =
                                (Entity.getComponents
                                    (Dict.get focusedEntity currentEntities
                                        |> Maybe.withDefault Entity.empty
                                    )
                                )
                                -- TODO , maybe just crash?
                            }
                }

        SaveEntity ->
            let
                newModel =
                    case model.focusedEntity of
                        Just { entityId, editor } ->
                            case model.activeTab of
                                ItemsTab ->
                                    { model | items = Dict.insert entityId (Entity.update Entity.empty editor) model.items }

                                LocationsTab ->
                                    { model | locations = Dict.insert entityId (Entity.update Entity.empty editor) model.locations }

                                CharactersTab ->
                                    { model | characters = Dict.insert entityId (Entity.update Entity.empty editor) model.characters }

                        _ ->
                            model
            in
                ({ newModel | exportJson = Encode.toJson newModel })

        NewEntity ->
            let
                newId =
                    model.lastId + 1
            in
                { model
                    | focusedEntity =
                        Just
                            { entityId = Entity.newEntityId model.activeTab newId
                            , editor = Dict.singleton "display" (Display { name = "", description = "" })
                            }
                    , lastId = newId
                }

        UpdateEditor componentName f newVal ->
            let
                updateHelper focusedEntity =
                    { focusedEntity | editor = Dict.insert componentName (f newVal) focusedEntity.editor }
            in
                ({ model | focusedEntity = Maybe.map updateHelper model.focusedEntity })

        AddComponent name component ->
            let
                updateHelper focusedEntity =
                    { focusedEntity | editor = Dict.insert name component focusedEntity.editor }
            in
                ({ model | focusedEntity = Maybe.map updateHelper model.focusedEntity })


view : Model -> Html Msg
view model =
    Views.Layout.view model.exportJson (getActiveEntities model) model.focusedEntity
