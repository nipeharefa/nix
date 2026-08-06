##################################################################
#                       Development shells
##################################################################
{ pkgs }:

{
  bun = pkgs.mkShell {
    buildInputs = [ pkgs.bun ];
  };
  fe = pkgs.mkShell {
    buildInputs = with pkgs; [
      nodejs_24
      yarn
      pnpm_10
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
      ruby_3_4
      postgresql_17
      gnumake
      gsl
      libxml2
      libyaml
    ];
  };
  php = pkgs.mkShell {
    buildInputs = with pkgs; [
      php83
      php83Packages.composer
      phpstan
      php83Packages.php-cs-fixer
      phpunit
    ];
    shellHook = ''
      echo "PHP dev shell ready (php $(php -v | head -n1))"
    '';
  };
  rust = pkgs.mkShell {
    buildInputs = with pkgs; [
      rustc
      cargo
      rustfmt
      clippy
      rust-analyzer
    ];
  };
}
