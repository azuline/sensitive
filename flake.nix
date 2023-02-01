{
  description = "sensitive - a toolchain to securely store and access sensitive files on a computer";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlay = self: super: {
          # Create a custom Python derivation with the dependencies we need to
          # run sensitive.
          python = super.python310.buildEnv.override {
            extraLibs = with super.python310.pkgs; [
              click
            ];
          };
        };
        # Add the custom Python derivation to our pkgs.
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
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
          propagatedBuildInputs = [
            pkgs.python.pkgs.click
            pkgs.bubblewrap
            pkgs.tomb
          ];
          meta = {
            description = "a toolchain to securely store and access sensitive files on a computer";
            homepage = "https://github.com/azuline/sensitive";
            license = nixpkgs.lib.licenses.apache20;
          };
        };
        devShell = pkgs.mkShell {
          buildInputs = [
            (pkgs.buildEnv {
              name = "sensitive-env";
              paths = with pkgs; [
                python
                bubblewrap
                tomb
              ];
            })
          ];
        };
      }
    );
}
