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

local word_handler = words.make_handler(font, words.names, white, red)

function love.load()
  love.keyboard.setTextInput(true)
end

local fails = 0
local status = words.status.continue
function love.keypressed(key, code, isrep)
  print(key, code)
  if (fails < 3 and status ~=words.status.finished) then
    status = word_handler:update(key)
    if (status == words.status.bad_char) then
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
  love.graphics.print(string.format("FAILED: %d", fails), 400, 280)
  if (status == words.status.finished) then
    love.graphics.draw(yippie, 400, 300)
  elseif (fails >= 3) then
    love.graphics.draw(dies, 400, 300)
  else
    word_handler:draw(400, 300)
  end
  iffy.drawSprite(keiki:get_name())
end
