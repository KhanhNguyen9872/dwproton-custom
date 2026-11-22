# dwproton-custom 🍷🎮

A customized, multi-purpose Wine / Proton runner designed for seamless out-of-the-box compatibility with complex games, Online-Fix multiplayer titles, and standalone launchers (Heroic Games Launcher, Lutris, Bottles, Steam).

---

## 🌟 Key Features & Customizations

### 1. Automatic Online-Fix & Multiplayer Support
- Built-in `WINEDLLOVERRIDES` handling for `OnlineFix64`, `steam_api64`, `SteamOverlay64`, `winmm`, and `dnet` (`n,b` - native then built-in).
- No need to manually add launch options or edit environment variables per game in Heroic / Steam.

### 2. Built-in Steam Client Integration (Fixes Error 126)
- Pre-populated `steamclient64.dll`, `steamclient.dll`, `Steam.dll`, and `GameOverlayRenderer64.dll` in `default_pfx/drive_c/Program Files (x86)/Steam/`.
- Eliminates the common *"Failed to load original steamclient. Error code: 126"* when running non-Steam or repacked games in standalone prefixes.

### 3. Native Steam Protocol Forwarding (`steam://`)
- Registered `Software\Classes\steam\shell\open\command` in Wine registry to bridge through `winebrowser.exe` -> `xdg-open`.
- Seamlessly activates game licenses, Free Friend's Passes, and Steam store URLs directly on your Linux host Steam client.

### 4. Automatic Steam Path Fallback
- The Python `proton` launch wrapper gracefully detects the host Linux Steam client installation (`~/.steam/debian-installation` / `~/.steam/steam`) even when launchers fail to export `STEAM_COMPAT_CLIENT_INSTALL_PATH`.

### 5. Verified Broad Compatibility
- **Genshin Impact / HoYoPlay**: Tested and working with custom anti-timeout, Wayland, and runtime patches.
- **Split Fiction / It Takes Two**: Full Online-Fix co-op multiplayer support out-of-the-box.
- **Inscryption & Indie Games**: Plug-and-play.

---

## 🚀 Installation

### Automatic Install (via `install.sh`)
Run this single command in your terminal to fetch and install the latest release:

```bash
curl -fsSL https://raw.githubusercontent.com/KhanhNguyen9872/dwproton-custom/main/install.sh | bash
```

### Manual Install
1. Download `dwproton-custom-v*.tar.zst` from [Releases](https://github.com/KhanhNguyen9872/dwproton-custom/releases).
2. Extract into Heroic's Proton folder:
   ```bash
   mkdir -p ~/.config/heroic/tools/proton/dwproton-custom
   tar -I zstd -xf dwproton-custom-v*.tar.zst -C ~/.config/heroic/tools/proton/dwproton-custom --strip-components=1
   ```
3. (Optional) For Steam:
   ```bash
   mkdir -p ~/.steam/root/compatibilitytools.d/
   ln -sfn ~/.config/heroic/tools/proton/dwproton-custom ~/.steam/root/compatibilitytools.d/dwproton-custom
   ```
4. Restart Heroic or Steam, and select **dwproton-custom** as your Wine/Proton runner.

---

## 🛠️ Updating and Publishing Releases

To package your current local runner and publish a new version:

```bash
cd dwproton-custom
./package_and_release.sh v1.0.1
```

---

## 📄 License
This project includes components under the Wine LGPL and Valve Proton licenses. See `LICENSE` for details.
