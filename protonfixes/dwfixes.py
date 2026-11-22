## dwfixes - automate settings certain protonfixes based on game executables
import os
import sys

def _is_hoyo_launcher(exe_path: str) -> bool:
    return "HoYoPlay" in exe_path.split(os.sep)

def _is_gryphlink_launcher(exe_path: str) -> bool:
    return "GRYPHLINK" in exe_path.split(os.sep)

UMU_IDS = {
    "GenshinImpact.exe":   "umu-genshin",
    "ZenlessZoneZero.exe": "umu-zenlesszonezero",
    "BH3.exe": "umu-zenlesszonezero", # same dependency on UMU_USE_STEAM=1 since 9.0
    "nikke_launcher.exe":  "umu-nikke",
    "Endfield.exe":        "umu-endfield",
}

# - don't force protonfixes using UMU_USE_STEAM when user is running on Steam
# - don't apply NIKKE protonfix on Steam, stripping SteamGameId there breaks launcher
STEAM_SENSITIVE_UMU_IDS = {"umu-genshin", "umu-zenlesszonezero", "umu-nikke"}

def apply_dwfixes(env: dict):
    if len(sys.argv) < 3:
        return

    exe_path = sys.argv[2]
    exe = os.path.basename(exe_path)

    if exe == "launcher.exe" and _is_hoyo_launcher(exe_path):
        umu_id = "umu-zenlesszonezero"
    elif exe == "Launcher.exe" and _is_gryphlink_launcher(exe_path):
        umu_id = "umu-endfield"
    else:
        umu_id = UMU_IDS.get(exe)

    if not umu_id:
        return

    current_id = env.get("UMU_ID")

    # - always override the default fallback
    # - only treat a fully unset UMU_ID (i.e. running on steam) as overridable for games that don't touch the Steam environment
    # - never override a user's explicit custom UMU_ID
    if current_id == "umu-default" or (
        current_id is None and umu_id not in STEAM_SENSITIVE_UMU_IDS
    ):
        env["UMU_ID"] = os.environ["UMU_ID"] = umu_id
