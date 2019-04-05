function load_shaders()
    shaders = {}

    --Grayscale
    shaders.grayscale = love.graphics.newShader[[
        extern number factor;
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
          vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
          if(factor > 0){
              number average = (pixel.r+pixel.b+pixel.g)/3.0;
              pixel.r = pixel.r + (average-pixel.r) * factor;
              pixel.g = pixel.g + (average-pixel.g) * factor;
              pixel.b = pixel.b + (average-pixel.b) * factor;
          }
          return pixel * color;
        }
    ]]
        --love.graphics.setShader(shaders.grayscale)
        --love.graphics.setShader(shaders.blur)
        --shaders.grayscale:send("factor",self.calculateShaderLevel(self))
    --[[
        extern number factor is to be incremented outside GLSL and passed every frame. Allows grayscale to be
        gradually introduced.
    ]]
    shaders.distortion = {}
    shaders.distortion.shader = love.graphics.newShader([[
    	extern number time;
    	extern number size;
    	vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
    	{
    		vec2 p = tc;
    		p.x = p.x + sin(p.y * size * (time*2)) * 0.03;
    		return Texel(tex, p);
    	}
    ]]) shaders.distortion.shader:send("size",1)
    shaders.distortion.time = 0

    shaders.blur = Moonshine(Moonshine.effects.gaussianblur)
    shaders.blur.gaussianblur.sigma = 5
end load_shaders()
