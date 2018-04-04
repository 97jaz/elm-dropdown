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

The `Msg` and `UpdateResult` types are practically the same as in the old version, and I'm not confident of the
approach here. All of uses of the old widget take some action when the menu's selection changes, but that's not
the only desirable mode of operation. For the multi-select widget, for example, it would be perfectly normal
(and arguably better) to wait until the menu closes before taking action on any change, but the current `UpdateResult`
only differentiates coarsely between changes to the selection and changes to the focus state of the widget. The client
could peer into the returned `FocusState` to figure out if the menu is closed, or we could provide functions on the model
to query if it's open or closed or whatnot, but the interesting question isn't "is the menu closed," but instead "was
the menu _just_ closed." And that's really a relational property of the previous and current models, which suggests
(to me, at least) that it's really the client app's responsibility. Even though that's kind of a pain in the ass.

The `Config` also makes my heart a bit heavy. The various `xxxHtml` functions are provided to allow clients to
customize the appearance of the menus, but they don't obviate the need for the corresponding `xxxString` functions,
since those are required for accessibility. Also: `placeholder` is not the best name here. It determines how the
always-visible portion of the menu appears. The word "placeholder" suggest that it's only used when there is no
current selection.

---

## Problems re-exporting type aliases

The division of the code into `Common`, on one hand, and `Single` (and `Multi` or `Checkbox` or whatever) on the other
is carried over from the older version. With the old code, you generally have to import both `Select` and `Select.Single`
to use the single select widget. I was hoping to avoid that need in this version, by having `Single` export all of the
types necessary to use it. You can see [here](src/Dropdown/Single.elm), for example:
```elm
type alias Config group option =
    T.Config group option option


type alias Msg group option =
    T.Msg group option option


type alias Model group option =
    T.Model group option


type alias UpdateResult group option =
    T.UpdateResult group option
```

Unfortunately, though, while the type aliases can be re-exported without trouble, re-exporting the value constructors
that are implicitly created by a `type` definition is not so straightforward. `UpdateResult` is a union type, but the
fact that I alias it above and expose `..` from the module does not expose its value constructors. So `Example.elm`
still needs to import `Types.elm`.


## The `group` type variable

The existing code allows the use of any type to represent a _group_ node in the menu item tree. The reason for this
was to facilitate a possible future feature where groups (and not just individual options) would be selectable. But
this choice has an unfortunate consequence. Most menus (and, in fact, _all_ of our uses of the old select widget) don't
use option groups, but a number of the types exposed here are polymorphic in `group` and the variable needs to be
instantiated to something concrete, because the `ItemPosition` type actually requires it. The root of the item tree
is always a group. Now that's just a restriction imposed by the current type definition, and it can be removed or
massaged, but the zipper code will become somewhat more complicated.

It would be nice if `group` could be instantiated by `Never` in cases where we don't need it, but we can't do that
now, because of the zipper issue.


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
