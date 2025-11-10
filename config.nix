{
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "whalebyte-tools";
      paths = [
        pkgs.neovim
        pkgs.go
        pkgs.golangci-lint
        pkgs.rustup
        pkgs.tmux
        pkgs.nodejs_24
        pkgs.starship
        pkgs.fd
        pkgs.ripgrep
        pkgs.lazygit
        pkgs.kubectl
        pkgs.helm
        pkgs.k9s
        pkgs.jq
        pkgs.fzf
        pkgs.sops
        pkgs.age
        pkgs.bat
        pkgs.eza
      ];
    };
  };
}
