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

function lnex:where(preds)
    return expand_clause(self, 'predicates', preds)
end

function lnex:orWhere(preds)
    local predicate
    for i, p in ipairs(preds) do
        if i == 1 then predicate = v
        else predicate = predicate + p end
    end
    if not self.predicates then
        self.predicates = { predicate }
    else
        local l = #self.predicates
        local p = self.predicates[l]
        p = p + predicate
    end
    return self
end

function lnex:__tostring()
    local cols, froms, preds = 'SELECT *', nil, nil
    if self.columns then
        cols = 'SELECT ' .. table.concat(self.columns, ', ')
    end
    if self.tables then
        froms = 'FROM ' .. table.concat(self.tables, ', ')
    end
    if self.predicates then
        preds = 'WHERE ' .. table.concat(self.predicates, ' AND ')
    end
    return table.concat({ cols, froms, preds }, ' ')
end

function lnex:new(dialect)
    return setmetatable({
        dialect = dialect,
        columns = nil,
        tables = nil,
        predicates = nil,
    }, lnex)
end

return lnex
