{
  description = "Nix Flake for mia R package";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
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
