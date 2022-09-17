{ pkgs, lib, ... }:

let

        terraform = pkgs.mkShell {
            buildInputs = [
                pkgs.sops
                (pkgs.terraform.withPlugins (
                p: [
                    p.gitlab
                    p.github
                    p.sops
                    p.null
                ]
                ))
            ];
        };
in {
    devShells = terraform;
}