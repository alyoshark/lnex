local lnex = {}
lnex.__index = lnex

local function expand_clause(self, clause, vals)
    if not self[clause] then self[clause] = {} end
    local arr = self[clause]
    for _, v in ipairs(vals) do
        if clause == 'predicates' then
            table.insert(arr, tostring(v))
        else
            table.insert(arr, v)
        end
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

function lnex:compile()
    local cols, froms, preds = 'SELECT *', '', ''
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
lnex.__tostring = lnex.compile

function lnex:new(dialect)
    return setmetatable({
        dialect = dialect,
        columns = nil,
        tables = nil,
        predicates = nil,
    }, self)
end

return lnex
