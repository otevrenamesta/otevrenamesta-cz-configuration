{ config, pkgs, ... }:
let
  vimCustom = (pkgs.vimUtils.makeCustomizable pkgs.vim).customize {
    name = "vim";
    vimrcConfig = {
      customRC = ''
        runtime vimrc

        set mouse=
        if has("autocmd")
          au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
        endif
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ vim-nix ];
      };
    };
  };
in
{
  time.timeZone = "Europe/Amsterdam";
  networking.nameservers = [ "208.67.222.222" "208.67.220.220" ];
  services.openssh.enable = true;
  services.openssh.startWhenNeeded = false; # workaround https://github.com/NixOS/nixpkgs/pull/97989
  nix.useSandbox = true;
  nix.buildCores = 0;
  systemd.tmpfiles.rules = [ "d /tmp 1777 root root 7d" ];

  environment.systemPackages = with pkgs; [
    htop
    lynx
    screen
    tmux
    vimCustom
    wget
    git
    nmap
    tcpdump
  ];

  security.acme = {
    email = "info@otevrenamesta.cz";
    acceptTerms = true;
  };

  users.extraUsers.root.openssh.authorizedKeys.keys =
    with import ./ssh-keys.nix; [ deploy ln mm srk ];

  system.stateVersion = "18.09";
}
