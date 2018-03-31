module Dropdown.Zipper exposing (..)

import Dropdown.Types exposing (..)


currentItem : ItemPosition group option -> Item group option
currentItem (ItemPosition item _) =
    item



-- BASIC TRAVERSAL


left : ItemPosition group option -> Maybe (ItemPosition group option)
left (ItemPosition item path) =
    case path of
        Node group (l :: left) up right ->
            Just (ItemPosition l (Node group left up (item :: right)))

        _ ->
            Nothing


right : ItemPosition group option -> Maybe (ItemPosition group option)
right (ItemPosition item path) =
    case path of
        Node group left up (r :: right) ->
            Just (ItemPosition r (Node group (item :: left) up right))

        _ ->
            Nothing


up : ItemPosition group option -> Maybe (ItemPosition group option)
up (ItemPosition item path) =
    case path of
        Node group left up right ->
            Just (ItemPosition (Group group (List.append (List.reverse left) (item :: right))) up)

        Top ->
            Nothing


down : ItemPosition group option -> Maybe (ItemPosition group option)
down (ItemPosition item path) =
    case item of
        Group group (x :: xs) ->
            Just (ItemPosition x (Node group [] path xs))

        _ ->
            Nothing


-- PREORDER TRAVERSAL

next : ItemPosition group option -> Maybe (ItemPosition group option)
next pos =
    down pos
        |> Maybe.orElseLazy (\_ -> right pos)
        |> Maybe.orElseLazy (\_ -> nextUp pos)


prev : ItemPosition group option -> Maybe (ItemPosition group option)
prev pos =
    left pos
        |> Maybe.andThen
