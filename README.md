<h1 align="center">kaktu5/dotfiles</h1>
<p align="center">a nix flake containing configs for all of my machines</p>

## directory structure

```
dotfiles
├── docs        (flake documentation)
├── hosts       (machine-specific configuration)
├── lib         (extension of `nixpkgs.lib`)
├── modules     (common configuration)
│   ├── common  (imported on all hosts)
│   ├── desktop (imported on all desktops)
│   ├── server  (imported on all servers)
│   └── profile (imported in a host's `profile.nix`)
└── secrets     (age-encrypted secrets)
```

## flakes I took inspiration from

[poz/niksos](https://git.jacekpoz.pl/poz/niksos)