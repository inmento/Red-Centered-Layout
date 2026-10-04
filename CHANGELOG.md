## 2026-10-04 — Gen1Recomp 0.3.51 compatibility refresh

- Updated the manifest engine requirement to `>=0.3.51` for the current Mod API 2 runtime.
- Revalidated the existing public hook/registry surface without changing gameplay behavior, assets, save formats, or progression rules.
- This entry is a compatibility maintenance update; install the matching release build before testing.

# Changelog

## 0.1.2 — 2026-08-22

This update adds **Pokémon Yellow** compatibility. The same presentation-only camera adjustment now centers Yellow’s standard overworld player sprite in every active viewport, without changing maps, coordinates, movement, collision, save data, or gameplay.

Yellow’s fixed-Pikachu title is intentionally left native. Unlike Red, its normal title flow has no visible version ribbon to recenter. The existing Red title-caption correction remains unchanged, and Blue, Gold, and Silver remain outside the mod’s scope.

The regression suite now verifies camera centering in Red and Yellow, preservation of Yellow’s native title composition, Red ribbon behavior, Blue exclusion, and safe hot reload.

## 0.1.1 — 2026-08-21

This hotfix corrects the Red Version title caption’s final visual alignment. The initial continuous ribbon was geometrically centered, but the original glyphs have asymmetric blank tile space and still appeared slightly left of center. The recomposed ribbon now uses a four-pixel transparent left pad in a 68×8 canvas, moving the visible caption two Game Boy pixels right while retaining the native title animation and original source fragments.

The confirmed working overworld player-centering camera adjustment is unchanged.

## 0.1.0 — 2026-08-21

This initial release adds **Red Centered Layout**, a Red-only Gen1Recomp presentation mod. It centers the vanilla Red Version title caption by recomposing the existing renderer’s two source fragments as a 64×8 transient ribbon, without distributing or altering game art.

It also adjusts the ordinary overworld camera origin so the standard 16×16 player sprite is geometrically centered in the active viewport. The change does not alter player/map coordinates, saves, collision, movement, encounters, scripts, or link behavior.

The release includes 24 regression assertions covering Red-only routing, title-ribbon composition, custom-ribbon preservation, safe fallback when a title canvas is unavailable, camera centering in normal and resized viewports, and idempotent reload behavior.
