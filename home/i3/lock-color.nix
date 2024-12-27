{
  pkgs,
  palette,
  ...
}: let
  selection = palette.base00;
  green = palette.base08;
  red = palette.base08;
  blue = palette.base0D;
  orange = palette.base09;
  magenta = palette.base0E;
in {
  lock-color = pkgs.writeShellScriptBin "lock-color" ''
    alpha='dd'
    ${pkgs.i3lock-color}/bin/i3lock-color \
        --insidever-color=${selection}$alpha \
        --insidewrong-color=${selection}$alpha \
        --inside-color=${selection}$alpha \
        --ringver-color=${green}$alpha \
        --ringwrong-color=${red}$alpha \
        --ringver-color=${green}$alpha \
        --ringwrong-color=${red}$alpha \
        --ring-color=${blue}$alpha \
        --line-uses-ring \
        --keyhl-color=${magenta}$alpha \
        --bshl-color=${orange}$alpha \
        --separator-color=${selection}$alpha \
        --verif-color=${green} \
        --wrong-color=${red} \
        --modif-color=${red} \
        --layout-color=${blue} \
        --date-color=${blue} \
        --time-color=${blue} \
        --screen 1 \
        --blur 1 \
        --clock \
        --indicator \
        --time-str="%H:%M:%S" \
        --date-str="%A %e %B %Y" \
        --verif-text="Checking..." \
        --wrong-text="Wrong password" \
        --noinput="No Input" \
        --lock-text="Locking..." \
        --lockfailed="Lock Failed" \
        --radius=120 \
        --ring-width=10 \
        --pass-media-keys \
        --pass-screen-keys \
        --pass-volume-keys \
  '';
}
