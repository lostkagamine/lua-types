types = {}

function __gettype(val)
    for _,i in pairs(types) do
        if i._type(val) then return i._name end
    end
	return nil
end

function __type(typev, val)
    if not typev._type then
        error("Unable to apply typing!")
    end
	if not typev._type(val) then error(string.format("Invalid type! Expected '%s', instead got '%s'.", typev._name, __gettype(val))) end
end

table.insert(types, {
    _name='int',
    _type=function(v) 
        return type(v) == 'number' and math.floor(v) == v 
    end
})

table.insert(types, {
    _name='callable',
    _type=function(v) if type(v) == 'function' then return true end if not getmetatable(v) then return false end return not not getmetatable(v)['__call'] end
})

table.insert(types, {
    _name='string',
    _type=function(v) return tostring(v)==v end
})

table.insert(types, {
    _name='float',
    _type=function(v) return type(v) == 'number' and math.floor(v) ~= v end
})

for i, j in pairs(types) do
    if not _G[j._name] then
        _G[j._name] = j
    elseif type(_G[j._name]) == 'table' then
        for _,l in pairs(j) do _G[j._name][_]=l end
    end
end
