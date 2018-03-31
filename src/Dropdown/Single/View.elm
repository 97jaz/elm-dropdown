module Dropdown.Single.View exposing (viewMethods)

import Dropdown.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


viewMethods : ViewMethods group option selection msg
viewMethods =
    { cssClass = "single-select"
    , placeholder = placeholder
    , search = search
    , selectAll = selectAll
    , items = items
    }


placeholder : Config group option selection msg -> selection -> Html msg
placeholder config selection =
    div [ class "placeholder" ] [ config.selectionHtml selection ]


search : Config group option selection msg -> Model group option -> Html msg
search config model =
    text ""


selectAll : Config group option selection msg -> Model group option -> Html msg
selectAll config model =
    text ""


items : Config option selection msg -> Model group option -> selection -> List (Html msg)
items config model selection =
    case model.start of
        Option option ->
