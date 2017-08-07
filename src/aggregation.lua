local M = {}

local function distinctable(func, col, dist)
    local content = dist and 'DISTINCT ' .. col or col
    return ('%s(%s)'):format(func, content)
end

function M.max(col, dist) return distinctable('MAX', col, dist) end
function M.min(col, dist) return distinctable('MIN', col, dist) end
function M.avg(col, dist) return distinctable('AVG', col, dist) end
function M.sum(col, dist) return distinctable('SUM', col, dist) end
function M.count(col, dist) return distinctable('COUNT', col, dist) end

return M
