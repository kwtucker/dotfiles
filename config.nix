{
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "whalebyte-tools";
      paths = [
        neovim
        go
        rust
        tmux
        nodejs_22
        starship
        fd
        ripgrep
        lazygit
        terraform
        kubectl
        helm
        k9s
        jq
        fzf
        sops
        age
        bat
        exa
        zsh
      ];
    };
  };
}
