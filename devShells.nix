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
      };
    };
}
