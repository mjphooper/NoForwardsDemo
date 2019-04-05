function animationFromSpritesheet(path,default)

  --Create the spritsheet object and get the data.
  local sheet = Spritesheet:new(path)
  local sheetImage = sheet:getSheet()
  local positionData = sheet:getPositionData()

  -- Parse the data into format for an animation.
  local actions = {}
  for row = 1,#positionData,1 do --for each row,
    local rowData = positionData[row]
    local action = {name=rowData.name,spriteTable={}}
    for quad = 1,#rowData,1 do --for quads in the row,
      local image = rowData[quad]
      table.insert(action.spriteTable,love.graphics.newQuad(image.x,image.y,image.w,image.h,sheetImage:getWidth(),sheetImage:getHeight()))
    end
    table.insert(actions,action)
  end

  -- Find the default animation
  local defaultAction = nil
  for a = 1,#actions,1 do
     print(tostring(actions[a].name).." == "..tostring(default))
    if (actions[a].name == default) then
      defaultAction = actions[a]
      table.remove(actions,a)
      break
    end
  end
  if defaultAction == nil then --If default action still not assigned, make it the first action [random]
    defaultAction = actions[1]
    table.remove(actions,1)
  end


  -- Create and supply the animation
  local animation = Animator:new(defaultAction,4,{paused=false,loop=true,quadImage=love.graphics.newImage(sheetImage)})
  for a = 1,#actions,1 do
    animation:supplyAction(actions[a])
  end

  return animation
end
