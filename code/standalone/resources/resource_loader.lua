function load_resources()
    --Setup code.
    love.graphics.appropriateImage = function(restOfPath,config) return love.graphics.newImage("assets/"..assetSize.."/"..restOfPath,config) end
    local lgn = function(path,config) return love.graphics.appropriateImage(path,config) end

    currentSheetSize = {x=0,y=0}
    lgq = function(x,y,w,h) return love.graphics.newQuad(x,y,w,h,currentSheetSize.x,currentSheetSize.y) end

    local f = ""

    --LOAD ALL OF THE REEEEALLLY GLBOAL STUFF HERE------------------------------
    ----------------------------------------------------------------------------

    --Load the fonts
    fonts = {}
    local fontPath = "assets/Fonts/BaksoSapi.otf"
    fonts.debug = love.graphics.newFont(30)
    local scalar = 1
    if assetSize == "small" then scalar = 0.5 end
    fonts.xsmall = love.graphics.newFont(fontPath,30*scalar)
    fonts.small = love.graphics.newFont(fontPath,45*scalar)
    fonts.medium = love.graphics.newFont(fontPath,65*scalar)
    fonts.large = love.graphics.newFont(fontPath,100*scalar)
    fonts.xlarge = love.graphics.newFont(fontPath,150*scalar)

      --The keys
      f = "UI/Keys/Alphabet/Keyboard_White_"
      local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      keyImages = {}
      for i=1,alphabet:len(),1 do
          local letter = alphabet:sub(i,i)
          keyImages[letter:lower()] = lgn(f..letter..".png")
      end



end load_resources()
