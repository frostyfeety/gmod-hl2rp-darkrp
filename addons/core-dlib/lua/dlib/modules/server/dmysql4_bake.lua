local table, type, error, assert
do
  local _obj_0 = _G
  table, type, error, assert = _obj_0.table, _obj_0.type, _obj_0.error, _obj_0.assert
end
do
  local _class_0
  local _base_0 = {
    ExecInPlace = function(self, ...)
      return self.database:Query(self:Format(...))
    end,
    Execute = function(self, ...)
      return self:Format(...)
    end,
    Format = function(self, ...)
      if self.length == 0 then
        return self.raw
      end
      self.buff = { }
      for i, val in ipairs(self.parts) do
        if i == #self.parts then
          table.insert(self.buff, val)
        elseif select(i, ...) == nil then
          table.insert(self.buff, val)
          table.insert(self.buff, 'null')
        elseif type(select(i, ...)) == 'boolean' then
          table.insert(self.buff, val)
          table.insert(self.buff, SQLStr(select(i, ...) and '1' or '0'))
        else
          table.insert(self.buff, val)
          table.insert(self.buff, SQLStr(tostring(select(i, ...))))
        end
      end
      return table.concat(self.buff)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, database, plain)
      assert(type(plain) == 'string', 'Raw query is not a string! ' .. type(plain))
      self.database = database
      self.raw = plain
      self.parts = plain:split('?')
      self.length = #self.parts - 1
    end,
    __base = _base_0,
    __name = "PlainBakedQuery"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DMySQL4.PlainBakedQuery = _class_0
  return _class_0
end
