# Contributing

The SDK is pre-release and being restructured, so please open an issue before a
large change.

* Do not edit `examples/word-count/wit/plugin.wit` by hand: it is a copy of
  `wit/plugin.wit`. Change the source, copy it, and run
  `scripts/check-wit-copies.sh`.
* Changing `wit/plugin.wit` changes the plugin interface. Bump `wit/VERSION` and
  the package version together, and note it in `CHANGELOG.md`.
* Use Conventional Commits (`feat(wit): ...`, `fix(scripts): ...`).
* Contributions are licensed under MIT OR Apache-2.0, like the rest of the repository.
