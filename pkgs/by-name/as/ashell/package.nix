{
  fetchFromGitHub,
  lib,
  rustPlatform,
  autoPatchelfHook,
  pkg-config,
  aws-lc,
  libxkbcommon,
  libGL,
  pipewire,
  libpulseaudio,
  wayland,
  udev,
  vulkan-loader,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ashell";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "MalpenZibo";
    repo = "ashell";
    #tag = finalAttrs.version;
    rev = "cba836b4ebb6c122332834e15747ec89e92ac8b0";
    hash = "sha256-6dX7zjgHlV6r8nsuC6ljVaFpx5QM56wElJFwb+pDTiM=";
  };

  cargoHash = "sha256-mTzRaUQVApH3cZT+V8Dty0nPWnVWG8iuRM61zYewgys=";

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
    rustPlatform.bindgenHook
  ];

  runtimeDependencies = [
    wayland
    libGL
    vulkan-loader
  ];

  buildInputs = [
    libpulseaudio
    libxkbcommon
    pipewire
    udev
    aws-lc
  ]
  ++ finalAttrs.runtimeDependencies;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--use-github-releases" ];
  };

  meta = {
    description = "Ready to go Wayland status bar for Hyprland";
    homepage = "https://github.com/MalpenZibo/ashell";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ashell";
    maintainers = with lib.maintainers; [
      mBornand
    ];
    platforms = lib.platforms.linux;
  };
})
