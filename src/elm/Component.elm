module Component exposing (..)

import Types exposing (..)
import Html exposing (Html)
import Components.Display
import Components.Style
import Components.RuleBuilder
import Dict
import Material
import Json.Encode as Encode


view : Material.Model -> String -> Component -> Html Msg
view mdl componentName component =
    case component of
        Display attributes ->
            Components.Display.view mdl componentName component

        Style attributes ->
            Components.Style.view mdl componentName component

        RuleBuilder attributes ->
            Components.RuleBuilder.view mdl componentName component


encode : Component -> Encode.Value
encode component =
    case component of
        Display params ->
            Encode.object [ ( "name", Encode.string params.name ), ( "description", Encode.string params.description ) ]

        Style params ->
            Encode.object [ ( "selector", Encode.string params.selector ) ]

        RuleBuilder params ->
            Encode.object [ ( "todo", Encode.string "" ) ]



-- TODO: figure out where the list of components should live


getDefaultComponentsFor : EntityClasses -> Components
getDefaultComponentsFor entity =
    allAvailableComponents
        |> Dict.filter
            (\k v ->
                case v of
                    Display { entities } ->
                        List.member ( entity, True ) entities

                    Style { entities } ->
                        List.member ( entity, True ) entities

                    RuleBuilder { entities } ->
                        List.member ( entity, True ) entities
            )



-- pull out entities into some custom dictionary
-- that i can call later.


allAvailableComponents : Components
allAvailableComponents =
    Dict.fromList
        [ ( "display"
          , Display
                { name = ""
                , description = ""
                , entities =
                    [ ( Item, True )
                    , ( Location, True )
                    , ( Character, False )
                    ]
                }
          )
        , ( "style"
          , Style
                { selector = ""
                , entities =
                    [ ( Item, False )
                    , ( Location, False )
                    , ( Character, True )
                    ]
                }
          )
        , ( "rule"
          , RuleBuilder
                { athing = ""
                , entities = [ ( Rule, True ) ]
                }
          )
        ]


getAvailableComponents : Components -> Components
getAvailableComponents components =
    Dict.diff allAvailableComponents components


getComponent : String -> Maybe Component
getComponent name =
    allAvailableComponents
        |> Dict.get name


getTitle : Components -> Maybe String
getTitle components =
    Components.Display.getTitle <| Dict.get "display" components
