{lib}: let
  inherit (lib) concatStringsSep;
in {
  ls = "lsd -1F --group-dirs first --date +'%H:%M:%S %d-%m-%Y'";
  la = "ls -lA";
  lt = "ls --tree";
  cp = "cp -r";
  scp = "scp -r";
  mkdir = "mkdir -p";
  grep = "rg";
  cat = "bat --paging never --style numbers,changes --theme base16";
  less = "cat --paging always";
  du = "dust -xT $(nproc)";
  df = "duf -hide special";
  diff = "diff --color auto";
  ip = "ip --color=auto";
  tmux-kill-inactive = concatStringsSep " " [
    "tmux list-sessions -F '#{session_attached} #{session_id}'"
    "| awk '/^0/{print \\$2}'"
    "| xargs -n 1 tmux kill-session -t"
  ];
}
