module Dropdown.Types exposing (..)

import Html exposing (Html)


type Item group option
    = Option option
    | Group group (List (Item group option))


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
    { rootItemPosition : ItemPosition group option
    , focusState : FocusState group option
    }


type Msg group option selection
    = NoOp
    | FocusStateMsg (FocusState group option)
    | SelectMsg option


type UpdateResult group option
    = OptionSelected option (Model group option)
    | ModelChanged (Model group option)


type alias Config group option selection =
    { optionHtml : option -> Html (Msg group option selection)
    , optionString : option -> String
    , groupHtml : group -> Html (Msg group option selection)
    , groupString : group -> String
    , selectionHtml : selection -> Html (Msg group option selection)
    , selectionString : selection -> String
    , isSelected : option -> selection -> Bool
    }


type alias ViewMethods group option selection =
    { cssClass : String
    , placeholder : Config group option selection -> selection -> Html (Msg group option selection)
    , search : Config group option selection -> Model group option -> Html (Msg group option selection)
    , selectAll : Config group option selection -> Model group option -> Html (Msg group option selection)
    , items : Config group option selection -> Model group option -> selection -> List (Html (Msg group option selection))
    }


type alias UpdateMethods =
    { closeOnSelect : Bool }
