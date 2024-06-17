##################################################################
#                       Development shells
##################################################################
{ self, ... }:

{
  perSystem = { pkgs, config, ... }:
    {
      devShells = {
        bun = pkgs.mkShell {
          buildInputs = [ pkgs.bun ];
        };
        rails = pkgs.mkShell {
          buildInputs = with pkgs; [
            ruby_3_2
            postgresql_12
            gnumake
            libxml2
            rubyfmt
            libyaml
          ];
        };
      };
    };
}
