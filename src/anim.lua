local _M = {}

function _M.make_anim(name, count, duration)
  return {
    name = name,
    count = count,
    duration = duration,
    index = 0,
    time = 0,
    update = function(self, dt)
      self.time = self.time + dt
      if (self.time >= self.duration) then
        self.time = 0
        self.index = (self.index + 1) % count
      end
    end,
    get_name = function(self)
      return string.format("%s%d", name, self.index)
    end,
  }
end

return _M
