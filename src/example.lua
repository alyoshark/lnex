local utils = require('utils')
local lnex = require('lnex')
local alias = require('alias')
local pred = require('predicate')

local t = alias.tab('t1', { tab = 'ta' })
local c = alias.col('c1', { col = 'ca' })

local p1 = pred('title', '=', utils.squote('startup'))
local p2 = pred('year', '=', 1998)

-- -- luajit -jv test.lua
for i = 1, 100000 do
    local q = lnex:new('mysql')
                  :select({c, 'title', 'year'})
                  :from({t, 'books'})
                  :where({p1, p2})
    tostring(q)
end

print('basic:')
local q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'})
print(p1)
print(p2)
print(q)

print('\nlist:')
local q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'})
print(q:where({p1, p2}))

print('\nchained:')
local q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'})
print(q:where({p1}):where({p2}))

print('\nconjunction:')
local q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'})
print(q:where({p1 * p2}))

print('\ndisjunction:')
local q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'})
print(q:where({p1 + p2}))
