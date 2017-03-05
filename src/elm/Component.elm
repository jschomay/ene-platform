module Component exposing (..)

import Types exposing (..)
import Html exposing (Html)
import Components.Display
import Components.Style
import Dict


view : String -> Component -> Html Msg
view componentName component =
    case component of
        Display attributes ->
            Components.Display.view componentName component

        Style attributes ->
            Components.Style.view componentName component



-- TODO: figure out where the list of components should live


allAvailableComponents : Components
allAvailableComponents =
    Dict.fromList
        [ ( "display", Display { name = "", description = "" } )
        , ( "style", Style { selector = "" } )
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
