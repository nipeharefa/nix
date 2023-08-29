##################################################################
#                       Development shells
##################################################################
{ self, ... }:

{
  perSystem =
    { pkgs, config, ... }:
    {
      devShells = {
        bun = pkgs.mkShell {
          buildInputs = [ pkgs.bun ];
        };
        fe = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_20
            yarn
            nodePackages.pnpm
          ];
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
            gsl
            libxml2
            libyaml
          ];
        };
        php = pkgs.mkShell {
          buildInputs = with pkgs; [
            php83
            composer
            php83Packages.phpstan
            php83Packages.php-cs-fixer
            php83Packages.phpunit
          ];
          shellHook = ''
            echo "PHP dev shell ready (php $(php -v | head -n1))"
          '';
        };
      };
    };
}
