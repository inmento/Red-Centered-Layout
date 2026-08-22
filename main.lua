-- Red Centered Layout
--
-- A Red-only presentation adjustment. It centers the stock Red Version title
-- caption and the standard overworld player sprite without changing save data,
-- map coordinates, collision, or movement state.

return function(mod)
  local GameVersion = require("src.core.GameVersion")
  if GameVersion.get() ~= "red" then return end

  local Camera = require("src.render.Camera")
  local TitleState = require("src.ui.TitleState")

  local marker = "_redCenteredLayout"
  if Camera[marker] or TitleState[marker] then return end

  local function composeRedRibbon(source)
    local G = love and love.graphics
    if not (G and G.newCanvas and G.newQuad and G.getCanvas and G.setCanvas
      and G.getColor and G.setColor and G.clear and G.draw
      and source and source.getDimensions) then
      return nil
    end

    local width, height = source:getDimensions()
    if width < 80 or height < 8 then return nil end

    local ok, ribbon = pcall(G.newCanvas, 64, 8)
    if not ok or not ribbon then return nil end

    local previousCanvas = G.getCanvas()
    local r, g, b, a = G.getColor()
    local first = G.newQuad(0, 0, 16, 8, width, height)
    local second = G.newQuad(40, 0, 40, 8, width, height)

    G.setCanvas(ribbon)
    G.clear(0, 0, 0, 0)
    G.setColor(1, 1, 1, 1)
    G.draw(source, first, 0, 0)
    G.draw(source, second, 24, 0)
    G.setCanvas(previousCanvas)
    G.setColor(r, g, b, a)
    return ribbon
  end

  local nativeFollow = Camera.follow
  Camera.follow = function(self, px, py, viewW, viewH)
    nativeFollow(self, px, py, viewW, viewH)
    -- Camera:follow reproduces the original Game Boy sprite placement, where
    -- the player sprite center is 8px left and 4px above the viewport center.
    -- Move the camera in the opposite direction, keeping world/game state
    -- untouched while placing the 16x16 sprite at the exact viewport center.
    self.x = self.x - 8
    self.y = self.y - 4
  end
  Camera[marker] = true

  local nativeTitleNew = TitleState.new
  TitleState.new = function(game, opts)
    local state = nativeTitleNew(game, opts)
    -- Do not replace a rebrand/translation's intentional continuous ribbon,
    -- Blue's distinct layout, or a missing/nonstandard source asset.
    if state and not state.blue and not state.yellow and not state.versionFull
      and state.version then
      local ribbon = composeRedRibbon(state.version)
      if ribbon then
        state.version = ribbon
        state.versionFull = true
      end
    end
    return state
  end
  TitleState[marker] = true

  if mod.log and type(mod.log.info) == "function" then
    mod.log:info("Red Centered Layout active.")
  end
end
