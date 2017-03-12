module Main exposing (..)

import Html exposing (..)
import Types exposing (..)
import Views.Layout
import Dict exposing (Dict)
import Entity exposing (..)
import Encode
import Component
import Material


-- APP


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



--TODO: get rid of the editor and onInput sync the entity and then store it


type alias Model =
    { items : Dict String Entity
    , locations : Dict String Entity
    , characters : Dict String Entity
    , activeTab : TabName
    , lastId : Int
    , focusedEntity :
        Maybe
            { entityId : String
            , showingComponents : Bool
            }
    , mdl : Material.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        items =
            (Dict.singleton "items1" <| Entity.init (Dict.singleton "display" (Display { name = "item1", description = "my item" })))

        locations =
            (Dict.fromList
                [ ( "locations1"
                  , Entity.init
                        (Dict.fromList
                            [ ( "display", Display { name = "location1", description = "my location" } )
                            , ( "style", Style { selector = "mySelector" } )
                            ]
                        )
                  )
                , ( "locations2"
                  , Entity.empty
                  )
                ]
            )

        characters =
            (Dict.singleton "characters1" Entity.empty)
    in
        ( { items = items
          , locations = locations
          , characters = characters
          , activeTab = ItemsTab
          , lastId = 3
          , focusedEntity = Nothing
          , mdl = Material.model
          }
        , Cmd.none
        )



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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        currentEntities =
            getActiveEntities model

        changeFocusedEntity focusedEntity model =
            { model
                | focusedEntity =
                    Just
                        { entityId = focusedEntity
                        , showingComponents =
                            False
                            -- TODO , maybe just crash?
                        }
            }

        updateActiveEntityCollection entityId newEntity =
            Debug.log "newEntity" newEntity
                |> \newEntity ->
                    case model.activeTab of
                        ItemsTab ->
                            { model | items = Dict.insert entityId newEntity model.items }

                        LocationsTab ->
                            { model | locations = Dict.insert entityId newEntity model.locations }

                        CharactersTab ->
                            { model | characters = Dict.insert entityId newEntity model.characters }
    in
        case msg of
            NoOp ->
                ( model, Cmd.none )

            ChangeActiveTab newTabIndex ->
                let
                    newActiveTab =
                        case newTabIndex of
                            0 ->
                                ItemsTab

                            1 ->
                                LocationsTab

                            _ ->
                                CharactersTab
                in
                    ( { model
                        | activeTab = newActiveTab
                        , focusedEntity = Nothing
                      }
                    , Cmd.none
                    )

            ChangeFocusedEntity focusedEntity ->
                ( changeFocusedEntity focusedEntity model, Cmd.none )

            UnfocusEntity ->
                ( { model | focusedEntity = Nothing }, Cmd.none )

            NewEntity ->
                let
                    newId =
                        model.lastId + 1

                    newEntityId =
                        Entity.newEntityId model.activeTab newId

                    newModel =
                        updateActiveEntityCollection newEntityId Entity.empty
                in
                    ( changeFocusedEntity newEntityId newModel
                        |> (\model ->
                                { model
                                    | lastId = newId
                                }
                           )
                    , Cmd.none
                    )

            UpdateEditor componentName f newVal ->
                let
                    updateModel focusedEntity =
                        updateActiveEntityCollection
                            focusedEntity.entityId
                            (Entity.update
                                Entity.empty
                                (Dict.get
                                    focusedEntity.entityId
                                    (getActiveEntities model)
                                    |> Maybe.withDefault Entity.empty
                                    |> Entity.getComponents
                                    |> (Dict.insert componentName (f newVal))
                                )
                            )

                    updatedModel =
                        Maybe.map updateModel model.focusedEntity
                            |> Maybe.withDefault model
                in
                    -- TODO: refactor this bad boy, but for now just keeping forward
                    ( updatedModel, Cmd.none )

            AddComponent name ->
                let
                    component =
                        Component.getComponent name

                    getUpdatedEntity { entityId, showingComponents } =
                        getActiveEntities model
                            |> Dict.get entityId
                            |> \entity ->
                                case entity of
                                    Nothing ->
                                        Nothing

                                    Just (Entity components) ->
                                        case component of
                                            Nothing ->
                                                Nothing

                                            Just component ->
                                                Just { entityId = entityId, entity = Entity <| Dict.insert name component components }

                    updateHelper focusedEntity =
                        case component of
                            Nothing ->
                                -- TODO: figure out a better way to handle all this
                                Debug.crash "Could not find the component..."

                            Just component ->
                                { focusedEntity
                                    | showingComponents = False
                                }
                in
                    case name of
                        "" ->
                            ( model, Cmd.none )

                        _ ->
                            getUpdatedEntity
                                model.focusedEntity
                                |> Maybe.andThen
                                    (\updatedEntity ->
                                        case updatedEntity of
                                            Nothing ->
                                                ( model, Cmd.none )

                                            Just { entityId, entity } ->
                                                ( updateActiveEntityCollection entityId entity, Cmd.none )
                                    )

            -- ( { model | focusedEntity = Maybe.map updateHelper model.focusedEntity }, Cmd.none )
            ToggleComponentDropdown ->
                let
                    updateFocusedEntity =
                        case model.focusedEntity of
                            Nothing ->
                                Nothing

                            Just focusedEntity ->
                                Just { focusedEntity | showingComponents = not focusedEntity.showingComponents }
                in
                    ( { model | focusedEntity = updateFocusedEntity }, Cmd.none )

            Mdl message ->
                Material.update Mdl message model


view : Model -> Html Msg
view model =
    let
        exportData =
            Encode.toJson
                { items = model.items, locations = model.locations, characters = model.characters }

        entityWithEditor =
            case model.focusedEntity of
                Nothing ->
                    Nothing

                Just { entityId, showingComponents } ->
                    case Dict.get entityId (getActiveEntities model) of
                        Nothing ->
                            Nothing

                        Just entity ->
                            Just { entityId = entityId, components = Entity.getComponents entity, showingComponents = showingComponents }
    in
        Views.Layout.view model.mdl model.activeTab exportData (getActiveEntities model) entityWithEditor
