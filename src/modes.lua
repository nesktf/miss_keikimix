local love = _G.love
local words = require('words')

local _M = {}

local function copy_table_cond(tbl, cond)
  local out = {}
  for _,item in ipairs(tbl) do
    if (cond(item)) then
      table.insert(out, item)
    end
  end
  return out
end

local function truncate_table(tbl, max)
  local out = {}
  for i = 1, math.min(max, #tbl), 1 do
    table.insert(out, tbl[i])
  end
  return out
end

local function make_name_set(min_len, max_len, count)
  local filtered = copy_table_cond(words.names, function(name)
    local len = #name
    return len >= min_len and len <= max_len
  end)

  -- Shuffle table
  local len = #filtered
  for i = len, 2, -1 do
    local j = love.math.random(i)
    filtered[i], filtered[j] = filtered[j], filtered[i]
  end

  return truncate_table(filtered, count)
end

_M.modes = {
  [1] = {
    -- Easy modo
    name = "Easy",
    words = make_name_set(4, 6, 2),
    time = 20,
    tries = 10,
    icon = love.graphics.newImage("image/easymodo.jpg")
  },
  [2] = {
    -- Normal
    name = "Normal",
    words = make_name_set(5, 9, 50),
    time = 20,
    tries = 8,
    icon = love.graphics.newImage("image/normalmodo.png")
  },
  [3] = {
    -- Hard
    name = "Hard",
    words = make_name_set(6, 15, 70),
    time = 20,
    tries = 5,
    icon = love.graphics.newImage("image/hardmodo.png")
  },
  [4] = {
    -- Lunatic
    name = "Lunatic",
    words = make_name_set(0, 100, #words.names),
    time = 40,
    tries = 3,
    icon = love.graphics.newImage("image/lunaticmodo.png")
  },
  [5] = {
    -- Cursed
    name = "???????",
    words = (function()
      local tbl = {}
      for _ = 1, 200, 1 do
        table.insert(tbl, "KEIKI")
      end
      return tbl
    end)(),
    time = 50,
    tries = 1,
    icon = love.graphics.newImage("image/keikimodo.jpg")
  },
}

return _M
