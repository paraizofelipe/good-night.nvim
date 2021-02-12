local utils = {}

utils.contains = function(list, value) 
	for _, v in pairs(list) do
        if v == value then 
            return true 
        end
    end

    return false
end

utils.split = function(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

return utils
