{ inputs, pkgs, unstable, ... }:
{
  programs.starship = {
    enable = true;
    # optional inline config:
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
      };
    };
  };

  programs.zsh = {
    enable = true;
  };

#   programs.starship = {
#     enable = true;
#     enableZshIntegration = true;
#     enableBashIntegration = true;
#     presets = [ "nerd-font-symbols" ];
#     # settings = {
#     #   format = "$nix_shell$python$os$hostname$directory$git_branch$git_stash$character";
#     #
#     #   nix_shell = {
#     #     format = "(󱄅 $state) ";
#     #     style = "bright-blue";
#     #   };
#     #
#     #   python = {
#     #     format = "(\${virtualenv}) ";
#     #     style = "bright-yellow";
#     #     detect_env_vars = [];
#     #   };
#     #
#     #   os = {
#     #     format = "$symbol ";
#     #     style = "bright-purple";
#     #     disabled = false;
#     #   };
#     #
#     #   hostname = {
#     #     format = "$hostname ";
#     #     style = "bright-purple";
#     #     ssh_only = false;
#     #   };
#     #
#     #   directory = {
#     #     format = "$path ";
#     #     style = "bright-green";
#     #     truncation_length = 3;
#     #     truncate_to_repo = false;
#     #   };
#     #
#     #   git_branch = {
#     #     format = " $branch ";
#     #     style = "#d2573f";
#     #     symbol = " ";
#     #   };
#     #
#     #   git_stash = {
#     #     format = " 󰛉 $count ";
#     #     style = "#d2573f";
#     #   };
#     #
#     #   character = {
#     #     success_symbol = "[❯](bright-yellow)";
#     #     error_symbol = "[❯](red)";
#     #   };
#     # };
# };
}
