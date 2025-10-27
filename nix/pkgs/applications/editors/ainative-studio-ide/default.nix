{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, electron_30 ? null
, python3
, pkg-config
, nodejs_20
, cudaSupport ? false
, rocmSupport ? false
}:

let
  pname = "ainative-studio-ide";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "AINative-Studio";
    repo = "AINativeStudio-IDE";
    rev = "v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # TODO: Replace with actual hash
  };

  # Desktop entry configuration
  desktopItem = makeDesktopItem {
    name = "ainative-studio-ide";
    exec = "ainative-studio-ide %U";
    icon = "ainative-studio-ide";
    desktopName = "AI Native Studio IDE";
    genericName = "AI-Native Code Editor";
    comment = "AI-Native IDE with agentic development features";
    categories = [ "Development" "IDE" "AI" "TextEditor" ];
    startupNotify = true;
    mimeTypes = [
      "text/plain"
      "inode/directory"
    ];
  };

in
buildNpmPackage rec {
  inherit pname version src;

  # Build from the ainative-studio subdirectory
  npmRoot = "ainative-studio";

  # npm dependencies hash - needs to be generated
  npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # TODO: Replace with actual hash

  nativeBuildInputs = [
    makeWrapper
    python3
    pkg-config
    nodejs_20
    copyDesktopItems
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ] ++ lib.optionals cudaSupport [
    # TODO: Add CUDA dependencies
  ] ++ lib.optionals rocmSupport [
    # TODO: Add ROCm dependencies
  ];

  # Increase Node memory for large TypeScript build
  NODE_OPTIONS = "--max-old-space-size=8192";

  # Build phase
  buildPhase = ''
    runHook preBuild

    cd ainative-studio
    npm run compile

    runHook postBuild
  '';

  # Install phase
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/ainative-studio-ide/app
    mkdir -p $out/bin

    # Copy built application
    cp -r out $out/share/ainative-studio-ide/app/
    cp -r resources $out/share/ainative-studio-ide/app/ || true
    cp package.json $out/share/ainative-studio-ide/app/

    # Install icons
    for size in 16 24 32 48 64 128 256 512; do
      if [ -f resources/icons/ainative-''${size}x''${size}.png ]; then
        install -Dm644 resources/icons/ainative-''${size}x''${size}.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/ainative-studio-ide.png
      fi
    done

    # Create wrapper script
    ${if electron_30 != null then ''
      makeWrapper ${electron_30}/bin/electron $out/bin/ainative-studio-ide \
        --add-flags "$out/share/ainative-studio-ide/app" \
        --set ELECTRON_IS_DEV 0
    '' else ''
      # Use bundled launcher if no system electron
      install -m755 scripts/code.sh $out/bin/ainative-studio-ide || \
        echo '#!/bin/sh
exec node $out/share/ainative-studio-ide/app/out/main.js "$@"' > $out/bin/ainative-studio-ide
      chmod +x $out/bin/ainative-studio-ide
    ''}

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  # Update script for r-ryantm automation
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "AI-Native IDE (TypeScript/VS Code fork) with agentic features";
    longDescription = ''
      AI Native Studio IDE is a modern code editor built on VS Code with
      integrated AI agents for autonomous development, code generation,
      and intelligent assistance.
    '';
    homepage = "https://www.ainative.studio";
    changelog = "https://github.com/AINative-Studio/AINativeStudio-IDE/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ quaid albertolopez urbantech ];
    mainProgram = "ainative-studio-ide";
    platforms = platforms.linux ++ platforms.darwin;
    # Mark broken on Darwin if electron is not available
    broken = stdenv.isDarwin && electron_30 == null;
  };
}
