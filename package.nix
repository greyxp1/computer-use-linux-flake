{
  lib,
  stdenv,
  autoPatchelfHook,
  makeWrapper,
  ydotool,
  wtype,
  niri,
  glib,
  libxkbcommon,
  src,
  version,
  runtimeDir ? null,
}:
stdenv.mkDerivation {
  pname = "computer-use-linux";
  inherit src version;
  nativeBuildInputs = [autoPatchelfHook makeWrapper];
  buildInputs = [stdenv.cc.cc.lib];
  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;
  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/computer-use-linux"
    wrapProgram "$out/bin/computer-use-linux" \
      --prefix PATH : ${lib.makeBinPath [ydotool wtype niri glib]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libxkbcommon]} ${lib.optionalString (runtimeDir != null) ''
      --set XDG_RUNTIME_DIR ${runtimeDir} \
      --set DBUS_SESSION_BUS_ADDRESS unix:path=${runtimeDir}/bus \
      --set YDOTOOL_SOCKET /run/ydotoold/socket
    ''}
    runHook postInstall
  '';
  meta = {
    description = "Linux desktop control over MCP";
    homepage = "https://github.com/agent-sh/computer-use-linux";
    license = lib.licenses.mit;
    platforms = ["x86_64-linux"];
    mainProgram = "computer-use-linux";
  };
}
