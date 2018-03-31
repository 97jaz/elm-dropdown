module Dropdown.Types exposing (..)

import Html exposing (Html)


type Item group option
    = Option option
    | Group group (List (Item option))


type FocusState group option
    = Blurred
    | Focused
    | Open (OpenState group option)


type OpenState group option
    = Initial
    | Highlight (ItemPosition group option)


type ItemPosition group option
    = ItemPosition (Item group option) (ItemPath group option)


type ItemPath group option
    = Top
    | Node group (List (Item group option)) (ItemPath group option) (List (Item group option))


type alias Model group option =
    { start : ItemPosition group option
    , focusState : FocusState group option
    }


type Msg group option selection
    = NoOp
    | FocusStateMsg (FocusState group option)


type alias Config option selection msg =
    { optionHtml : option -> Html msg
    , selectionHtml : selection -> Html msg
    , selectionString : selection -> String
    , selectOption : option -> selection -> selection
    , isSelected : option -> selection -> Bool
    }


type alias ViewMethods group option selection msg =
    { cssClass : String
    , placeholder : Config option selection msg -> selection -> Html msg
    , search : Config option selection msg -> Model group option -> Html msg
    , selectAll : Config option selection msg -> Model group option -> Html msg
    , items : Config option selection msg -> Model group option -> selection -> List (Html msg)
    }
