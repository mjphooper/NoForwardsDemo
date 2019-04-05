Stack = Class("Stack")

function Stack:initialize()
    self.data = {}
end

function Stack:push(d)
    table.insert(self.data,d)
end

function Stack:pop()
    if #self.data > 0 then
        return table.remove(self.data,#self.data)
    else
        return false
    end
end

function Stack:peek()
    if #self.data > 0 then
        return self.data[#self.data]
    else
        return false
    end
end

function Stack:print()
    local str = ""
    for i =1,#self.data,1 do
        str = str .. tostring(self.data[i]).." ,"
    end
    print(str)
end

return Stack
