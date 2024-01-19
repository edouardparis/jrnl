{
  description = "Neovim powered Journaling tool";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    f = "%Y/%m";
  in {
    packages.x86_64-linux.default = pkgs.stdenv.mkDerivation {
      name = "journal";
      src = self;
      buildInputs = [pkgs.neovim pkgs.dateutils];

      installPhase = ''
        mkdir -p $out/bin
        cp ${./nvimrc} $out/.nvimrc
        cp ${./setup.sh} $out/bin/setup.sh
        cat > $out/bin/journal <<EOF
        #!/usr/bin/env bash
        export dateutils_bin=${pkgs.dateutils}/bin
        export f='${f}'
        source $out/bin/setup.sh
        create_if_not_exist
        ${pkgs.neovim}/bin/nvim --cmd 'source $out/.nvimrc' -O \$(dates)
        EOF
        chmod +x $out/bin/journal
        chmod +x $out/bin/setup.sh
      '';
    };

    devShell.x86_64-linux = pkgs.mkShell {
      nativeBuildInputs = [self.packages.x86_64-linux.default];
    };
  };
}
