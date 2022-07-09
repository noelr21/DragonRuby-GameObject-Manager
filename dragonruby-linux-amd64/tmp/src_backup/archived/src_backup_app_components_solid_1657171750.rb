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
        @cornerPositions = {topLeft: {x: @x, y: @y + @h}, topRight: {x: @x + @w, y: @y + @h}, bottomRight: {x: @x + @w, y: @y}, bottomLeft: {x: @x, y: @y}}
        #indicator size same x and y
        @indicatorSize = 10
        #used to know if the drag has begun
        @dragStarted = false
        #the position of the mouse when the drag begun
        @selectedCorner = nil
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
        if (args.inputs.mouse.inside_circle?(@cornerPositions[:topLeft], radius))
            @cornersHovered[:topLeft] = true
            output.push [centerOnPoint(@cornerPositions[:topLeft][:x], @indicatorSize), centerOnPoint(@cornerPositions[:topLeft][:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        else
            @cornersHovered[:topLeft] = false
        end
        if (args.inputs.mouse.inside_circle?(@cornerPositions[:topRight], radius))
            @cornersHovered[:topRight] = true
            output.push [centerOnPoint(@cornerPositions[:topRight][:x], @indicatorSize), centerOnPoint(@cornerPositions[:topRight][:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        else
            @cornersHovered[:topRight] = false
        end
        if (args.inputs.mouse.inside_circle?(@cornerPositions[:bottomRight], radius))
            @cornersHovered[:bottomRight] = true
            output.push [centerOnPoint(@cornerPositions[:bottomRight][:x], @indicatorSize), centerOnPoint(@cornerPositions[:bottomRight][:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        else
            @cornersHovered[:bottomRight] = false
        end
        if (args.inputs.mouse.inside_circle?(@cornerPositions[:bottomLeft], radius))
            @cornersHovered[:bottomLeft] = true
            output.push [centerOnPoint(@cornerPositions[:bottomLeft][:x], @indicatorSize), centerOnPoint(@cornerPositions[:bottomLeft][:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
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
            output.push [centerOnPoint(@cornerPositions[:topLeft][:x], @indicatorSize), centerOnPoint(@cornerPositions[:topLeft][:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        elsif (@cornersHovered[:topRight])
            output.push [centerOnPoint(@cornerPositions[:topRight][:x], @indicatorSize), centerOnPoint(@cornerPositions[:topRight][:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        elsif (@cornersHovered[:bottomRight])
            output.push [centerOnPoint(@cornerPositions[:bottomRight][:x], @indicatorSize), centerOnPoint(@cornerPositions[:bottomRight][:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        elsif (@cornersHovered[:bottomLeft])
            output.push [centerOnPoint(@cornerPositions[:bottomLeft][:x], @indicatorSize), centerOnPoint(@cornerPositions[:bottomLeft][:y], @indicatorSize), @indicatorSize, @indicatorSize, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        end
    end

    def tick args
        updateCornerPositions()
        #Check if any corners are hovered over
        cornerIndicators = checkCornerHovered args
        #Check if any corners have been clicked on and if so begin the drag
        if (@cornersHovered[:isAny].call(@cornersHovered))
            if (args.inputs.mouse.button_left)
                cornerIndicators.push onCornerClicked
                #Record the position of the mouse on the first frame the mouse is clicked and increase/decrease the size of the square based on this
                if (!@dragStarted)
                    @dragStarted = true
                    if (@cornersHovered[:topLeft])
                        @selectedCorner = :topLeft
                    elsif (@cornersHovered[:topRight])
                        @selectedCorner = :topRight
                    elsif (@cornersHovered[:bottomRight])
                        @selectedCorner = :bottomRight
                    elsif (@cornersHovered[:bottomLeft])
                        @selectedCorner = :bottomLeft
                    end
                end
            end
        end
        if (args.inputs.mouse.button_left)
            if (@dragStarted)
                cornerPos = @cornerPositions[@selectedCorner]
                xDistance = args.inputs.mouse.x - cornerPos[:x]
                yDistance = args.inputs.mouse.y - cornerPos[:y]
                case @selectedCorner
                    when :topLeft
                        #X: move on the x axis and change size
                        @x = args.inputs.mouse.x
                        if (xDistance < 0)
                            #if negative move left and get bigger
                            @w = @w + xDistance.abs
                        else
                            #if positive move right and get smaller
                            @w = @w - xDistance
                        end
                        #Y: only change size
                        @h = @h + yDistance
                    when :topRight
                        #X && Y: only change size
                        @w = @w + xDistance
                        @h = @h + yDistance
                    when :bottomRight
                        #X: only change size
                        @w = @w + xDistance
                        #Y: change y pos and change size
                        @y = args.inputs.mouse.y
                        if (yDistance < 0)
                            @h = @h + yDistance.abs
                        else
                            @h = @h - yDistance
                        end
                    when :bottomLeft
                        #X & Y: Change pos and size
                        @x = args.inputs.mouse.x
                        if (xDistance < 0)
                            @w = @w + xDistance.abs
                        else
                            @w = @w - xDistance
                        end
                        @y = args.inputs.mouse.y
                        if (yDistance < 0)
                            @h = @h + yDistance.abs
                        else
                            @h = @h - yDistance
                        end
                    else
                        puts "@selectCorner invalid doing nothing in #{@name} component"
                end
                args.outputs.labels << [50, 700, "width: #{xDistance}", 0, 0, 0, 255]
                args.outputs.labels << [50, 600, "height: #{yDistance}", 0, 0, 0, 255]
                # cornerIndicators.push [@startCornerPos[:x], @startCornerPos[:y], width, height, 0, 255, 0, 255]
            end
        else
            @dragStarted = false
        end
        args.outputs.solids << self
        cornerIndicators.each do |cornerIndicator|
            args.outputs.solids << cornerIndicator
        end
    end

    def updateCornerPositions 
        @cornerPositions[:topLeft] = {x: @x, y: @y + @h} 
        @cornerPositions[:topRight] = {x: @x + @w, y: @y + @h}
        @cornerPositions[:bottomRight] = {x: @x + @w, y: @y}
        @cornerPositions[:bottomLeft] = {x: @x, y: @y}

    end
end

def centerOnPoint(point, size)
    return point - (size / 2)
end

