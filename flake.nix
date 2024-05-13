{
  description = "Terraform and GKE for CFK";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = fn: nixpkgs.lib.genAttrs systems
        (system: fn {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        });
    in
    {
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShellNoCC {
          name = "tf-gcloud";
          packages = with pkgs; [
            terraform
            #kubectl
            #kubernetes-helm
            #kind
            procps
            google-cloud-sdk

          ];
        };
      });
    };
}

