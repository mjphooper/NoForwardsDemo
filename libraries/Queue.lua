Queue = Class("Queue")

function Queue:initialize()
    self.data = {}
end

function Queue:push(data)
    table.insert(self.data,data)
end

function Queue:peek()
    return self.data[1]
end

function Queue:pop()
    return table.remove(self.data,1)
end

function Queue:getSize()
    return #self.data
end

function Queue:get(i)
    return self.data[i]
end

return Queue
