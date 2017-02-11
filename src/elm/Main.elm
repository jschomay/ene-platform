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
        Maybe
            { entityId : String
            , editor : Components
            }
    }


init : Model
init =
    Model
        (Dict.singleton "items1" <| Entity.init (Dict.singleton "display" (Display { name = "item1", description = "my item" })))
        (Dict.singleton "locations1" <|
            Entity.init
                (Dict.fromList
                    [ ( "display", Display { name = "location1", description = "my location" } )
                    , ( "style", Style { selector = "mySelector" } )
                    ]
                )
        )
        (Dict.singleton "characters1" Entity.empty)
        ItemsTab
        3
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

        UpdateEditor componentName componentToUpdate f newVal ->
            let
                updateHelper focusedEntity =
                    { focusedEntity | editor = Dict.insert componentName (f newVal componentToUpdate) focusedEntity.editor }
            in
                ({ model | focusedEntity = Maybe.map updateHelper model.focusedEntity })


view : Model -> Html Msg
view model =
    Views.Layout.view (getActiveEntities model) model.focusedEntity
