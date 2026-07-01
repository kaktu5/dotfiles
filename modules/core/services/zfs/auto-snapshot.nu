def get-datasets []: nothing -> list<string> {
  ^zfs get -H -o name,value -t filesystem,volume com.sun:auto-snapshot
    | lines
    | parse "{name}\t{value}"
    | where value == "true"
    | get name
}

def snapshot-datasets [label: string, datasets: list<string>] {
  let date = (date now | format date "%Y-%m-%d")
  for dataset in $datasets {
    let snapshot_name = $"($dataset)@auto-($label)-($date)"
    print $"creating ($snapshot_name)"
    ^zfs snapshot $snapshot_name
  }
}

def prune-datasets [label: string, keep: int, datasets: list<string>] {
  for dataset in $datasets {
    let snapshots = (^zfs list -H -o name -t snapshot -s creation $dataset
      | lines
      | where {|s| $s | str starts-with $"($dataset)@auto-($label)-"}
    )
    if ($snapshots | length) <= $keep {
      continue
    }
    $snapshots
      | take (($snapshots | length) - $keep)
      | each {|s|
          print $"destroying ($s)"
          ^zfs destroy $s
        }
  }
}

def main [label: string] {
  let keep = ($CONFIG | get $label)
  let datasets = (get-datasets)
  snapshot-datasets $label $datasets
  prune-datasets $label $keep $datasets
}
