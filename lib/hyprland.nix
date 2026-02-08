{lib}: let
  inherit (lib.generators) toJSON toLua;
  inherit (lib.strings) isString;
in {
  bind = flags: dispatcher: {inherit dispatcher flags;};

  dsp = method: arg: let
    argStr =
      if isNull arg
      then ""
      else if isString arg
      then toJSON {} arg
      else toLua {multiline = false;} arg;
  in "hl.dsp.${method}(${argStr})";
}
