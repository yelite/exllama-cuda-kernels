{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  outputs = { self, utils, nixpkgs, ... }@inputs: utils.lib.mkFlake {
    inherit self inputs;

    supportedSystems = [ "x86_64-linux" ];

    channels.nixpkgs = {
      input = nixpkgs;
      config = {
        allowUnfree = true;
      };
    };

    outputsBuilder = channels:
      let
        pkgs = channels.nixpkgs;
        cudaPackages = pkgs.cudaPackages_11_7;
        cudatoolkit = cudaPackages.cudatoolkit;
      in
      {
        devShell = pkgs.mkShell
          {
            name = "exllama-kernels-dev-shell";

            nativeBuildInputs = with pkgs; [
              pkg-config
              cmake
            ];

            buildInputs = [
              cudatoolkit
            ];

            packages = with pkgs; [
              ninja
            ];

            hardeningDisable = [ "fortify" ];

            shellHook = ''
              export CUDA_HOME="${cudatoolkit}"
              # This is for NixOS, to add libcuda to ld path.
              export LD_LIBRARY_PATH="/var/run/opengl-driver/lib:$LD_LIBRARY_PATH"
            '';
          };
      };
  };
}
