local new_tab = require('table.new')
local clr_tab = require('table.clear')

local lnex = {}
lnex.__index = lnex

local function _expand(self, clause, vals)
    if not self[clause] then
        local len = #vals
        self[clause] = new_tab(len, 0)
    end
    local arr = self[clause]
    for _, v in ipairs(vals) do  -- clause check is so dirty QAQ
        if clause == 'groups' then table.insert(arr, v.name)
        else table.insert(arr, tostring(v)) end
    end
    return self
end

function lnex:select(selects)
    return _expand(self, 'selects', selects)
end

function lnex:from(froms)
    return _expand(self, 'froms', froms)
end

function lnex:groupby(groups)
    return _expand(self, 'groups', groups)
end

local function _conjunct(self, clause, preds)
    return _expand(self, clause, preds)
end

local function _disjunct(self, clause, preds)
    local predicate
    for i, p in ipairs(preds) do
        if i == 1 then predicate = p
        else predicate = predicate + p end
    end
    if not self[clause] then
        self[clause] = { predicate }
    else
        local l = #self[clause]
        local p = self[clause][l]
        self[clause][l] = ('%s OR %s'):format(p, predicate)
    end
    return self
end

function lnex:where(preds)
    return _conjunct(self, 'wheres', preds)
end

function lnex:orwhere(preds)
    return _disjunct(self, 'wheres', preds)
end

function lnex:having(preds)
    return _conjunct(self, 'havings', preds)
end

function lnex:orhaving(preds)
    return _disjunct(self, 'havings', preds)
end

function lnex:new(dialect)
    return setmetatable({
        dialect = dialect,
        selects = nil,
        froms = nil,
        wheres = nil,
        groups = nil,
        havings = nil,
    }, lnex)
end

local function _clause(clause, attrs, struct, sep, preserve)
    clause = clause .. ' ' .. table.concat(attrs, sep)
    table.insert(struct, clause)
    if not preserve then clr_tab(attrs) end
end

local function _compile(self, preserve)
    local selects, froms, wheres, groups, havings = 'SELECT *'
    local struct = new_tab(5, 0)
    if self.selects then _clause('SELECT', self.selects, struct, ', ', preserve) end
    if self.froms then _clause('FROM', self.froms, struct, ', ', preserve) end
    if self.wheres then _clause('WHERE', self.wheres, struct, ' AND ', preserve) end
    if self.groups then _clause('GROUP BY', self.groups, struct, ', ', preserve) end
    if self.havings then _clause('HAVING', self.havings, struct, ' AND ', preserve) end
    local result = table.concat(struct, ' ')
    if not preserve then clr_tab(struct) end
    return result
end

function lnex:debug()
    return _compile(self, true)
end

lnex.__tostring = _compile

return lnex
