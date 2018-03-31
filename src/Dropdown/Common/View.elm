module Dropdown.Common.View exposing (view)

import Dropdown.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)


view :
    ViewMethods group option selection msg
    -> Config option selection msg
    -> Model group option
    -> Selection option selection
    -> Html msg
view config methods model selection =
    div
        [ class <| "elm-dropdown " ++ methods.cssClass ]
        [ div
            [ class "elm-dropdown--container"
            , tabindex 0
            , attribute "role" "button"
            , attribute "aria-expanded" <| boolString <| isMenuOpen model
            , attribute "aria-label" <| config.selectionString selection
            , attribute "onfocusout" <| handleDescendantGainingFocus model
            , onFocus handleContainerFocus
            ]
            [ methods.placeholder config selection ]
        , ul
            [ class "elm-dropdown--list"
            , attribute "role" "menu"
            ]
            [ methods.search config model selection
            , methods.selectAll config model selection
            ]
            ++ (methods.items config model selection)
        ]


handleDescendantGainingFocus : String
handleDescendantGainingFocus =
    "if (event.target && this.contains(event.target)) { event.stopImmediatePropagation(); }"


handleContainerFocus : Model group option -> Msg group option selection
handleContainerFocus { focusState } =
    case focusState of
        Blurred ->
            FocusStateMsg Focused

        _ ->
            NoOp


boolString : Bool -> String
boolString bool =
    if bool then
        "true"
    else
        "false"


isMenuOpen : Model group option -> Bool
isMenuOpen { focusState } =
    case focusState of
        Open _ ->
            True

        _ ->
            False
