# elm-dropdown draft

## Types

The first thing to look at is probably [Types.elm](src/Dropdown/Types.elm).

A dropdown's model contains two things:
- the items that it displays
- its "focus" state (which includes whether or not it's blurred, focused, or open, and, if it's open, what item,
if any, is currently highlighted).

In the future, it could also contain a user's query, which would be used to filter which items we display.

A menu item is either a single option or a group of items. Right now, only options are selectable;
as with the HTML `<select>` widget, option groups are not selectable. There's no way, right now,
to disable an option or an entire group of options. However, I think that would be straightforward to add.

The menu items are stored in the model as a tree zipper. (The type of this zipper is called `ItemPosition`.)
This is to allow efficient  keyboard navigation, though keyboard navigation isn't implemented yet. Storing the items
in the model itself is a change from the previous version of the widget, where the item list was separately passed
to the `view` function. The upside of this is one fewer parameter to keep track of, or need to build, just in time.
The downside is that if the user needs multiple menus that use the same options, then state is duplicated. That seems
like a fairly rare case to me.

The `Msg` type is practically the same as in the old version, and I've
abandoned the `UpdateResult` type. It's now the client's
responsibility to check if the selection has changed (assuming the
client cares). There's still no dead-simple way to take some action
when the menu closes (or opens). It's certainly possible, but it
requires the client to compare the old and new `FocusState`s of the
widget. We could, of course, provide utility functions for exactly
that purpose.

The `Config` also makes my heart a bit heavy. The various `xxxHtml` functions are provided to allow clients to
customize the appearance of the menus, but they don't obviate the need for the corresponding `xxxString` functions,
since those are required for accessibility. Also: `placeholder` is not the best name here. It determines how the
always-visible portion of the menu appears. The word "placeholder" suggest that it's only used when there is no
current selection.

---

## Ugly common types

Since the `group` type variable shows up all over, and since the common case is not to have groups at all, maybe
we should offer "flat" type aliases for the common case, like:
```elm
type alias FlatConfig option = Config Never option
type alias FlatModel option = Model Never option
-- etc.
```

## HTML element IDs

I tried to avoid the need for them in this version (and, in fact, the code doesn't use them thus far), but that's not
going to last. I think we're going to need to re-introduce them for accessibility reasons, if nothing else.


## Anything else

Maybe the basic approach here is bad. I'm open to any and all ideas.
