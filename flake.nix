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
      mkScript = { pkgs, sname, scriptText }:
        let
          buildIn = with pkgs; [ terraform ];
          script = pkgs.writeShellScriptBin sname scriptText;
        in
        pkgs.symlinkJoin {
          name = sname;
          paths = [ script ] ++ buildIn;
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = "wrapProgram $out/bin/${sname} --prefix PATH : $out/bin";
        };
    in
    {
      packages = forAllSystems ({ pkgs }: {
        pre-plan = mkScript {
          inherit pkgs;
          sname = "pre-plan";
          scriptText = ''
            terraform -chdir=gcp/ init > /dev/null
            terraform -chdir=gcp/ plan -out tfplan
          '';
        };
        pre-apply = mkScript {
          inherit pkgs;
          sname = "pre-apply";
          scriptText = ''
            terraform -chdir=gcp/ init > /dev/null
            if [[ ! -f gcp/tfplan ]]; then
                echo "No plan file found, planning..."
                terraform -chdir=gcp/ plan -out tfplan
            fi
            terraform -chdir=gcp/ apply
          '';
        };
        apply = mkScript {
          inherit pkgs;
          sname = "apply";
          scriptText = ''
            terraform -chdir=confluent/ init > /dev/null
            if [[ ! -f gcp/tfplan ]]; then
                echo "No plan file found, planning..."
                terraform -chdir=confluent/ plan -out tfplan
            fi
            terraform -chdir=confluent/ apply
          '';
        };
        plan = mkScript {
          inherit pkgs;
          sname = "plan";
          scriptText = ''
            terraform -chdir=confluent/ init > /dev/null
            terraform -chdir=confluent/ plan -out tfplan
          '';
        };
      });
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

