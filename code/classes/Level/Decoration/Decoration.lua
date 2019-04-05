local Decoration = Class("Decoration")

function Decoration:initialize(level,x,y)
    self.level = level
    self.x,self.y = x,y
    self.timer = 0
    self.trash = false
end

function Decoration:decoration_update()
    self.timer = time:deltaInc(self.timer,1)
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--STATIC FUNCTIONS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function Decoration:collectTrash(tbl)
    for i = #tbl,1,-1 do
        if tbl[i].trash then
            table.remove(tbl,i)
        end
    end
end

return Decoration
