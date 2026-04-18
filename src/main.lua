local love = _G.love
local anim = require('anim')
local iffy = require("lib.iffy")

local keiki_atlas = iffy.newAtlas("image/keiki.png")

local font = love.graphics.newFont("font/CousineNerdFont-Regular.ttf", 20)
local normal_str = love.graphics.newText(font, "")
local color_str = love.graphics.newText(font, "")

function love.load()
  love.keyboard.setTextInput(true)
end

local words = {
  "REIMU",
  "MARISA",
  "RUMIA",
  "CIRNO",
  "DAIYOUSEI",
  "MEILING",
  "KOAKUMA",
  "PATCHOULI",
  "SAKUYA",
  "REMILIA",
  "FLANDRE",
  "LETTY",
  "CHEN",
  "ALICE",
  "LILY",
  "MERLIN",
  "LYRICA",
  "LUNASA",
  "YOUMU",
  "YUYUKO",
  "RAN",
  "YUKARI",
}

local red = {1, 0, 0, 1}
local white = {1, 1, 1, 1}

local word_idx = 0
local word_pos = 1
normal_str:set{white, words[1]}
local curr_str = ""

function love.keypressed(key, code, isrep)
  local word = words[word_idx+1]
  normal_str:set{white, word}
  local ch = word:sub(word_pos, word_pos)
  print(ch)
  if (key:upper() == ch) then
    local next = word:sub(word_pos+1, word_pos+1)
    if (next == "") then
      word_idx = (word_idx + 1) % #words
      word_pos = 1
      ch = words[word_idx+1]:sub(word_pos, word_pos)
      normal_str:set{white, words[word_idx+1]}
      curr_str = ""
    else
      word_pos = word_pos +1
      curr_str = curr_str .. ch
    end
    color_str:set{red, curr_str}
  end
end

local keiki = anim.make_anim("keiki", 30, 0.016)
function love.update(dt)
  keiki:update(dt)
end

function love.draw()
  iffy.drawSprite(keiki:get_name())
  love.graphics.draw(normal_str, 400, 300)
  love.graphics.draw(color_str, 400, 300)
end
