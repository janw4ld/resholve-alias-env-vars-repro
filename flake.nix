{
  description = "resholve env var aliases repro";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        my-resholve = let
          resholve-utils-src = "${nixpkgs}/pkgs/development/misc/resholve/resholve-utils.nix";
        in
          pkgs.callPackage ./resholve.nix
          {resholve-utils = pkgs.callPackage resholve-utils-src {};};
      in {
        packages.default = self.packages.${system}.aliases-demo;
        packages.aliases-demo = let
          pname = "ls-us-east-1";
          execPath = "bin/${pname}";
        in
          my-resholve.mkDerivation {
            inherit pname;
            version = "0.1.0";
            src = pkgs.writeText "demo-bash-script" ''
              shopt -s expand_aliases

              # this parses and runs correctly
              alias ssh_prod='cd $(AWS_REGION=us-east-1 echo $PWD)'
              ssh_prod

              # this fails to parse
              alias ls_use1='AWS_REGION=us-east-1 ls'
              ls_use1
            '';
            solutions.default = {
              interpreter = pkgs.lib.getExe pkgs.bashInteractive;
              scripts = [execPath];
              inputs = [];
              fix.aliases = true;
            };
            meta.mainProgram = pname;
            dontUnpack = true;
            installPhase = ''install -Dm755 $src $out/${execPath}'';
          };
      }
    );
}
