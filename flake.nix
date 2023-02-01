{
  description = "sensitive - a toolchain to securely store and access sensitive files";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pylibs-prod = p: with p; [
          click
        ];
        pylibs-dev = p: (pylibs-prod p) ++ (with p; [
          black
          mypy
        ]);
        # Create a custom Python derivation with the dependencies we need to
        # run sensitive. Add that derivation to `pkgs` via an overlay.
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (self: super: {
              python = super.python310.withPackages pylibs-prod;
              python-dev = super.python310.withPackages pylibs-dev;
            })
          ];
        };
        # These are non-Python dependencies that we need.
        extDeps = with pkgs; [
          bubblewrap
          tomb
        ];
        extDevDeps = extDeps ++ (with pkgs; [
          ruff
        ]);
      in
      rec {
        defaultApp = {
          type = "app";
          program = "${defaultPackage}/bin/sensitive";
        };
        defaultPackage = pkgs.python.pkgs.buildPythonPackage {
          pname = "sensitive";
          version = "0.1.0";
          src = ./.;
          vendorSha256 = "sha256-O9u8ThzGOcfWrDjA87RaOPez8pfqUo+AcciSSAw2sfk=";
          propagatedBuildInputs = extDeps ++ pylibs-prod pkgs.python.pkgs;
          meta = {
            description = "a toolchain to securely store and access sensitive files";
            homepage = "https://github.com/azuline/sensitive";
            license = nixpkgs.lib.licenses.gpl3Only;
          };
        };
        devShell = pkgs.mkShell {
          buildInputs = [
            (pkgs.buildEnv {
              name = "sensitive-env";
              paths = extDevDeps ++ [ pkgs.python-dev ];
            })
          ];
        };
      }
    );
}
