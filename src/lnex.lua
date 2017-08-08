local new_tab = require('table.new')
local clr_tab = require('table.clear')

local lnex = {}
lnex.__index = lnex

local function expand_clause(self, clause, vals)
    if not self[clause] then self[clause] = {} end
    local arr = self[clause]
    for _, v in ipairs(vals) do
        if type(v) == 'string' then table.insert(arr, v)
        else table.insert(arr, tostring(v)) end
    end
    return self
end

function lnex:select(cols)
    return expand_clause(self, 'columns', cols)
end

function lnex:from(tabs)
    return expand_clause(self, 'tables', tabs)
end

local function _conjunct(self, clause, preds)
    return expand_clause(self, clause, preds)
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
        columns = nil,
        tables = nil,
        wheres = nil,
        groups = nil,
        havings = nil,
    }, lnex)
end

function lnex:__tostring()
    local cols, froms, wheres, groups, havings = 'SELECT *'
    local struct = new_tab(5, 0)
    if self.columns then
        cols = 'SELECT ' .. table.concat(self.columns, ', ')
        table.insert(struct, cols)
    end
    if self.tables then
        froms = 'FROM ' .. table.concat(self.tables, ', ')
        table.insert(struct, frome)
    end
    if self.wheres then
        wheres = 'WHERE ' .. table.concat(self.wheres, ' AND ')
        table.insert(struct, wheres)
    end
    if self.groups then
        groups = 'GROUP BY ' .. table.concat(self.groups, ' AND ')
        table.insert(struct, groups)
    end
    if self.havings then
        havings = 'HAVING ' .. table.concat(self.havings, ' AND ')
        table.insert(struct, havings)
    end
    local result = table.concat(struct, ' ')
    clr_tab(struct)
    return result
end

return lnex
