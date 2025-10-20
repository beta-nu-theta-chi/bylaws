{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    gitignore.url = "github:hercules-ci/gitignore.nix";
    branding.url = "github:beta-nu-theta-chi/branding";
  };
  outputs = {...} @ inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = (import inputs.nixpkgs) {
          inherit system;
          config = {
            # allowUnfree = true;
            # allowBroken = true;
          };
        };
        rpkgs = with pkgs.rPackages; [
          stringr
          stringi
        ];
        p = with pkgs; [
          podman-compose
          podman
          (quarto.override {
            extraRPackages = rpkgs;
          })
          (rWrapper.override {
            packages = rpkgs;
          })
          librsvg
          texliveFull
          texworks
          texstudio
          ghostscript
          (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
            pip
            pyyaml
          ]))
        ];
      in {
        devShells = rec {
          rShell = pkgs.mkShell {
            packages = p;
          };
          default = rShell;
        };
        formatter = let
          treefmtconfig = inputs.treefmt-nix.lib.evalModule pkgs {
            projectRootFile = "flake.nix";
            programs = {
              toml-sort.enable = true;
              yamlfmt.enable = true;
              mdformat.enable = true;
              prettier.enable = true;
              shellcheck.enable = true;
              shfmt.enable = true;
            };
            settings.formatter.shellcheck.excludes = [".envrc"];
            settings.formatter.mdformat.includes = ["*.qmd"];
          };
        in
          treefmtconfig.config.build.wrapper;
        apps = rec {
        };
        packages = rec {
          branding = pkgs.callPackage ./nix/source.nix { branding = inputs.branding.packages.${system}.branding-white; };
          book = pkgs.callPackage ./nix/build.nix { buildenv = p; src = branding; };
          deploy = pkgs.callPackage ./nix/deploy.nix { src = book; };
          default = book;
        };
      }
    );
}
