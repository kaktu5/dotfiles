module license_m {
  def license-id []: string -> string {
    $in | path basename | str replace ".txt" ""
  }

  def find-license [id: string]: nothing -> string {
    let target = ($id | str lowercase)
    let matches: list<string> = (
      ls "@texts@"
      | get name
      | where {|f| ($f | license-id | str lowercase) == $target}
    )
    $matches | get 0?
  }

  export def "license find" [filter?: string]: nothing -> table<id: string> {
    let ids = (
      ls "@texts@"
      | get name
      | each {license-id}
      | sort
    )

    if ($filter | is-empty) {
      $ids | wrap id
    } else {
      $ids | where {$in | str contains -i $filter} | wrap id
    }
  }

  export def "license init" [
    id: string # SPDX identifier
    --output(-o): string = "license"
  ]: nothing -> nothing {
    let file = (find-license $id)

    if ($file | is-empty) {
      print -e $"Unknown SPDX identifier: ($id)"
      exit 1
    }

    cp $file $output
  }

  export def license []: nothing -> nothing {}
}
use license_m *
