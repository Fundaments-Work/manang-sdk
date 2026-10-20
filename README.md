# manang-sdk

The plugin SDK for [Manang](https://github.com/Fundaments-Work/Manang), the
local-first scientific authoring suite. It is the home of the plugin interface
(WIT), the tool that turns a compiled plugin into a component, a worked example,
and the author documentation.

## Status

**Pre-release.** The plugin interface is `manang:plugin@0.2.0`. It is 0.x and
**unstable**: expect breaking changes between minor versions. Nothing here is
published to crates.io or npm. The content was imported from the Manang
repository on 2026-10-20 and the repository is private until launch.

What works today, by hand: build a Rust plugin for `wasm32-unknown-unknown`,
encode it as a component with `scripts/build-plugin.sh`, and copy the result into
Manang's plugins folder. Nothing in this repository has been automatically built
in CI yet; the only CI check is the WIT copy check below.

## Relation to Manang

The interface lives here, in `wit/plugin.wit`, and is meant to become the single
source of truth. Manang currently still carries its own copy
(`crates/manang-wasm-host/wit/plugin.wit`) and its own `sdk/`, `plugins/word-count`
and `scripts/build-plugin.sh`; those are removed from the app repository in a later
step. Until then, if the two WIT files differ, the Manang copy is what the app
loads.

## Layout

| Path | What it is |
| :--- | :--- |
| `wit/plugin.wit` | the `manang:plugin@0.2.0` WIT package (source of truth) |
| `wit/VERSION` | the interface version, `0.2.0` |
| `componentize/` | standalone Rust tool: core wasm module to component (`wit-component`) |
| `examples/word-count/` | a complete, self-contained example plugin |
| `scripts/build-plugin.sh` | builds a plugin crate into `<out>/<name>/{manifest.toml,plugin.wasm}` |
| `scripts/check-wit-copies.sh` | fails when a vendored WIT copy differs from `wit/plugin.wit` |
| `docs/plugin-guide.md` | the author guide (imported, being restructured) |
| `docs/publishing.md` | pointer to the registry repository's publishing guide |

## Build the example by hand

```sh
rustup target add wasm32-unknown-unknown
scripts/build-plugin.sh examples/word-count
# -> examples/word-count/dist/word-count/{manifest.toml,plugin.wasm}
```

Then copy `dist/word-count` to `<config>/manang/plugins/` (on Linux,
`~/.config/manang/plugins/`). This path has not been re-run from this repository
yet; it is the same script and tool as in the Manang repository with the tool path
adjusted.

## Not built yet

* the `manang-plugin` crate and its macros
* `manang-plugin-test` (a fake host for plugin tests)
* `cargo-manang` (new, build, pack, validate, dev, publish)
* the GitHub Action that builds and attaches a release archive
* a generated WIT reference

## Checks

`scripts/check-wit-copies.sh` is pure shell. It compares the example's vendored
`plugin.wit` with `wit/plugin.wit`, checks `wit/VERSION` against the package
version, and prints the sha256 of each file. CI runs only this script, and only
when `wit/**` or `examples/**` change.

## Related repositories

All under the `Fundaments-Work` organisation, all private for now.

* `Manang`: the application
* `manang-sdk`: this repository
* `manang-plugin-template`: a starter repository for a new plugin
* `manang-plugins-registry`: the list of published plugins and the signed-index tooling

## Licence

MIT OR Apache-2.0, at your option: see `LICENSE-MIT` and `LICENSE-APACHE`.
