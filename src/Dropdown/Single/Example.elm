module Dropdown.Single.Example exposing (main)

import Dropdown.Types exposing (UpdateResult(..))
import Dropdown.Single as Single
import Html exposing (..)


type alias Model =
    { menuModel : Single.Model () MenuItem
    , selectedItem : MenuItem
    }


type alias State =
    { abbrev : String
    , name : String
    }


type MenuItem
    = StateItem State
    | Placeholder


type Msg
    = MenuMsg (Single.Msg () MenuItem)


states : List State
states =
    [ { abbrev = "MA", name = "Massachusetts" }
    , { abbrev = "NY", name = "New York" }
    , { abbrev = "WY", name = "Wyoming" }
    ]


items : List MenuItem
items =
    Placeholder :: (List.map StateItem states)


itemToString : MenuItem -> String
itemToString menuItem =
    case menuItem of
        Placeholder ->
            "Select a state"

        StateItem state ->
            state.name


config : Single.Config () MenuItem
config =
    Single.simpleConfig itemToString


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model =
            { menuModel = Single.flatModel items
            , selectedItem = Placeholder
            }
        , view = view
        , update = update
        }


view : Model -> Html Msg
view model =
    body
        []
        [ Single.view config model.menuModel model.selectedItem
            |> Html.map MenuMsg
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        MenuMsg subMsg ->
            case Single.update config subMsg model.menuModel of
                OptionSelected item menuModel ->
                    { model | selectedItem = item, menuModel = menuModel }

                ModelChanged menuModel ->
                    { model | menuModel = menuModel }
