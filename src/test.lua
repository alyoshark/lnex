local lnex = require('lnex')
local alias = require('alias')

local t = alias.tab('t1', { tab = 'ta' })
local c = alias.col('c1', { col = 'ca' })

for i = 1, 100000 do  -- luajit -jv test.lua
    local q = lnex:new('mysql'):select({c, 'title', 'author'}):from({t, 'books'})()
end

print(lnex:new('mysql'):select({c, 'title', 'author'}):from({t, 'books'})())
