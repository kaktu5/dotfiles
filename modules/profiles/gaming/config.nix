{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.profiles) gaming;
  inherit (lib.kkts.dag) entryAnywhere;
  inherit (lib.meta) getExe';
  inherit (lib.modules) mkIf;
  inherit (pkgs) wireplumber;
in
  mkIf gaming.enable {
    boot.kernelModules = ["ntsync"];

    kkts.programs.hyprland.extraEntries.mute-unfocused-game-windows = entryAnywhere ''
      do
        local muted_pids = {}

        local function update_mutes(awin)
          for _, win in ipairs(hl.get_windows()) do
            if win.xdg_tag == "proton-game" then
              local should_be_muted = (win.pid ~= awin.pid)
              if muted_pids[win.pid] ~= should_be_muted then
                hl.exec_cmd(string.format("${getExe' wireplumber "wpctl"} set-mute -p %d %s", win.pid, should_be_muted and "1" or "0"))
                muted_pids[win.pid] = should_be_muted
              end
            end
          end
        end

        hl.on("window.active", update_mutes)
        hl.on("window.open", function() update_mutes(hl.get_active_window()) end)
        hl.on("window.close", function(win) muted_pids[win.pid] = nil end)
      end
    '';
  }
