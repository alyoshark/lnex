local M = {}

function M.bracket(x) return ('(%s)'):format(x) end
function M.backtick(x) return ('`%s`'):format(x) end
function M.squote(x) return ("'%s'"):format(x) end
function M.dquote(x) return ('"%s"'):format(x) end

return M
