module Dropdown.Common.View exposing (view, boolString, highlight)

import Dropdown.Types exposing (..)
import Json.Decode exposing (succeed)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)


view :
    ViewMethods group option selection
    -> Config group option selection
    -> Model group option
    -> selection
    -> Html (Msg group option selection)
view methods config model selection =
    div
        [ class <| "elm-dropdown " ++ methods.cssClass ]
        [ div
            [ class "elm-dropdown--container"
            , tabindex 0
            , attribute "role" "button"
            , attribute "aria-haspopup" "listbox"
            , attribute "aria-expanded" <| boolString <| isMenuOpen model
            , attribute "onfocusout" <| handleDescendantGainingFocus
            , onFocus <| handleContainerFocus model
            , on "focusout" <| succeed <| FocusStateMsg Blurred
            , onClick <| handleContainerClick model
            ]
            [ methods.placeholder config selection
            , ul
                [ class "elm-dropdown--list"
                , attribute "role" "listbox"
                , attribute "aria-label" <| config.selectionString selection
                ]
                (methods.items config model selection)
            ]
        ]


handleDescendantGainingFocus : String
handleDescendantGainingFocus =
    "if (event.relatedTarget && this.contains(event.relatedTarget)) { event.stopImmediatePropagation(); }"


handleContainerFocus : Model group option -> Msg group option selection
handleContainerFocus { focusState } =
    case focusState of
        Blurred ->
            FocusStateMsg Focused

        _ ->
            NoOp


handleContainerClick : Model group option -> Msg group option selection
handleContainerClick { focusState } =
    case focusState of
        Blurred ->
            FocusStateMsg (Open Initial)

        Focused ->
            FocusStateMsg (Open Initial)

        Open _ ->
            FocusStateMsg Blurred


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


highlight : ItemPosition group option -> Msg group option selection
highlight pos =
    FocusStateMsg (Open (Highlight pos))
