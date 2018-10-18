## Our Rules
- Anything that goes in Page is not meant to be reusable. 
- always start with `RouteName/Main.elm` but you can `RouteName/Main.elm, RouteName/Update.elm, etc.`. Only break things out when necessary.

### `Page.`
`Page.Writing.Rate.Main`, `Page.Writing.Rate.Update`, `Page.Writing.Rate.Model.Decoder`

A page on the site, which has its own URL. These are not reusable, and implemented using a combination of types from `Data` and modules from `Nri`. Comments for usage instructions aren't required, as code isn't intended to be reusable.

The module name should follow the URL. Naming after the URL is subject to [How to Structure Modules for A Page](#how-to-structure-modules-for-a-page). The purpose of this convention is so when you have a URL, you can easily figure out where to find the module.

If a module ends with `Main`, everything between `Page` and `Main` **MUST** correspond to a URL.

#### Examples
- `Page.Admin.RelevantTerms.Main` corresponds to the URL `/admin/relevant_terms`.
- `Page.Learn.ChooseSourceMaterials.Main` corresponds to the URL `/learn/choose_source_materials`.
- `Page.Preferences.Main` corresponds to the URL `/preferences`.
- `Page.Teacher.Courses.Assignments.Main` corresponds to the URL `/teach/courses/:id/assignments`.
    N.B. The `/:id` is dropped from the module name to avoid too much complexity.

#### Non-examples
- `Page.Mastery.Main` corresponds to no URL. We would expect `/mastery` to exist, but it doesn't. Finding the module from the URL will be hard.
- `Page.Teach.WritingCycles.Rate.Main` corresponds to no URL. We would expect `/teach/writing_cycles/rate` or `/teach/writing_cycles/:id/rate` to exist, but neither do. Finding the module from the URL will be hard.
