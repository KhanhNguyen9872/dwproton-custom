"""Game fix for Goddess of Victory: NIKKE"""

from protonfixes import util

def main():
    """Nikke locks repair/download launcher features if Steam is detected"""
    util.del_environment('SteamGameId')
    util.del_environment('SteamAppId')
    util.del_environment('UMU_USE_STEAM')

    """NVAPI breaks video playback"""
    util.disable_nvapi()
