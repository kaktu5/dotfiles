module license_m {
  const spdx_dir = "@spdxTexts@"

  def spdx-ids []: nothing -> list<string> {
    %ls --short-names $spdx_dir | get name | sort
  }

  def find-license [spdx: string]: nothing -> oneof<path, nothing> {
    let target = $spdx | str lowercase
    let id = spdx-ids | where {|id| ($id | str lowercase) == $target } | get 0?
    if $id != null { $spdx_dir | path join $id }
  }

  # Initialize a license file
  export def license [
    spdx: string@spdx-ids # SPDX identifier
    --output(-o): path = "license" # Where to write the license
    --force(-f) # Overwrite the output file if it exists
  ]: nothing -> nothing {
    let file = find-license $spdx

    if $file == null {
      error make {
        msg: $"Unknown SPDX identifier: ($spdx)"
        label: {
          text: "not a known SPDX license"
          span: (metadata $spdx).span
        }
      }
    }

    open --raw $file | save --force=$force $output
  }
}
use license_m *
