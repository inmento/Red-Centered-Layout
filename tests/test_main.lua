local root = arg[1] or "."

local checks = 0
local function expect(actual, expected, label)
  checks = checks + 1
  if actual ~= expected then
    error((label or "assertion") .. "\nexpected: " .. tostring(expected)
      .. "\nactual:   " .. tostring(actual), 2)
  end
end

local function makeGraphics(opts)
  opts = opts or {}
  local currentCanvas = nil
  local color = { 0.25, 0.5, 0.75, 1 }
  local calls = {}
  local G = {
    calls = calls,
    newCanvas = function(w, h)
      if opts.noCanvas then error("canvas unsupported") end
      local canvas = { width = w, height = h, kind = "canvas" }
      function canvas:getDimensions() return self.width, self.height end
      return canvas
    end,
    newQuad = function(x, y, w, h, iw, ih)
      return { x = x, y = y, w = w, h = h, iw = iw, ih = ih }
    end,
    getCanvas = function() return currentCanvas end,
    setCanvas = function(canvas) currentCanvas = canvas end,
    getColor = function() return color[1], color[2], color[3], color[4] end,
    setColor = function(r, g, b, a) color = { r, g, b, a } end,
    clear = function(...) calls[#calls + 1] = { kind = "clear", args = { ... } } end,
    draw = function(source, quad, x, y)
      calls[#calls + 1] = { kind = "draw", source = source, quad = quad, x = x, y = y }
    end,
  }
  return G
end

local function loadMod(version, graphics)
  local Camera = {}
  function Camera.follow(self, px, py, viewW, viewH)
    viewW, viewH = viewW or 160, viewH or 144
    self.x = px - (viewW / 2 - 16)
    self.y = py - (viewH / 2 - 8)
  end

  local TitleState = {}
  function TitleState.new(_, opts)
    return {
      version = opts.version,
      versionFull = opts.versionFull == true,
      blue = opts.blue == true,
      yellow = opts.yellow == true,
    }
  end

  package.loaded["src.core.GameVersion"] = nil
  package.loaded["src.render.Camera"] = nil
  package.loaded["src.ui.TitleState"] = nil
  package.preload["src.core.GameVersion"] = function() return { get = function() return version end } end
  package.preload["src.render.Camera"] = function() return Camera end
  package.preload["src.ui.TitleState"] = function() return TitleState end

  _G.love = { graphics = graphics }
  local entry = assert(loadfile(root .. "/main.lua"))
  entry()({ log = { info = function() end } })
  return Camera, TitleState, entry
end

local source = { width = 80, height = 8, kind = "source" }
function source:getDimensions() return self.width, self.height end

local G = makeGraphics()
local Camera, TitleState, entry = loadMod("red", G)
local camera = {}
Camera.follow(camera, 160, 96, 160, 144)
expect(camera.x, 88, "Red camera shifts the viewport left by eight pixels")
expect(camera.y, 28, "Red camera shifts the viewport up by four pixels")
expect(160 - camera.x + 8, 80, "player sprite center is horizontally centered")
expect(96 - camera.y - 4 + 8, 72, "player sprite center is vertically centered")

local wide = {}
Camera.follow(wide, 500, 300, 240, 180)
expect(500 - wide.x + 8, 120, "player stays centered in a wider viewport")
expect(300 - wide.y - 4 + 8, 90, "player stays centered in a taller viewport")

local title = TitleState.new({}, { version = source })
expect(title.versionFull, true, "vanilla Red ribbon becomes a continuous centered ribbon")
expect(title.version.kind, "canvas", "centered ribbon is an in-memory canvas")
expect(title.version.width, 68, "centered ribbon width includes the visual-centering pad")
expect(title.version.height, 8, "centered ribbon height")
expect(#G.calls, 3, "ribbon composition clears and draws two original fragments")
expect(G.calls[2].quad.x, 0, "first Red fragment source coordinate")
expect(G.calls[2].x, 4, "first Red fragment destination coordinate includes visual-centering pad")
expect(G.calls[3].quad.x, 40, "second Red fragment source coordinate")
expect(G.calls[3].x, 28, "second Red fragment destination coordinate includes visual-centering pad")

local custom = TitleState.new({}, { version = source, versionFull = true })
expect(custom.version, source, "custom continuous title ribbon is untouched")
local blue = TitleState.new({}, { version = source, blue = true })
expect(blue.version, source, "Blue title layout is untouched")
local yellow = TitleState.new({}, { version = source, yellow = true })
expect(yellow.version, source, "Yellow title layout is untouched")

local beforeFollow, beforeNew = Camera.follow, TitleState.new
entry()({ log = { info = function() end } })
expect(Camera.follow, beforeFollow, "reloading does not stack camera patches")
expect(TitleState.new, beforeNew, "reloading does not stack title patches")

local blueG = makeGraphics()
local BlueCamera, BlueTitle = loadMod("blue", blueG)
local unpatched = {}
BlueCamera.follow(unpatched, 160, 96, 160, 144)
expect(unpatched.x, 96, "Blue camera remains native")
expect(unpatched.y, 32, "Blue camera vertical placement remains native")
expect(BlueTitle.new({}, { version = source }).version, source, "Blue title state remains native")

local noCanvasG = makeGraphics({ noCanvas = true })
local _, NoCanvasTitle = loadMod("red", noCanvasG)
expect(NoCanvasTitle.new({}, { version = source }).version, source,
  "unsupported canvas keeps the original Red ribbon safely")

print(("ok - %d assertions"):format(checks))
