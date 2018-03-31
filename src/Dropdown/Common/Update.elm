module Dropdown.Common.Update exposing (update)

import Dropdown.Types exposing (..)
import Dropdown.Zipper as Zipper


update :
    UpdateMethods
    -> Config group option selection
    -> Msg group option selection
    -> Model group option
    -> UpdateResult group option
update methods config msg model =
    case msg of
        NoOp ->
            ModelChanged model

        FocusStateMsg focusState ->
            ModelChanged { model | focusState = focusState }

        SelectMsg option ->
            OptionSelected option (modelOnSelect methods model)


modelOnSelect : UpdateMethods -> Model group option -> Model group option
modelOnSelect methods model =
    if methods.closeOnSelect then
        { model | focusState = Focused }
    else
        model
