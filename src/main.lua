local love = _G.love
local anim = require('anim')
local iffy = require('lib.iffy')
local words = require('words')
local state = require('state')

iffy.newAtlas("image/keiki.png")
local font = love.graphics.newFont("font/CousineNerdFont-Regular.ttf", 20)
local yippie = love.graphics.newText(font, "Yippie!!11!1")
local dies = love.graphics.newText(font, "DEAD")

local draw_idx = 0
state.reset(font, 1, function(status)
  if (status == words.status.finished) then
    print("Finish")
    draw_idx = 2
  else
    print("Failed")
    draw_idx = 1
  end
end)

function love.keypressed(key, code, isrep)
  state.key_update(key)
end

local keiki = anim.make_anim("keiki", 30, 0.016)
function love.update(dt)
  keiki:update(dt)
end

function love.draw()
  love.graphics.print(state.status_string(), 400, 250)
  if (draw_idx == 0) then
    state.draw_word(400, 300)
  elseif (draw_idx == 1) then
    love.graphics.draw(dies, 400, 300)
  else
    love.graphics.draw(yippie, 400, 300)
  end
  iffy.drawSprite(keiki:get_name())
  love.graphics.draw(state.get_icon(), 400, 320)
end
