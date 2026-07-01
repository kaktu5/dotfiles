# Count Lines Of Code
def cloc [
  path: path = "." # Directory to scan
]: nothing -> table<ext: oneof<string, nothing>, files: int, lines: int, avg: float> {
  cd $path
  ^"@fd@" --hidden --type file
  | lines
  | par-each {|f|
    let lines = try { open --raw $f | lines | length } catch { null }
    let ext = $f | path parse | get extension | str lowercase
    { ext: $ext, lines: $lines }
  }
  | where lines != null
  | group-by ext
  | items {|ext rows|
    let lines = $rows | get lines
    {
      ext: ($ext | default --empty null),
      files: ($lines | length),
      lines: ($lines | math sum),
      avg: ($lines | math avg | math round --precision 2),
    }
  }
  | sort-by lines --reverse
}
