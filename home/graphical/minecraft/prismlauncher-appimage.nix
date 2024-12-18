{
  lib,
  appimageTools,
  fetchurl,
}: let
  version = "9.0";
  pname = "PrismLauncher";
  name = "prismlauncher";

  src = fetchurl {
    url = "https://github.com/Diegiwg/PrismLauncher-Cracked/releases/download/${version}/PrismLauncher-Linux-x86_64-${version}.AppImage";
    hash = "sha256-bc9890db28fad91e468ed261b9bec37eb404a6a1";
  };

  appimageContents = appimageTools.extractType2 {inherit name src;};
in
  appimageTools.wrapType1 {
    inherit name src;

    extraInstallCommands = ''
      mv $out/bin/${name} $out/bin/${pname}
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    meta = {
      description = "Viewer for electronic invoices";
      longDescription = ''
        Allows you to have multiple, separate instances of Minecraft (each with
        their own mods, texture packs, saves, etc) and helps you manage them and
        their associated options with a simple interface.
      '';
      homepage = "https://github.com/Diegiwg/PrismLauncher-Cracked";
      downloadPage = "https://github.com/Diegiwg/PrismLauncher-Cracked/releases";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [
        minion3665
        Scrumplex
        getchoo
      ];
      mainProgram = "prismlauncher";
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      platforms = ["x86_64-linux"];
    };
  }
