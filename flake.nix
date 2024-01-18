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
        cp ${./.nvimrc} $out/.nvimrc
        cat > $out/bin/journal <<EOF
        #!/usr/bin/env bash
        ${pkgs.neovim}/bin/nvim --cmd 'source $out/.nvimrc' -O \$(
          ${pkgs.dateutils}/bin/dateseq \
              "\$(date --date "2 months ago" +${f})" \
              "\$(date --date "2 months" +${f})" \
              -i ${f} \
              -f ${f}
        )
        EOF
        chmod +x $out/bin/journal
      '';
    };

    devShell.x86_64-linux = pkgs.mkShell {
      nativeBuildInputs = [self.packages.x86_64-linux.default];
    };
  };
}
