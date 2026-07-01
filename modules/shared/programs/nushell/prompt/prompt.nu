module prompt {
  def style [opts: record]: string -> string {
    $"(ansi $opts)($in)(ansi reset)"
  }

  def col [color: string]: string -> string {
    $in | style { fg: $color }
  }

  def seg [cond: bool]: string -> string {
    if $cond { $in } else { "" }
  }

  def join-segments [sep: string]: list<string> -> string {
    $in | where {|s| not ($s | is-empty) } | str join $sep
  }

  def duration []: int -> string {
    def div-floor [divisor: int]: int -> int {
      $in / $divisor | math floor | into int
    }

    let secs = $in | div-floor 1000

    let counts = {
      h: ($secs | div-floor 3600),
      m: ($secs mod 3600 | div-floor 60),
      s: ($secs mod 60)
    }

    let formatted = $counts
      | items {|unit, value| if $value > 0 { $"($value)($unit)" } }
      | compact
      | str join ""

    if ($formatted | is-empty) { "0s" } else { $formatted }
  }

  def short-path []: nothing -> string {
    let home = $env.HOME? | default ""
    let in_home = (not ($home | is-empty)) and ($env.PWD | str starts-with $home)
    let display = if $in_home { $env.PWD | str replace $home "~" } else { $env.PWD }

    let parts = $display | path split | where {|p| $p not-in ["/" ""] }

    if ($parts | length) <= 4 {
      $display
    } else {
      let ellipsis = if $in_home { "~/.../" } else { "/.../" }
      $"($ellipsis)($parts | last 4 | path join)"
    }
  }

  def status-line []: int -> string {
    let exit_code = $in
    let icon = $" ($exit_code)" | col "@red@"
    $"($icon)\n" | seg ($exit_code != 0)
  }

  def directory []: nothing -> string {
    let writable = (^test -w $env.PWD | complete).exit_code == 0
    let lock_icon = " " | col "@fg0@" | seg (not $writable)
    $"($lock_icon)(short-path | col "@purple@")"
  }

  def nix-shell []: nothing -> string {
    let active = $env.IN_NIX_SHELL? != null
    let level = $env.NIX_SHELL_LEVEL? | default "1"
    let label = if $level == "1" { "shell" } else { $"shell[($level)]" }
    ($"󱄅 ($label)" | col "@blue@") | seg $active
  }

  def duration-indicator []: int -> string {
    let ms = $in
    ($ms | duration | col "@fg0@") | seg ($ms >= 2000)
  }

  export-env {
    let user_host = [
      ("@userName@" | style { fg: "@purple@" }),
      ("@" | style { fg: "@fg0" }),
      ("@hostName@" | style { fg: "@purple@" }),
    ] | str join

    let indicator = "󰘧 " | col "@fg0@"

    $env.config.cursor_shape = {
      vi_insert: "line",
      vi_normal: "block",
    }

    $env.PROMPT_MULTILINE_INDICATOR = ""
    $env.PROMPT_INDICATOR = $indicator
    $env.PROMPT_INDICATOR_VI_INSERT = $indicator
    $env.PROMPT_INDICATOR_VI_NORMAL = $indicator

    $env.PROMPT_COMMAND = {||
      let status = ($env.LAST_EXIT_CODE? | default 0) | status-line

      let info = [
        $user_host
        (directory)
        (nix-shell)
        (($env.CMD_DURATION_MS? | default "0" | into int) | duration-indicator)
      ] | join-segments " "

      $"($status)($info)\n"
    }

    $env.PROMPT_COMMAND_RIGHT = {|| "" }
  }
}
use prompt
