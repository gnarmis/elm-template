## How to Structure Modules for Reuse

When the module is small enough, it's fine to let a single file hold all relevant code:

- Nri/
  - Button.elm

When the module gets more complex, break out each of the Elm architecture triad into its own file while keeping the top-level Elm file as the public interface to import:

- Nri/
  - Leaderboard.elm -- Expose Model, init, view, update, and other types/functions necessary for use
  - Leaderboard/
    - Model.elm
    - Update.elm
    - View.elm

Introduce `Flags.elm` (see below) and other submodules as necessary.

We don't have a metric to determine exactly when to move from a single-file module to a multi-file module: trust your gut feelings and aesthetics.

### Anti-pattern

Don't do: `Nri/Leaderboard/Main.elm` - the filename `Main.elm` is reserved for entrypoints under the `Page` namespace, so that we can run an automatic check during CI, which enforces the [stricter naming convention for modules under `Page`](./#examples-2).