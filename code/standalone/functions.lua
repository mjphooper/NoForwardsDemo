--MOUSE FUNCTION
mouse = {
    click=false,clickx=-1,clicky=-1,x=-1,y=-1,inclick=false,
    visible=true
}
mouse.update = function()
    if mouse.click then
    mouse.click = false
        mouse.clickx,mouse.clicky =-1,-1
    end
 	mouse.x,mouse.y = love.mouse.getPosition()
 	if love.mouse.isDown(1) and not mouse.inclick then
 	      mouse.click = true
 		mouse.clickx,mouse.clicky = love.mouse.getPosition()
 		mouse.inclick = true
 	end
 	if not love.mouse.isDown(1) then mouse.inclick = false end
 end

mouse.setVisible = function(v)
    love.mouse.setVisible(v)
    mouse.visible = true
end

--KEYBOARD FUNCITONS
keyboard = {
    keyDown = ""
}
keyboard.update = function()
    keyboard.keyDown = ""
end

--GENERAL FUNCTIONS
function notnil(v)
    if v == nil then return false else return true end
end

--COLLISION FUNCTIONS
function squareCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end


function pointCollision(px,py,x,y,w,h)
    if (px > x and px < x + w) and (py > y and py < y + h) then
        return true
    end
    return false
end



--GRAPHICS FUNCTIONS
function love.graphics.dashedLine(sx,sy,ex,ey,dash,gap)
    local dy, dx = ey - sy, ex - sx
    local an, st = math.atan2( dy, dx ), dash + gap
    local len	 = math.sqrt( dx*dx + dy*dy )
    local nm	 = ( len - dash ) / st
    love.graphics.push()
        love.graphics.translate( sx, sy )
        love.graphics.rotate( an )
        for i = 0, nm do
            love.graphics.line( i * st, 0, i * st + dash, 0 )
        end
        love.graphics.line( nm * st, 0, nm * st + dash,0 )
    love.graphics.pop()
end

function love.graphics.printcustom(text,x,y,col,config)
    setColor(col[1],col[2],col[3],col[4] or 255)
    if notnil(config) then
        if notnil(config.font) then love.graphics.setFont(config.font) end
    end
    love.graphics.print(text,x,y)
    love.graphics.setFont(fonts.debug)
    flushColor()

end

--INDEPEDENCE FUNCTION
--this will run only one of the entered functions at a time.
--f = the update function, running = wether that update is currently attemtping to be called.
--lower the table index, the higher the priority ie if there's a clash, the lower index will be run.
--[[
function runIndependently(tbl) --where tbl is : {{f=function title,running=false}}
    for i = 1,#tbl,1 do
        if tbl[i].running then
            for j = i+1,#tbl,1 do
                if tbl[j].running then
                     tbl[j][1]()
                     return
                end
            end
            tbl[i][1]()
            return
        end
    end
    fold(tbl,function(head) head[1]() end)
end
--[[table={
    {function() end,runing=},
    {function() end,running=}
}--]]
function runIndependently(tbl)
    for i = 1,#tbl,1 do
        if tbl[i].running then
            tbl[i][1]()
        end
    end
end



--TABLE FUNCTIONS
function print_table(t)
	local string = "{"
	for i = 1,#t-1,1 do
		string = string..t[i]
	end
	return string..string[#t].."}"
end

function isEmpty(t)
    if #t > 0 then return false end
    return true
end

function merge(t1, t2)
    local ret = dereferencedTableCopy(t1)
    for i = 1,#t2,1 do
        table.insert(ret,t2[i])
    end
    return ret
end

function referenceMerge(t1,t2)
    for i = 1,#t2,1 do
        table.insert(t1,t2[i])
    end
end

function hd(tbl)
    return tbl[1]
end

function tl(tbl)
    return { select(2, unpack(list)) }
end

function fold(tbl,f,ret)
    for i=#tbl,1,-1 do
        if ret then tbl[i] = f(tbl[i],i)
        else f(tbl[i],i) end
    end
    if ret then return tbl end
end

function foldCondition(tbl,f,conditionF)
    for i=#tbl,1,-1 do
        if conditionF(tbl[i]) then f(tbl[i]) end
    end
end

function linearSearch(tbl,item)
    for i = 1,#tbl,1 do
        if tbl[i] == item then
            return true
        end
    end
    return false
end

function frontToBack(tbl)
    local f = tbl[1]
    table.remove(tbl,1)
    table.insert(tbl,f)
    return tbl
end

function populatedTable(n,data)
    local ret = {}
    for i = 1,n,1 do
        table.insert(ret,data)
    end
    return ret
end

function dereferencedTableCopy(t) --Must be a 1d array
    local copy = {}
    for i =1,#t,1 do
        table.insert(copy,t[i])
    end
    return copy
end

function tableKeySize(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

function randomKeyedValue(tbl)
    local keys = {}
    for k,v in pairs(tbl) do table.insert(keys,k) end
    return tbl[keys[love.math.random(1,#keys)]]
end


function table.min(tbl,customFunc)
    local copy = dereferencedTableCopy(tbl)
    table.sort(copy,customFunc or nil)
    return copy[1]
end

--GENERAL STUFF

function maxOut(var,amount,max)
    var = var + amount
    if var > max then var = max end
    return var
end

--COLOR FUNCTIONS
function setColor(r,g,b,a)
    if type(r) == "table" then r,g,b,a = r[1],r[2],r[3],r[4] end
    if not notnil(a) then a = 1 else a = a/255 end
    love.graphics.setColor(r/255,g/255,b/255,a)
end

function flushColor()
    love.graphics.setColor(1,1,1)
end

-- Converts HSL to RGB. (input and output range: 0 - 255)
function HSL(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m)*255,(g+m)*255,(b+m)*255,a
end

--MATHS FUNCTIONS
function math.sign(int)
    if int >= 0 then return 1 else return -1 end
end

function math.flatDistance(a,b)
    return math.abs(a-b)
end

function math.round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function math.pointWithinCircle(cx,cy,r,px,py)
    return math.sqrt(
        (math.abs(px-cx)^2) + (math.abs(py-cy)^2)
    ) < r
end

function math.valueBetween(val,a,b)
    if val > math.min(a,b) and val < math.max(a,b) then
        return true
    end
    return false
end

function math.keepPositive(val)
    if val < 0 then return 0
    else return val end
end 

function math.limitBetween(min,val,max)
    return math.max(min,math.min(val,max))
end


--Line point given equation, starting point and length of line
function math.angleLinePoint(x,y,angle)
    local m = math.tan(angle)
    local c = y - (m*x)
    local subx = x+100
    return subx,((m*subx)+c)
end
--Line intersecting circle
function math.lineDistanceFromPoint(line,x0,y0) --line.x1,y1, line.x2,y2
    local x1,y1,x2,y2 = line.x1,line.y1,line.x2,line.y2
    return math.abs((y2-y1)*x0 - (x2-x1)*y0 + x2*y1 - y2*x1) / math.sqrt((y2-y1)^2 + (x2-x1)^2)
end

function math.lineIntersectsCircle(cx,cy,r,x1,y1,x2,y2)
    if math.lineDistanceFromPoint({x1=x1,y1=y1,x2=x2,y2=y2},cx,cy) <= r then return true end
    return false
end
--Line segment intersecting circle
local function dist2(v, w) return (v.x - w.x)^2 + (v.y - w.y)^2 end
function math.distFromPointToLineSegment(p,v,w) --p is the circle point.
    local l2 = dist2(v,w) --l2 is the length of the line
    if (l2==0) then return dist2(p,v) end  --if l2==0, just apoint, so return simple distance
    --stuffs
    local t = ((p.x-v.x) * (w.x-v.x) + (p.y-v.y) * (w.y-v.y)) / l2
    t = math.max(0, math.min(1,t))
    local retX, retY = v.x + t * (w.x - v.x), v.y + t * (w.y-v.y)
    return math.sqrt(dist2(p,{x=retX,y=retY}))
end
--function math.lineSegmentIntersectsCircle(p,r,v,w) return Math.sqrt(distToSegmentSquared(p,v,w)) < r  end
function math.lineSegmentIntersectsCircle(cx,cy,r,x1,y1,x2,y2) return math.distFromPointToLineSegment({x=cx,y=cy},{x=x2,y=y2},{x=x1,y=y1}) < r  end
