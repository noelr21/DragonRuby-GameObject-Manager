class Solid < RenderedComponent
    attr_accessor :x, :y, :w, :h, :r, :g, :b, :a
    def initialize (name, gameObject, width = 10, height = 10, color = {r: 255, g: 255, b: 255, a: 255}, coords = {x: 0, y: 0})
        super(name, gameObject)
        @x = coords[:x]
        @y = coords[:y]
        @w = width
        @h = height
        @r = color[:r]
        @g = color[:g]
        @b = color[:b]
        @a = color.fetch(:a) {255}
        isAny = lambda do |hash|
            return hash[:topLeft] || hash[:topRight] || hash[:bottomRight] || hash[:bottomLeft]
        end
        @cornersHovered = {topLeft: false, topRight: false, bottomRight: false, bottomLeft: false, isAny: isAny}
        #positions of corners of squares
        @topLeftPos = {x: @x, y: @y + @h}
        @topRightPos = {x: @x + @w, y: @y + @h}
        @bottomRightPos = {x: @x + @w, y: @y}
        @bottomLeftPos = {x: @x, y: @y}
        #indicator size same x and y
        @indicatorSize = 10
        #used to know if the drag has begun
        @dragStarted = false
        #the position of the mouse when the drag begun
        @startCornerPos = nil
    end

    def serialize
        {x: @x, y: @y, w: @w, h: @h, r: @r, g: @g, b: @b, a: @a}
    end
    
    def start args
    end

    def checkCornerHovered args
        output = Array.new #array to store all indicator primitives
        #corner hitbox radius
        radius = 10
        #color of indicators 
        indicatorColor = {r: 255, g: 0, b: 0, a: 255/2}
        if (args.inputs.mouse.inside_circle?(@topLeftPos, radius))
            @cornersHovered[:topLeft] = true
            output.push [centerOnPoint(@topLeftPos[:x], @indicatorSize), centerOnPoint(@topLeftPos[:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        else
            @cornersHovered[:topLeft] = false
        end
        if (args.inputs.mouse.inside_circle?(@topRightPos, radius))
            @cornersHovered[:topRight] = true
            output.push [centerOnPoint(@topRightPos[:x], @indicatorSize), centerOnPoint(@topRightPos[:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        else
            @cornersHovered[:topRight] = false
        end
        if (args.inputs.mouse.inside_circle?(@bottomRightPos, radius))
            @cornersHovered[:bottomRight] = true
            output.push [centerOnPoint(@bottomRightPos[:x], @indicatorSize), centerOnPoint(@bottomRightPos[:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        else
            @cornersHovered[:bottomRight] = false
        end
        if (args.inputs.mouse.inside_circle?(@bottomLeftPos, radius))
            @cornersHovered[:bottomLeft] = true
            output.push [centerOnPoint(@bottomLeftPos[:x], @indicatorSize), centerOnPoint(@bottomLeftPos[:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        else
            @cornersHovered[:bottomLeft] = false
        end
        return output
    end

    def onCornerClicked
        output = Array.new #array to store all indicator primitives
        #color of indicators 
        indicatorColor = {r: 255, g: 0, b: 0, a: 255}
        if (@cornersHovered[:topLeft])
            output.push [centerOnPoint(@topLeftPos[:x], @indicatorSize), centerOnPoint(@topLeftPos[:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        elsif (@cornersHovered[:topRight])
            output.push [centerOnPoint(@topRightPos[:x], @indicatorSize), centerOnPoint(@topRightPos[:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        elsif (@cornersHovered[:bottomRight])
            output.push [centerOnPoint(@bottomRightPos[:x], @indicatorSize), centerOnPoint(@bottomRightPos[:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        elsif (@cornersHovered[:bottomLeft])
            output.push [centerOnPoint(@bottomLeftPos[:x], @indicatorSize), centerOnPoint(@bottomLeftPos[:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        end
    end

    def tick args
        #TODO: stop making a new object everyframe omega lul
        @topLeftPos = {x: @x, y: @y + @h}
        @topRightPos = {x: @x + @w, y: @y + @h}
        @bottomRightPos = {x: @x + @w, y: @y}
        @bottomLeftPos = {x: @x, y: @y}
        cornerIndicators = checkCornerHovered args
        if (@cornersHovered[:isAny].call(@cornersHovered))
            if (args.inputs.mouse.button_left)
                cornerIndicators.push onCornerClicked
                #Record the position of the mouse on the first frame the mouse is clicked and increase/decrease the size of the square based on this
                if (!@dragStarted)
                    @dragStarted = true
                    if (@cornersHovered[:topLeft])
                        @startCornerPos = @topLeftPos
                    elsif (@cornersHovered[:topRight])
                        @startCornerPos = @topRightPos
                    elsif (@cornersHovered[:bottomRight])
                        @startCornerPos = @bottomLeftPos
                    elsif(@cornersHovered[:bottomLeft])
                        @startCornerPos = @bottomRightPos
                    end
                end
            end
        end
        if (args.inputs.mouse.button_left)
            if (@dragStarted)
                #check current mouse position against startMousePos and calculate new square size
                #cmp.x - smp.x = xDistance
                #cmp.y - smp.y = yDistance
                #width + xDistance = newWidth
                #height + yDistance = newHeight
                moveSpeed = 0.5
                xDistance = args.inputs.mouse.x  @startCornerPos[:x]
                yDistance = args.inputs.mouse.y  @startCornerPos[:y]
                @w = @w + xDistance * moveSpeed
                @h = @h + yDistance * moveSpeed
            end
        else
            @dragStarted = false
        end
        args.outputs.solids << self
        cornerIndicators.each do |cornerIndicator|
            args.outputs.solids << cornerIndicator
        end
    end
end

def centerOnPoint(point, size)
    return point - (size / 2)
end

