# Red & Yellow Centered Layout

**Red & Yellow Centered Layout** is a presentation-only Gen1Recomp mod for **Pokémon Red and Pokémon Yellow**. It centers the normal overworld player sprite in the active world viewport without changing player coordinates, maps, collision, movement, scripts, encounters, or save data. In Red, it also corrects the visible alignment of the native `Red Version` title caption.

| Package detail | Value |
|---|---|
| Supported games | Pokémon Red and Pokémon Yellow |
| Required Gen1Recomp version | `0.2.19` or newer |
| Mod API | `2` |
| Save or gameplay changes | None |
| Link compatibility | Unaffected |

## Visual changes

The standard Gen 1 overworld camera deliberately reproduces the Game Boy framing, which places the 16×16 player sprite 8 pixels left and 4 pixels above the geometric viewport center. This mod changes only the camera’s view origin so the visual center of the player sprite is centered, including in resized or zoomed world views. The player’s world coordinates and the underlying gameplay state are not changed.

In **Pokémon Red**, the original title renderer draws the two fragments of the `Red Version` caption with asymmetric blank tile space. The mod recomposes those original fragments into a transient 68×8 in-memory ribbon with a small transparent alignment pad, allowing the native title renderer to place the **visible** caption at the true center. It neither distributes nor alters game artwork.

> **Yellow title behavior is intentionally native.** Pokémon Yellow has a separate fixed-Pikachu title composition and does not display a version ribbon in the normal title flow. The mod applies the compatible overworld camera centering there, but does not insert, change, or approximate a Yellow title caption.

## Intentional boundaries

Blue, Gold, and Silver are not patched. A custom continuous Red `versionRibbon` remains untouched, allowing translation, rebrand, or total-conversion mods to retain their own title art and placement. If the runtime cannot create the temporary Red title canvas, the mod safely preserves the original split ribbon rather than replacing it with an approximation.

## Installation

Download the latest release ZIP, then in Gen1Recomp open **MODS**, choose **Import mod .zip**, select the archive, and enable it for Pokémon Red or Pokémon Yellow. The archive keeps the required `Red-Centered-Layout` folder at its root so the launcher can update the existing stable mod ID.

## Compatibility

The mod uses shared camera and title-state internals. It should be tested with another mod that independently replaces `src.render.Camera.follow` or `src.ui.TitleState.new`; otherwise it is presentation-only and does not require other mods.

## Testing

Run the dedicated regression suite with:

```sh
lua tests/test_main.lua .
```

The suite verifies Red title-ribbon composition, custom-ribbon preservation, the safe no-canvas fallback, viewport-size-independent camera centering in Red and Yellow, Yellow’s native title preservation, Blue exclusion, and safe hot reload.

## License

This project is released under the MIT License. It is an unofficial community mod and is not affiliated with Nintendo, Game Freak, The Pokémon Company, LÖVE, or Gen1Recomp.
