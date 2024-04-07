{ localpkgs ? import <nixpkgs> { }, project_path ? ./src }:

let

  # https://hydra.nixos.org/eval/1804905
  rev = "bb183e5637b6d48804a3ee0fc5ab38df51122d65";
  rev_hash = "14zjy9h6z9a7pc9v08zddshm4xh5j3vw321n5d3d4fal8k9as9hm";

  pkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    sha256 = rev_hash;
  }) { };

  godot_version = "4.2.1-stable";
  godot_hash = "sha256-dHlwkS2JHgLiXFPncLbSjZ7JqfcySS6k1pYPOyY59yk=";

  godot = pkgs.stdenv.mkDerivation {
    name = "godot-custom";

    src = pkgs.fetchzip {
      url = "https://github.com/godotengine/godot/releases/download/${godot_version}/Godot_v${godot_version}_linux.x86_64.zip";
      hash = godot_hash;
    };

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
    ];

    installPhase = ''
      install -m755 -D Godot_v${godot_version}_linux.x86_64 $out/bin/godot
    '';
  };

  rcedit = pkgs.fetchurl {
    url = "https://github.com/electron/rcedit/releases/download/v2.0.0/rcedit-x86.exe";
    hash = "sha256-OPtek118tY16mLTtj4dsg/XbAyvNAymwpN5OSh3odrY=";
  };

  createicon_gd = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/pkowal1982/godoticon/6f390665ebdbe31d21141d0a570707b7ec3d0196/CreateIcon.gd";
    hash = "sha256-OT1OIvRsGz6ixbqdA3Y+3V6RW7QHqETherjsoJpPVxA=";
  };

  setup_export_templates = pkgs.writeShellScriptBin "setup-export-templates" ''
    #!/usr/bin/env sh
    set -euo pipefail

    TEMPLATES_DIR=$HOME/.local/share/godot/export_templates
    TEMPLATE_FILE=Godot_v''${GODOT_VERSION}_export_templates.tpz
    VERSION_DIR=''${GODOT_VERSION//-/.}

    if [ -e "$TEMPLATES_DIR/$VERSION_DIR" ]; then
        echo "Export templates for $GODOT_VERSION already exists at $TEMPLATES_DIR/$VERSION_DIR"
        exit 0
    fi

    mkdir -p $TEMPLATES_DIR
    echo "Downloading export templates for $GODOT_VERSION at $TEMPLATES_DIR"
    cd /tmp

    wget https://github.com/godotengine/godot/releases/download/''${GODOT_VERSION}/$TEMPLATE_FILE
    unzip $TEMPLATE_FILE -d $TEMPLATES_DIR
    rm $TEMPLATE_FILE

    mv $TEMPLATES_DIR/templates $TEMPLATES_DIR/$VERSION_DIR
    echo "Installed export templates for $GODOT_VERSION at $TEMPLATES_DIR"
  '';

  setup_editor_config = pkgs.writeShellScriptBin "setup-editor-config" ''
    #!/usr/bin/env sh
    set -euo pipefail

    EDITOR_SETTINGS=godot-home/.config/godot/editor_settings-4.tres

    mkdir -p $(dirname "$EDITOR_SETTINGS")

    cat > $EDITOR_SETTINGS <<EOF
    [gd_resource type="EditorSettings" format=3]

    [resource]
    filesystem/import/blender/blender3_path = "${pkgs.blender}/bin"
    export/windows/rcedit = "${rcedit}"
    EOF

    cat $EDITOR_SETTINGS
  '';

  godot_import_assets = pkgs.writeShellScriptBin "godot-import-assets" '' 
    #!/usr/bin/env sh
    set -euo pipefail

    PROJECT_PATH=''${PROJECT_PATH:-.}
    XDG_CONFIG_HOME=$PWD/godot-home/.config \
    godot $PROJECT_PATH/project.godot --headless --editor --quit-after 2
  '';

  godot_build_linux = pkgs.writeShellScriptBin "godot-build-linux" ''
    #!/usr/bin/env sh

    TAG=$1
    [ -z "$TAG" ] && TAG=$(convco version)
    [ ! -z "$TAG" ] && TAG="$TAG-"

    set -euo pipefail

    PROJECT_PATH=''${PROJECT_PATH:-.}
    EXPORT_PATH=$(realpath --relative-to=$PROJECT_PATH $PWD)/export

    [ -d export/linux ] && rm -r export/linux
    mkdir -p export/linux

    XDG_CONFIG_HOME=$PWD/godot-home/.config \
    godot --headless $PROJECT_PATH/project.godot --export-release "Linux/X11" $EXPORT_PATH/linux/''${TAG}linux.x86_64

    cd ./export/linux
    zip ''${TAG}linux.zip ./*
  '';

  godot_build_windows = pkgs.writeShellScriptBin "godot-build-windows" ''
    #!/usr/bin/env sh

    TAG=$1
    [ -z "$TAG" ] && TAG=$(convco version)
    [ ! -z "$TAG" ] && TAG="$TAG-"

    set -euo pipefail

    PROJECT_PATH=''${PROJECT_PATH:-.}
    EXPORT_PATH=$(realpath --relative-to=$PROJECT_PATH $PWD)/export

    if [ ! -e "$PROJECT_PATH/project.godot" ]; then
      echo "Error: No project.godot at $PROJECT_PATH"
      exit 1
    fi

    # change windows icon: creates a icon.ico form a icon.png then add it to the project config

    if ! grep -q windows_native_icon "$PROJECT_PATH/project.godot"; then
      godot --headless -s ${createicon_gd} $PROJECT_PATH/icon.ico $PROJECT_PATH/icon.png
      sed -i '/\[application\]/a\config/windows_native_icon="res://icon.ico"' $PROJECT_PATH/project.godot
    fi

    [ -d export/windows ] && rm -r export/windows
    mkdir -p export/windows

    # disable wine mono, gecko pop-ups  
    WINEDLLOVERRIDES="mscoree,mshtml=" \
    XDG_CONFIG_HOME=$PWD/godot-home/.config \
    godot --headless $PROJECT_PATH/project.godot --export-release "Windows Desktop" $EXPORT_PATH/windows/''${TAG}windows.exe

    cd ./export/windows
    zip ''${TAG}windows.zip ./*
  '';

in
pkgs.mkShell {
  buildInputs = with pkgs; [
    setup_export_templates
    setup_editor_config
    godot_import_assets
    godot_build_linux
    godot_build_windows
    godot
    blender

    convco
    winePackages.minimal.out
    lf zip unzip cacert coreutils wget
  ];
  shellHook = ''
    export GODOT_VERSION=${godot_version}

    # see where project.godot is located and save it to PROJECT_PATH
    ${ if (builtins.pathExists (builtins.toString (project_path + "/project.godot")))
        then "export PROJECT_PATH=${builtins.toString project_path}"
        else "export PROJECT_PATH=." }
  '';
}
