{ pkgs }:
let
  sqliterc = pkgs.writeText "sqliterc" ''
    .headers on
    .mode box
  '';

  sqlite = pkgs.writeShellScriptBin "sqlite" ''
    exec ${pkgs.rlwrap}/bin/rlwrap \
    ${pkgs.sqlite}/bin/sqlite3 -init "${sqliterc}" "$@"
  '';
in
pkgs.mkShell {
  name = "sql";

  packages = with pkgs; [
    sqlite
    sqlitebrowser
  ];

  shellHook = ''
    exec ${pkgs.zsh}/bin/zsh
  '';
}
