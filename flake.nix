{
  description = "Neovim powered Journaling tool";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
    neovim = {
      url = "github:neovim/neovim/stable?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    neovim,
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    f = "%Y/%m";
  in {
    packages.x86_64-linux.default =
      # starts nvim with 2 months of journal entries ahead and behind
      # nvim --cmd 'source .nvimrc' -O 2023/10 2023/11 2023/12 2024/01 2024/02
      pkgs.writeScriptBin "journal" ''
        nvim --cmd 'source ~/flakes/jrnl/.nvimrc' -O $(
          ${pkgs.dateutils}/bin/dateseq \
              "$(date --date "2 months ago" +${f})" \
              "$(date --date "2 months" +${f})" \
              -i ${f} \
              -f ${f}
        )
      '';

    devShell.x86_64-linux =
      pkgs.mkShell
      {
        nativeBuildInputs = [
          self.packages.x86_64-linux.default
        ];
      };
  };
}
