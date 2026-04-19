local love = _G.love

local _M = {}

_M.CODE = {
  continue = 0,
  finished = 1,
  bad_char = 2,
}

_M.ENTRIES = {
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

local function on_key_update(self, key)
  local function get_word()
    return self.word_set[self.word_idx+1]
  end
  local word_count = #self.word_set
  local pos = self.word_pos
  local word = get_word()
  self.normal_text:set{self.normal_color, word}
  local ch = word:sub(pos, pos)

  local status = _M.CODE.continue
  if (key:upper() == ch) then
    local next = word:sub(pos+1, pos+1)
    if (next == "") then
      self.word_idx = self.word_idx + 1
      if (self.word_idx == word_count) then
        self.word_idx = 0
        status = _M.CODE.finished
      end
      self.word_pos = 1
      ch = get_word():sub(pos, pos)
      self.normal_text:set{self.normal_color, get_word()}
      self.fill_string = ""
    else
      self.word_pos = self.word_pos + 1
      self.fill_string = self.fill_string .. ch
    end
    self.fill_text:set{self.fill_color, self.fill_string}
  else
    status = _M.CODE.bad_char
  end
  return status
end

local function on_word_reset(self)
  self.word_pos = 1
  self.fill_string = ""
  self.fill_text:set{self.fill_color, self.fill_string}
end

local function on_draw(self, x, y)
  love.graphics.draw(self.normal_text, x, y)
  love.graphics.draw(self.fill_text, x, y)
end

function _M.make_handler(font, word_set, normal, fill)
  return {
    normal_text = love.graphics.newText(font, word_set[1]),
    normal_color = normal,

    fill_string = "",
    fill_text = love.graphics.newText(font, word_set[1]),
    fill_color = fill,

    word_set = word_set,
    word_idx = 0,
    word_pos = 1,

    update = on_key_update,
    draw = on_draw,
    reset_word = on_word_reset,
  }
end

return _M
