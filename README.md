<h1 align="center">kaktu5/dotfiles</h1>
<p align="center">a nix flake containing configs for all of my machines</p>

## directory structure

```
dotfiles
├── docs        (flake documentation)
├── flake       (flake utilities)
├── hosts       (machine-specific configuration)
├── lib         (extension of `nixpkgs.lib`)
├── modules     (common configuration)
│   ├── common  (imported on all hosts)
│   ├── desktop (imported on all desktops)
│   ├── server  (imported on all servers)
│   └── profile (imported using `config.kkts.profiles`)
└── secrets     (age-encrypted secrets)
```

## flakes that inspired this configuration

[notashelf/nyx](https://github.com/notashelf/nyx)<br>
[poz/niksos](https://git.jacekpoz.pl/poz/niksos)<br>
[sioodmy/dotfiles](https://github.com/sioodmy/dotfiles)