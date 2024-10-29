{
  resholve,
  resholve-utils,
  writeText,
}: let
  builderResholve = resholve.overrideAttrs (oldAttrs: {
    meta = (oldAttrs.meta or {}) // {knownVulnerabilities = [];};
    patches =
      (oldAttrs.patches or [])
      ++ [
        (writeText "resholve-patch-unwrap-aliases-with-eq-sign" ''
          diff --git a/resholve b/resholve
          index c163fa9..e0581bc 100755
          --- a/resholve
          +++ b/resholve
          @@ -3506,7 +3506,7 @@ class RecordCommandlike(object):
                       if word.ok:
                           # not dynamic; more examples in tests/aliases.sh, but:
                           # 'd', 'echo $SOURCE_DATE_EPOCH'
          -                alias, definition = word.strip("\"='").split("=")
          +                alias, definition = word.strip("\"='").split("=", 1)
                           # TODO: maybe below deserves an explicit API
                           cmdlikes[alias].alias = True
                           commandlike = definition.split()[0]
        '')
      ];
  });
in
  resholve.override {
    resholve = builderResholve;
    resholve-utils = resholve-utils.override {resholve = builderResholve;};
  }
