local love = _G.love
local anim = require('anim')
local iffy = require('lib.iffy')
local words = require('words')
local modes = require('modes')
local state = require('state')

iffy.newAtlas("image/keiki.png")
local word_font = love.graphics.newFont("font/CousineNerdFont-Regular.ttf", 50)
local menu_font = love.graphics.newFont("font/CousineNerdFont-Regular.ttf", 40)
local title_font = love.graphics.newFont("font/CousineNerdFont-Regular.ttf", 60)
local keiki_smol = love.graphics.newImage("image/keiki_smol.png")
local lmao = love.graphics.newImage("image/itsover.jpg")
local yippie = love.graphics.newImage("image/yippie.png")

local stage_music = {
  love.audio.newSource("audio/gameplay.ogg", "stream"),
  love.audio.newSource("audio/evil_gameplay.ogg", "stream"),
}
local menu_music = love.audio.newSource("audio/title.ogg", "stream")
local death_music = love.audio.newSource("audio/death.ogg", "stream")
local win_music = love.audio.newSource("audio/win.ogg", "stream")

local youwon = love.graphics.newText(word_font, "You won!11!11!")
local youdied = love.graphics.newText(word_font, "DEAD LOL")
local oktext = love.graphics.newText(word_font, "ok")
oktext:set{{1, 0, 0, 1}, "ok"}

local screen_state = {
  menu = 0,
  ingame = 1,
  dead = 2,
  win = 3,
}

local screen = screen_state.menu

local function start_game(mode_idx)
  state.reset(word_font, mode_idx, function(status)
    if (status == words.status.finished) then
      screen = screen_state.win
      love.audio.stop()
      love.audio.play(win_music)
    else
      love.audio.stop()
      love.audio.play(death_music)
      screen = screen_state.dead
    end
  end)
  love.audio.stop()
  love.audio.play(stage_music[modes.modes[mode_idx].music])
  screen = screen_state.ingame
end

love.audio.play(menu_music)

local menu_mode = 0
local keiki = anim.make_anim("keiki", 30, 0.016)
local title_text = love.graphics.newText(title_font, "Miss Keikimix")
local mode_texts = (function()
  local out = {}
  for _,mode in ipairs(modes.modes) do
    table.insert(out, love.graphics.newText(menu_font, mode.name))
  end
  return out
end)()
local funny_enabled = true

local function recolor_text()
  for i, text in ipairs(mode_texts) do
    local color
    if (menu_mode+1 == i) then
      color = {1, 0, 0, 1}
    else
      color = {1, 1, 1, 1}
    end
    text:set{color, modes.modes[i].name}
  end
end
recolor_text()

function love.keypressed(_, key, isrep)
  if (screen == screen_state.ingame) then
    state.key_update(key)
  elseif (screen == screen_state.menu) then
    local extra = funny_enabled and 0 or 1
    if (key == "down") then
      menu_mode = (menu_mode + 1) % (#mode_texts - extra)
      recolor_text()
    elseif (key == "up") then
      menu_mode = (menu_mode - 1) % (#mode_texts - extra)
      recolor_text()
    elseif (key == "return") then
      start_game(menu_mode+1)
    end
  elseif (screen == screen_state.win or screen == screen_state.dead) then
    if (key == "return") then
      love.audio.stop()
      love.audio.play(menu_music)
      screen = screen_state.menu
    end
  end
end

function love.update(dt)
  if (screen == screen_state.ingame) then
    keiki:update(dt)
    state.update(dt)
  end
end

local function draw_menu()
  love.graphics.draw(title_text, 50, 40)
  love.graphics.draw(keiki_smol, 550, 0)
  local text_y = 200
  local function draw_mode(mode, i)
    local icon = modes.modes[i].icon
    love.graphics.draw(mode, 100, text_y + (50*i))
    if (menu_mode+1 == i) then
      love.graphics.draw(icon, 300, 350 - (icon:getHeight() / 2))
    end
  end
  for i = 1, #mode_texts-1 do
    draw_mode(mode_texts[i], i)
  end
  if (funny_enabled) then
    draw_mode(mode_texts[5], 5)
  end
end

local function draw_game()
  love.graphics.print(state.status_string(), 60, 200)
  state.draw_word(60, 260)
  iffy.drawSprite(keiki:get_name(), 400 - (322 / 2) + 200, 300 - (322/2))
end

local function draw_death()
  love.graphics.draw(youdied, 120, 260)
  love.graphics.draw(lmao, 400, 300 - (lmao:getHeight() / 2))
  love.graphics.draw(oktext, 120, 360)
end

local function draw_win()
  love.graphics.draw(youwon, 120, 160)
  love.graphics.draw(yippie, 400, 380 - (yippie:getHeight() / 2))
  love.graphics.draw(oktext, 120, 260)
end

function love.draw()
  if (screen == screen_state.ingame) then
    draw_game()
  elseif (screen == screen_state.dead) then
    draw_death()
  elseif (screen == screen_state.win) then
    draw_win()
  elseif (screen == screen_state.menu) then
    draw_menu()
  end
end
