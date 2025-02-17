{pkgs, ...}: let
  inherit (pkgs) makeWrapper symlinkJoin zsh;
  zsh-config = import ./zsh {inherit pkgs;};
  zsh' =
    (symlinkJoin rec {
      name = "zsh";
      paths = [zsh];
      nativeBuildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/${name} \
          --set ZDOTDIR ${zsh-config}/bin
      '';
    })
    .overrideAttrs (_: {passthru.shellPath = "/bin/zsh";});
in {user.shell = zsh';}
