function love.load()
    RETURNFORMAT = "natural" --natural or labelled (x=..)
    SCALE = 0.25
    getPositions()
    love.system.setClipboardText(calculateQuads())
    print(love.system.getClipboardText())
    love.event.quit()
end






--A CLEAN FUNCTION FOR EASY USE,JUST COPY AND PASTE
function UPDATE_INFORMATION()
    --Width and height of each of the bodies
    local bw,bh = nil, nil
    --Body positions (topleft)
    local bpos = {{},{},{},{},{},{},{},{}}

    --Rect positions
    local rdims = {size=#bpos,
                {},{},{},{},
                {},{},{},{}
            }

    return bw,bh,bpos,rdims
end


function UPDATE_INFORMATION()
    --Width and height of each of the bodies
    local bw,bh = 345,232
    --Body positions (topleft)
    local bpos = {{25,63},{425,28},{826,28},{1226,18},{1627,0},{2027,15},{2428,28},{2828,28}}

    --Rect positions
    local rdims = {size=#bpos,
                {25,2,345,292},{425,28,345,232},{826,28,345,232},{1226,18,345,249},
                {1627,0,345,285},{2027,15,345,254},{2428,28,345,232},{2828,28,345,232}
            }

    return bw,bh,bpos,rdims
end




































function getPositions()
    local bw,bh,bpos,rdims = UPDATE_INFORMATION()
    body = { size = 8,
        w=bw, h = bh,
        pos = bpos
    }
    rect = {
        dimensions = rdims
    }

    --Refactor helpfully
    for i = 1,#body.pos,1 do
        --Bodies
        body.pos[i].x = body.pos[i][1]
        body.pos[i].y = body.pos[i][2]
        body.pos[i][1],body.pos[i][2] = nil, nil

        --Rects
        rect.dimensions[i].x = rect.dimensions[i][1]
        rect.dimensions[i].y = rect.dimensions[i][2]
        rect.dimensions[i].w = rect.dimensions[i][3]
        rect.dimensions[i].h = rect.dimensions[i][4]
        rect.dimensions[i][1],rect.dimensions[i][2],rect.dimensions[i][3],rect.dimensions[i][4] = nil,nil,nil,nil
    end
end

function calculateQuads()

    function calculateCanvasSize()
        local left,right,up,down = 0,0,0,0
        for i = 1,body.size,1 do
            local b = body.pos[i]
            local re = rect.dimensions[i]

            --Calculate them!
            local l = b.x - re.x
            local r = (re.x + re.w) - (b.x + body.w)
            local u = b.y - re.y
            local d = (re.y + re.h) - (b.y + body.h)

            --Update the greatest
            if l > left then left = l end
            if r > right then right = r end
            if u > up then up = u end
            if d > down then down = d end
        end
        return {x=-left-1,y=-up-1,w=(left+body.w+right)+2,h=(up+body.h+down)+2} --Adding 1 in canvas size to compensate for rounding inaccuracies.
    end

    local canvas = calculateCanvasSize()

    local canvases = ""
    for i = 1,body.size,1 do
        local b = body.pos[i]
        if RETURNFORMAT == "labelled" then
            canvases = canvases .. "{x="..b.x+canvas.x..",y="..b.y+canvas.y..",w="..canvas.w..",h="..canvas.h.."},"
        elseif RETURNFORMAT == "natural" then
            canvases = canvases .. "{"..b.x+canvas.x..","..b.y+canvas.y..","..canvas.w..","..canvas.h.."},"
        end
        if i == math.floor(body.size/2) then
            canvases = canvases.. "\n"
        end
    end
    return canvases:sub(1, -2)
end
