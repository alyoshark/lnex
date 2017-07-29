local M = {}

local function make_alias(name, conf)
    return conf.orig .. ' AS ' .. name
end

function M.tab(tab, conf)
    if conf.tab then conf.orig = conf.tab
    else conf.orig = tab end
    return make_alias(tab, conf)
end

function M.col(col, conf)
    if conf.col then conf.orig = conf.col
    else conf.orig = col end
    return make_alias(col, conf)
end

return M
