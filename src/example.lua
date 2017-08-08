local utils = require('utils')
local lnex = require('lnex')
local alias = require('alias')
local pred = require('predicate')

local t = alias('ta', 't1')
local c = alias('ca', 'c1')

local p1 = pred('title', '=', 'startup')
local p2 = pred('year', '=', 1998)

-- -- luajit -jv test.lua
for i = 1, 100000 do
    local q = lnex:new('mysql')
                  :select({c, 'title', 'year'})
                  :from({t, 'books'})
                  :where({p1, p2})
    tostring(q)
end

print('-- basic:')
local q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'})
print(p1)
print(p2)
print(q)

print('\n-- list:')
q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'})
print(q:where({p1, p2}))

print('\n-- chained:')
q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'})
print(q:where({p1}):where({p2}))

print('\n-- conjunction:')
q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'})
print(q:where({p1 * p2}))

print('\n-- disjunction:')
q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'})
print(q:where({p1 + p2}))

print('\n-- orwhere:')
q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'}):where({p1})
print(q:orwhere({p2}))

print('\n-- by specification:')
q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'})
local p = pred.spec({ title = 'startup', year = 1998 })
print(p)
print(q:where({p}))

print('\n-- negation:')
q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'})
local p = -pred.spec({ title = 'startup', year = 1998 })
print(p)
print(q:where({p}))

print('\n-- where in:')
q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'})
local p = pred.within('title', { 'startup', 'computing' }) *
          pred.within('year', { 1998, 1999, 2000 })
          pred.within(c, { 'some', 'random', 'values' })
print(p)
print(q:where({p}))

print('\n-- where in query:')
q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'})
p = pred.withinq(c, lnex:new('mysql'):select({'year'}):from({'books'}))
print(p)
print(q:where({p}))

print('\n-- having:')
q = lnex:new('mysql'):select({c, 'title', 'year'}):from({t, 'books'}):having({p1})
print(q)
