# Red Centered Layout

**Red Centered Layout** is a Red-only presentation mod for Gen1Recomp. It centers the vanilla **Red Version** title caption and centers the normal overworld player sprite within the active world viewport.

| Package detail | Value |
|---|---|
| Supported game | Pokémon Red only |
| Required Gen1Recomp version | `0.2.19` or newer |
| Mod API | `2` |
| Save or gameplay changes | None |
| Link compatibility | Unaffected |

## Visual changes

The original Red title code draws the two parts of the `Red Version` caption 8 pixels to the right of the 160-pixel Game Boy canvas center. This mod recomposes those original fragments into a transient 64×8 in-memory ribbon, preserving their source pixels and gap while allowing the native title renderer to place the full caption at the true center.

The normal Red overworld camera intentionally mimics the original framing: the standard 16×16 player sprite sits 8 pixels left and 4 pixels above the geometric viewport center. This mod adjusts only the camera view origin so the sprite’s visual center is centered. Player coordinates, maps, collision, movement, scripts, and saves remain unchanged.

## Intentional boundaries

The mod is deliberately **Red-only**. Blue, Yellow, Gold, and Silver are not patched.

It leaves a custom continuous title ribbon alone. This means a translation, rebrand, or total conversion that provides its own `versionRibbon` continues to control that art and placement. If the runtime cannot create the temporary title canvas, it safely preserves the original split ribbon rather than replacing it with an approximation.

## Installation

Download the latest release ZIP, then in Gen1Recomp open **MODS**, choose **Import mod .zip**, select the archive, and enable it for Pokémon Red. The ZIP keeps the required `Red-Centered-Layout` folder at its root.

## Compatibility

This mod uses the shared camera and title-state internals, so it should be tested with any other mod that independently replaces `src.render.Camera.follow` or `src.ui.TitleState.new`. It is otherwise presentation-only and does not require other mods.

## Testing

Run the dedicated regression suite with:

```bash
lua tests/test_main.lua .
```

The suite verifies Red-only routing, title-ribbon composition, custom-ribbon preservation, no-canvas fallback, viewport-size-independent camera centering, and safe hot reload.

## License

This project is released under the MIT License. It is an unofficial community mod and is not affiliated with Nintendo, Game Freak, The Pokémon Company, LÖVE, or Gen1Recomp.
