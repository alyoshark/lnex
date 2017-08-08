local utils = require('utils')

local pred = {}
setmetatable(pred, pred)

local function _create(col, op, val, conf)
    if type(col) ~= 'string' then col = col.name end
    local fmt, result = '%s %s %s', ''
    if not conf then
        result = fmt:format(col, op, val)
        return setmetatable({ str = result }, pred)
    end
    local quote = conf.quote
    if quote == 'backtick' then val = utils.backtick(val)
    elseif quote == 'double' then val = utils.dquote(val)
    elseif quote == 'single' then val = utils.squote(val)
    else val = val end
    result = fmt:format(col, op, val)
    if conf.bracket then result = utils.bracket(result) end
    return setmetatable({ str = result }, pred)
end

function pred:__tostring()
    return self.str
end

function pred:__concat(o)
    local str = self .. o
    return setmetatable({ str = str }, pred)
end

function pred:__mul(o)  -- conjunction
    local str = ('%s AND %s'):format(self, o)
    return setmetatable({ str = str }, pred)
end

function pred:__add(o)  -- disjunction
    local str = ('%s OR %s'):format(self, o)
    return setmetatable({ str = str }, pred)
end

function pred:__unm()  -- negation
    local str = ('NOT (%s)'):format(self)
    return setmetatable({ str = str }, pred)
end

function pred:__call(col, op, val)
    local conf = type(val) == 'string' and { quote = 'single' }
    return _create(col, op, val, conf)
end

function pred.spec(spec)
    local predicate
    for k, v in pairs(spec) do
        local p = _create(k, '=', v)
        if not predicate then predicate = p
        else predicate = predicate * p end
    end
    return predicate
end

function pred.within(col, vals)
    if type(vals[1]) == 'string' then
        for i, v in ipairs(vals) do
            vals[i] = utils.squote(v)
        end
    end
    local valstr = utils.bracket(table.concat(vals, ','))
    return _create(col, 'IN', valstr)
end

function pred.withinq(col, qry)
    return _create(col, 'IN', utils.bracket(tostring(qry)))
end

return pred
