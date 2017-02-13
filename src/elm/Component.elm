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


getAvailableComponents : Components -> Components
getAvailableComponents components =
    let
        allAvailableComponents =
            Dict.fromList
                [ ( "display", Display { name = "", description = "" } )
                , ( "style", Style { selector = "" } )
                ]
    in
        Dict.diff allAvailableComponents components
