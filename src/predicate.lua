local utils = require('utils')

local pred = {}

function pred:__tostring()
    return self.str
end

function pred:__concat(o)
    local str = tostring(self) .. tostring(o)
    return setmetatable({ str = str }, pred)
end

function pred:__mul(o)  -- conjunction
    local l, r = tostring(self), tostring(o)
    local str = ('%s AND %s'):format(l, r)
    return setmetatable({ str = str }, pred)
end

function pred:__add(o)  -- disjunction
    local l, r = tostring(self), tostring(o)
    local str = ('%s OR %s'):format(l, r)
    return setmetatable({ str = str }, pred)
end

function pred:__call(col, op, val, bracketify)
    local str = ('%s %s %s'):format(col, op, val)
    if bracketify then str = utils.bracket(str) end
    return setmetatable({ str = str }, pred)
end

return setmetatable(pred, pred)
