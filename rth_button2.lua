local RthButton2 = {}

function RthButton2:new(x, y, w, h, text, handler)
    local element = {
        x = x,
        y = y,
        w = w,
        h = h,
        scale = 1,
        text = text,
        fn = handler,
        isClicked = false,
        isHoover = false,
        hasFocus = false,
        color = { 1, 1, 1 },
        hooverColor = { 1, 1, 1 },
        focusColor = { 1, 1, 1 },
        imgUp = nil,
        imgDown = nil,
        quads = {},
        margin = 0,
        font = nil,
    }
    
    setmetatable(element, self)
    self.__index = self
    
    return element
end

function RthButton2:typeName()
    return "button2"
end

function RthButton2:setPosition(x, y)
    self.x = x
    self.y = y
end

function RthButton2:setSize(w, h)
    self.w = w
    self.h = h
end

function RthButton2:setScale(s)
    self.scale = s
end

function RthButton2:setFocus(f)
    self.hasFocus = f
end

function RthButton2:setColor(r, g, b)
    self.color[1] = r
    self.color[2] = g
    self.color[3] = b
end

function RthButton2:setHooverColor(r, g, b)
    self.hooverColor[1] = r
    self.hooverColor[2] = g
    self.hooverColor[3] = b
end

function RthButton2:setFocusColor(r, g, b)
    self.focusColor[1] = r
    self.focusColor[2] = g
    self.focusColor[3] = b
end

function RthButton2:setImageUp(img, margin)
    self.imgUp = img
    self.margin = margin
    local w = self.imgUp:getWidth()
    local h = self.imgUp:getHeight()
    self.quads.tl = love.graphics.newQuad(0,        0,        margin, margin, w, h)
    self.quads.tr = love.graphics.newQuad(w-margin, 0,        margin, margin, w, h)
    self.quads.bl = love.graphics.newQuad(0,        h-margin, margin, margin, w, h)
    self.quads.br = love.graphics.newQuad(w-margin, h-margin, margin, margin, w, h)
    self.quads.t  = love.graphics.newQuad(margin,   0,        1, margin,      w, h)
    self.quads.b  = love.graphics.newQuad(margin,   h-margin, 1, margin,      w, h)
    self.quads.l  = love.graphics.newQuad(0,        margin,   margin, 1,      w, h)
    self.quads.r  = love.graphics.newQuad(w-margin, margin,   margin, 1,      w, h)
    self.quads.m  = love.graphics.newQuad(margin,   margin,   1,      1,      w, h)
end

function RthButton2:setImageDown(img)
    self.imgDown = img
end

function RthButton2:setFont(f)
    self.font = f
    self.font:setFilter("nearest")
end

function RthButton2:drawButton(img, w, h)
    love.graphics.draw(img, self.quads.tl, self.x,                 self.y)
    love.graphics.draw(img, self.quads.tr, self.x + w-self.margin, self.y)
    love.graphics.draw(img, self.quads.bl, self.x,                 self.y + h-self.margin)
    love.graphics.draw(img, self.quads.br, self.x + w-self.margin, self.y + h-self.margin)
    love.graphics.draw(img, self.quads.t,  self.x + self.margin,   self.y,                 0, w-2*self.margin, 1)
    love.graphics.draw(img, self.quads.b,  self.x + self.margin,   self.y + h-self.margin, 0, w-2*self.margin, 1)
    love.graphics.draw(img, self.quads.l,  self.x,                 self.y + self.margin,   0, 1,               h-2*self.margin)
    love.graphics.draw(img, self.quads.r,  self.x + w-self.margin, self.y + self.margin,   0, 1,               h-2*self.margin)
    love.graphics.draw(img, self.quads.m,  self.x + self.margin,   self.y + self.margin,   0, w-2*self.margin, h-2*self.margin)
end

function RthButton2:draw()
    local scaledW = self.w * self.scale
    local scaledH = self.h * self.scale
    
    if self.isHoover == true then
        love.graphics.setColor(self.hooverColor[1], self.hooverColor[2], self.hooverColor[3])
    else
        love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    end
    
    if self.imgUp ~= nil and self.imgDown ~= nil then
        if self.isClicked == true then
            self:drawButton(self.imgDown, scaledW, scaledH)
        else
            self:drawButton(self.imgUp, scaledW, scaledH)
        end
    else
        if self.isHoover == true then
            love.graphics.rectangle("fill", self.x, self.y, scaledW, scaledH)
            love.graphics.setColor(0, 0, 0)
        else
            if self.hasFocus == true then
                love.graphics.setColor(self.focusColor[1], self.focusColor[2], self.focusColor[3])
                love.graphics.rectangle("line", self.x + 2, self.y + 2, scaledW - 4, scaledH - 4)
            end
            love.graphics.rectangle("line", self.x, self.y, scaledW, scaledH)
            love.graphics.setColor(self.color[1], self.color[2], self.color[3])
        end
    end
    
    local tmp = love.graphics.getFont()
    if self.font ~= nil then
        love.graphics.setFont(self.font)
    end
    local font = love.graphics.getFont()
    local textW = font:getWidth(self.text)
    local textH = font:getHeight(self.text)
    if self.isClicked == true then
        love.graphics.print(self.text, self.x + (scaledW * 0.5) - (textW * 0.5), self.y + (scaledH * 0.5) - (textH * 0.5) + 1)
    else
        love.graphics.print(self.text, self.x + (scaledW * 0.5) - (textW * 0.5), self.y + (scaledH * 0.5) - (textH * 0.5))
    end
    love.graphics.setFont(tmp)
end

function RthButton2:checkHoover(x, y)
    if x > self.x and x < self.x + (self.w*self.scale) and y > self.y and y < self.y + (self.h*self.scale) then
        self.isHoover = true
    else
        self.isHoover = false
    end
    return self.isHoover
end

function RthButton2:checkClick(x, y)
    -- print("RthButton2("..self.text.."):checkClick")
    if self.isHoover == true then
        self.isClicked = true
        if self.fn ~= nil then
            self.fn()
        end
    end
end

function RthButton2:reset()
    self.isClicked = false
end

function RthButton2:doAction()
    if self.fn ~= nil then
        self.fn()
    end
end

return RthButton2
