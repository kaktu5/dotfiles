<style>h1, p {text-align = "center";}</style>
<h1>kaktu5/dotfiles</h1>
<p>a nix flake containing configs for all of my machines</p>

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

## flakes I took inspiration from

[github:notashelf/nyx](https://github.com/notashelf/nyx)<br>
[git.poz.pet:poz/niksos](https://git.jacekpoz.pl/poz/niksos)<br>
[github:sioodmy/dotfiles](https://github.com/sioodmy/dotfiles)