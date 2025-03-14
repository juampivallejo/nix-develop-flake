{
  description = "nix devShell for development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
  };

  outputs = { self, nixpkgs, nixpkgs-python }:
    let
      allSystems = [
        "x86_64-linux" # 64bit AMD/Intel x86
        "aarch64-darwin" # 64bit ARM macOS
      ];

      forAllSystems = fn:
        nixpkgs.lib.genAttrs allSystems (system:
          fn {
            pkgs = import nixpkgs {
              inherit system;
              config = { allowUnfree = true; };
            };
            inherit system;
          });

      mkPythonEnv =
        { pkgs, system, pythonVersion ? "python312", py_packages ? [ ] }:
        let
          # Define the Python package to use
          python = pkgs.${pythonVersion};
        in pkgs.mkShell {
          name = "${pythonVersion} work shell";
          packages = [
            # Shell packages
            (python.withPackages (p:
              # Add pre installed packages
              map (pkg_name: p.${pkg_name}) py_packages))
          ];

          shellHook = ''
            export DIRENV=1
            source .env
            source .venv/bin/activate
          '';
        };

    in {
      # nix develop $FLAKE_PATH
      devShells = forAllSystems ({ pkgs, system }: {
        default = mkPythonEnv {
          inherit pkgs system;
          pythonVersion = "python312";
          py_packages = [ "ipdb" "pandas" "numpy" ];
        };
        python311 = mkPythonEnv {
          inherit pkgs system;
          pythonVersion = "python311";
        };
        python312 = mkPythonEnv {
          inherit pkgs system;
          pythonVersion = "python312";
        };
        python313 = mkPythonEnv {
          inherit pkgs system;
          pythonVersion = "python313";
        };
      });
    };
}

