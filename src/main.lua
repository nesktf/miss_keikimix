local love = _G.love
local anim = require('anim')
local iffy = require("lib.iffy")
local words = require('words')

iffy.newAtlas("image/keiki.png")
local font = love.graphics.newFont("font/CousineNerdFont-Regular.ttf", 20)
local yippie = love.graphics.newText(font, "Yippie!!11!1")
local dies = love.graphics.newText(font, "DEAD")

local red = {1, 0, 0, 1}
local white = {1, 1, 1, 1}

local word_handler = words.make_handler(font, words.ENTRIES, white, red)

function love.load()
  love.keyboard.setTextInput(true)
end

local fails = 0
local status = words.CODE.continue
function love.keypressed(key, code, isrep)
  if (fails < 3 and status ~=words.CODE.finished) then
    status = word_handler:update(key)
    if (status == words.CODE.bad_char) then
      word_handler:reset_word()
      fails = fails + 1
    end
  end
end

local keiki = anim.make_anim("keiki", 30, 0.016)
function love.update(dt)
  keiki:update(dt)
end

function love.draw()
  if (status == words.CODE.finished) then
    love.graphics.draw(yippie, 400, 300)
  elseif (fails >= 3) then
    love.graphics.draw(dies, 400, 300)
  else
    word_handler:draw(400, 300)
  end
  iffy.drawSprite(keiki:get_name())
end
