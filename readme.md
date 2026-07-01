<!-- markdownlint-disable first-line-heading line-length no-inline-html -->

<div align="center">
    <h1><pre>dotfiles</pre></h1>
    <p>A Nix flake containing configurations for all of my systems.</p>
</div>

## Directory structure

```
.
├── components/          - Non-Nix assets
├── flake/               - Flake outputs
├── hosts/               - Per-host configurations
├── lib/                 - An extension of nixpkgs.lib
├── modules/             - NixOS configuration modules
│   ├── core/            - Core modules imported by all hosts
│   ├── options/         - Custom options declarations
│   ├── profiles/        - Optional modules enabled in each host's profile.nix
│   ├── shared/          - Common modules shared between traits
│   └── traits/          - Hardware and role-specific module groups
│       ├── bare-metal/
│       ├── graphical/
│       ├── headless/
│       ├── laptop/
│       ├── microvm/
│       ├── server/
│       └── workstation/
├── pkgs/                - Custom package collection
└── secrets/             - Encrypted secrets managed via nix-secrets
```

## Related projects

- [nf](https://radicle.network/nodes/rosa.radicle.network/rad:z3EZi6d3LccUz1s6UmMfuoPJfMdZ) - my personal Neovim
  configuration

## Software

Couldn't have made this setup without the software from the people below, thanks all of you:

- [feel-co](https://github.com/feel-co)
- [manic-systems](https://github.com/manic-systems)
- [NotAShelf](https://github.com/notashelf)

## Inspiration

Flakes and configs I learned and "borrowed" from:

- [fufexan/nix-gaming](https://github.com/fufexan/nix-gaming)
- [notashelf/nyx](https://github.com/notashelf/nyx)
- [poz/niksos](https://nix.poz.pet)
- [sioodmy/dotfiles](https://github.com/sioodmy/dotfiles)

## License

This project is licensed under the Mozilla Public License Version 2.0. See the [license](license) file for details.
