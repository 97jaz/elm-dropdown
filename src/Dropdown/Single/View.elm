module Dropdown.Single.View exposing (viewMethods)

import Dropdown.Common.View exposing (boolString, highlight)
import Dropdown.Types exposing (..)
import Dropdown.Zipper as Zipper
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


viewMethods : ViewMethods group option selection
viewMethods =
    { cssClass = "single-select"
    , placeholder = placeholder
    , search = search
    , selectAll = selectAll
    , items = items
    }


placeholder : Config group option selection -> selection -> Html (Msg group option selection)
placeholder config selection =
    div [ class "placeholder" ] [ config.selectionHtml selection ]


search : Config group option selection -> Model group option -> Html (Msg group option selection)
search config model =
    text ""


selectAll : Config group option selection -> Model group option -> Html (Msg group option selection)
selectAll config model =
    text ""


items : Config group option selection -> Model group option -> selection -> List (Html (Msg group option selection))
items config model selection =
    Zipper.mapChildren (itemView config model selection) model.rootItemPosition


itemView : Config group option selection -> Model group option -> selection -> ItemPosition group option -> Html (Msg group option selection)
itemView config model selection pos =
    case Zipper.currentItem pos of
        Option option ->
            optionView config model selection pos option

        Group group items ->
            groupView config model selection pos group items


optionView : Config group option selection -> Model group option -> selection -> ItemPosition group option -> option -> Html (Msg group option selection)
optionView config model selection pos option =
    li
        [ class "single-select-option"
        , tabindex -1
        , attribute "role" "option"
        , attribute "aria-label" <| config.optionString option
        , attribute "aria-selected" <| boolString <| config.isSelected option selection
        , onMouseEnter <| highlight pos
        , onClick <| SelectMsg option
        ]
        [ config.optionHtml option ]


groupView : Config group option selection -> Model group option -> selection -> ItemPosition group option -> group -> List (Item group option) -> Html (Msg group option selection)
groupView config model selection pos group items =
    li
        [ class "single-select-group" ]
        [ config.groupHtml group
        , ul
            [ attribute "aria-label" <| config.groupString group ]
            (Zipper.mapChildren (itemView config model selection) pos)
        ]
