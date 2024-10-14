{
  description = "Nix Flake for mia R package";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    scater-flake.url = "github:artur-sannikov/scater/nix-flakes";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      scater-flake,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [
          (final: prev: {
            rPackages = prev.rPackages // {
              # Force scater to be the bleeding-edge version
              scater = scater-flake.packages.${system}.default;
            };
          })
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        mia = pkgs.rPackages.buildRPackage {
          name = "mia";
          src = self;
          propagatedBuildInputs = builtins.attrValues {
            inherit (pkgs.rPackages)
              ape
              BiocGenerics
              BiocParallel
              Biostrings
              bluster
              DECIPHER
              decontam
              DelayedArray
              DelayedMatrixStats
              DirichletMultinomial
              dplyr
              IRanges
              MASS
              MatrixGenerics
              mediation
              MultiAssayExperiment
              rbiom
              rlang
              S4Vectors
              scater
              scuttle
              SingleCellExperiment
              SummarizedExperiment
              tibble
              tidyr
              TreeSummarizedExperiment
              vegan
              ;
          };
        };
      in
      {
        packages.default = mia;
        devShells.default = pkgs.mkShell {
          buildInputs = [ mia ];
          inputsFrom = pkgs.lib.singleton mia;
        };
      }
    );
}
