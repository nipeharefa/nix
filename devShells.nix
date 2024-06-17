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
        flyctl = pkgs.mkShell {
          buildInputs = [ pkgs.flyctl ];
        };
        swagger = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Swagger
            swagger-codegen3
            graphviz
            openapi-generator-cli
          ];
        };
        gcloud = pkgs.mkShell {
          buildInputs = with pkgs; [
            (google-cloud-sdk.withExtraComponents ([
              google-cloud-sdk.components.gke-gcloud-auth-plugin
            ]))
          ];
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
