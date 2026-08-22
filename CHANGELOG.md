# Changelog

## 0.1.0 — 2026-08-21

This initial release adds **Red Centered Layout**, a Red-only Gen1Recomp presentation mod. It centers the vanilla Red Version title caption by recomposing the existing renderer’s two source fragments as a 64×8 transient ribbon, without distributing or altering game art.

It also adjusts the ordinary overworld camera origin so the standard 16×16 player sprite is geometrically centered in the active viewport. The change does not alter player/map coordinates, saves, collision, movement, encounters, scripts, or link behavior.

The release includes 24 regression assertions covering Red-only routing, title-ribbon composition, custom-ribbon preservation, safe fallback when a title canvas is unavailable, camera centering in normal and resized viewports, and idempotent reload behavior.
