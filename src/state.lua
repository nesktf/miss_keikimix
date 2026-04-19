local words = require('words')
local modes = require('modes')

local _M = {}

local state = {
  mode = nil,
  handler = nil,
  ending = nil,
  fails = 0,
  word_count = 0,
  word_total = 0,
  word_status = words.status.finished,
}

function _M.reset(font, mode_index, ending_cb)
  local red = {1, 0, 0, 1}
  local white = {1, 1, 1, 1}
  state.mode = modes.modes[mode_index]
  state.fails = 0
  state.word_count = 0
  state.word_total = #state.mode.words
  state.word_status = words.status.continue
  state.handler = words.make_handler(font, state.mode.words, white, red)
  state.ending_cb = ending_cb
end

function _M.status_string()
  return string.format("MODE: %s\nPROGRESS: %d/%d (%.2f%%)\nFAILED: %d/%d",
    state.mode.name, state.word_count, state.word_total, state.word_count*100/state.word_total,
    state.fails, state.mode.tries
  )
end

function _M.key_update(key)
  if (state.fails < state.mode.tries and words.is_valid_char(key)
      and state.word_status ~= words.status.finished) then
    state.word_status = state.handler:update(key)
    if (state.word_status == words.status.bad_char) then
      state.handler:reset_word()
      state.fails = state.fails + 1
    elseif (state.word_status == words.status.end_word
            or state.word_status == words.status.finished) then
      state.word_count = state.word_count + 1
    end
  end
  if (state.word_count == state.word_total or state.fails >= state.mode.tries) then
    state.ending_cb(state.word_status)
  end
end

function _M.get_icon()
  return state.mode.icon
end

function _M.draw_word(x, y)
  state.handler:draw(x, y)
end

function _M.fail_input()
  state.fails = state.fails + 1
end

function _M.next_word()
  state.word_count = state.word_count + 1
end

return _M
