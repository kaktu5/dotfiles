{lib}: let
  inherit (builtins) div;
  inherit (lib.lists) zipListsWith;
  inherit (lib.strings) concatStringsSep fixedWidthString;
in {
  # https://howardhinnant.github.io/date_algorithms.html#civil_from_days
  unstableVersion = timestamp: let
    days = div timestamp 86400;
    z = days + 719468;
    era =
      div (
        if z >= 0
        then z
        else z - 146096
      )
      146097;
    doe = z - era * 146097;
    yoe = div (doe - div doe 1460 + div doe 36524 - div doe 146096) 365;
    y = yoe + era * 400;
    doy = doe - (365 * yoe + div yoe 4 - div yoe 100);
    mp = div (5 * doy + 2) 153;
    d = doy - div (153 * mp + 2) 5 + 1;
    m =
      if mp < 10
      then mp + 3
      else mp - 9;
    year =
      y
      + (
        if m <= 2
        then 1
        else 0
      );
    date =
      [year m d]
      |> zipListsWith (w: v: fixedWidthString w "0" (toString v)) [4 2 2]
      |> concatStringsSep "-";
  in
    "0-unstable-" + date;
}
