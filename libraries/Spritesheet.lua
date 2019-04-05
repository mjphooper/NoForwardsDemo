local Writer = Class("Writer")

  function Writer:initialize()
    -- Create the empty spritesheet.
    self.canvas = love.image.newImageData(1,1)
    -- Create the table to store position data.
    self.positionData = {}
    -- Set variables .
    self.canvasW = 1
    self.canvasH = 1
    self.pasteY = 0
    self.nextPasteY = 0
    self.rowName = ""
    self.clipboard = {} -- Table of images to be pasted onto current row.

  end

  function Writer:clipboardAdd(image)
    table.insert(self.clipboard,image);
  end

  function Writer:setRowName(name)
    self.rowName = name or ""
  end

  function Writer:newCanvasSize(w,h)
    local canvasW, canvasH = self.canvas:getDimensions()
    local newCanvas = love.image.newImageData(
      w or canvasW,
      h or canvasH)
    newCanvas:paste(self.canvas,0,0,0,0,canvasW,canvasH)
    self.canvas = newCanvas
  end

  function Writer:prepareCanvas()
    -- Variables to be decided per row.
    local tallest = 0
    local totalWidth = 0
    -- Iterate through each image.
    for i = 1,#self.clipboard,1 do
      local image = love.image.newImageData(self.clipboard[i])
      if image:getHeight() > tallest then tallest = image:getHeight() end
      totalWidth = totalWidth + image:getWidth() + 1 -- 1px image spacing.
      self.clipboard[i] = image
    end
    -- Resize the canvas size if the current row is too wide for it.
    local newWidth = self.canvasW
    if totalWidth > self.canvasW then
        newWidth = totalWidth
    end
    self.newCanvasSize(self,newWidth,self.canvasH+tallest) -- 1px image spacing.
    self.canvasW, self.canvasH = self.canvas:getDimensions()


    self.pasteY = self.nextPasteY
    self.nextPasteY = self.pasteY + tallest + 1

  end

  function Writer:paste()
    if(#self.clipboard > 0) then
      self.prepareCanvas(self)
      -- Local vars used
      local pasteX = 0
      local rowData = {}

      -- Iterate through each of the images to paste.
      for i = 1,#self.clipboard,1 do
        -- Grab the data for the current imageData
        local imageData = self.clipboard[i]
        local w, h = imageData:getWidth(),imageData:getHeight()

        -- Paste!
        self.canvas:paste(imageData,pasteX,self.pasteY,0,0,w,h)
        print("just pasted::"..tostring(self.rowName).."@"..pasteX..","..self.pasteY..",0,0,"..w..","..h)


        -- Update the rowData table.
        local imageDetail = {x = pasteX, y = self.pasteY, w = w, h = h}
        table.insert(rowData,imageDetail)

        --Update the x value
        pasteX = pasteX + w + 1 -- 1px image spacing.
      end

      rowData.name = self.rowName;
      table.insert(self.positionData,rowData)
    end

    -- Post functions.
    table.insert(self.positionData,rowData) -- Add rowData to positionData
    self.clipboard = {} -- Clear the clipboard.
    self.setRowName(self)

  end


  function Writer:getCanvas()
    return self.canvas
  end

  function Writer:getPositionData()
    return self.positionData
  end


--------------------------------------------------------------------------------


local Spritesheet = Class("Spritesheet")


  function Spritesheet:initialize(startPath)
    -- Set the start path
    self.startPath = startPath
    -- Set the accepted files.
    self.accept = {".png",".jpg"}
    -- Set the writer
    self.writer = Writer:new()
    -- Set the positionData var
    self.positionData = {}

    self.run(self)
  end


  function Spritesheet:addAccept(fileType)
    if fileType[1] ~= "." then fileType = "."..fileType end
    self.accept[#self.accept+1] = fileType
  end


    --[[

    1. Breadth first directory iteration.
    2. Add each directroy contents to row of spritesheet.
    3. Store contents in the positionData table.

    ]]

  function Spritesheet:run()
    self.breadthFirstRun(self,self.startPath)
  end


  function Spritesheet:breadthFirstRun(path,directoryName)

    -- Get the directory items.
    local directoryItems = love.filesystem.getDirectoryItems(path)


    if #directoryItems == 0 then  --Base case
      return
    else
      directoryItems = self.orderDirectory(self,directoryItems)

      -- Iterate over all the files in the directory, using split.
      self.writer:setRowName(directoryName)
      for count = 1, directoryItems.split-1 ,1 do
        local tempPath = (path.."/"..tostring(directoryItems[count]))
        self.writer:clipboardAdd(tempPath)
      end
      self.writer:paste()

      -- Iterate over all the directories in the directory, using split.
      for count = directoryItems.split, #directoryItems, 1 do
        self.breadthFirstRun(self,path.."/"..directoryItems[count],directoryItems[count])
      end
    end
  end


  -- Brings file to the front.
  -- .split refers to first index containing a directory.
  function Spritesheet:orderDirectory(directoryItems)
    local orderedItems = {}
    local fileNumber = 0
    for i =1, #directoryItems,1 do
      item = directoryItems[i]
      if self.isImageFile(self,item) then
        table.insert(orderedItems,1,item)
        fileNumber = fileNumber + 1
      elseif self.isDirectory(self,item) then
        table.insert(orderedItems,item)
      end
    end
    orderedItems.split = fileNumber + 1
    return orderedItems
  end




  function Spritesheet:isImageFile(file)
    for i = 1,#self.accept,1 do
      fileType  = self.accept[i]
      if string.match(file,fileType) then
        return true
      end
      return false
    end
  end

  function Spritesheet:isDirectory(dir)
    if string.match(dir,".") == "." then
      return false
    end
    return true
  end


  function Spritesheet:getPositionData()
    return self.writer:getPositionData()
  end

  function Spritesheet:getSheet()
    return self.writer:getCanvas()
  end



  function printtable(t)
    local r = "printtable:"
    for i = 1,#t,1 do
      r=r..t[i]..","
    end
    print(r)
  end

return Spritesheet
