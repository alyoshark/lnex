local alias = {}
setmetatable(alias, alias)

function alias:__tostring()
    return ('%s AS %s'):format(self.orig, self.name)
end

function alias:__call(orig, name)
    return setmetatable({ orig = orig, name = name }, alias)
end

return alias
