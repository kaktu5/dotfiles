<div style="text-align: center;">
    <h1>kaktu5/dotfiles</h1>
    nix flake containing configurations for all my systems
</div>

## directory structure

```
dotfiles
├── docs        - flake documentation
├── flake       - flake utilities
├── hosts       - host-specific configuration
├── lib         - extension of `nixpkgs.lib`
├── modules     - common modules
│   ├── common  - imported on all hosts
│   ├── desktop - imported on all desktops
│   ├── server  - imported on all servers
│   └── profile - imported in host's `profile.nix`
├── resources   - other files
├── secrets     - age-encrypted secrets
└── system      - common configuration
    ├── common  - imported on all hosts
    ├── desktop - imported on all desktops
    ├── server  - imported on all servers
    └── profile - imported in host's `profile.nix`
```

## credits

- [notashelf/nyx](https://github.com/notashelf/nyx)
- [poz/niksos](https://git.jacekpoz.pl/poz/niksos)
- [sioodmy/dotfiles](https://github.com/sioodmy/dotfiles)