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
        @isCornerHovered = {topLeft: false, topRight: false, bottomRight: false, bottomLeft: false, isAny: isAny}
        @topLeftPos = {x: @x, y: @y + @h}
        @topRightPos = {x: @x + @w, y: @y + @h}
        @bottomRightPos = {x: @x + @w, y: @y}
        @bottomLeftPos = {x: @x, y: @y}
    end

    def serialize
        {x: @x, y: @y, w: @w, h: @h, r: @r, g: @g, b: @b, a: @a}
    end
    
    def start args
    end

    def checkCornerHovered args
        output = Array.new #array to store all indicator primitives
        #positions of corners
        #corner hitbox radius
        radius = 10
        #color of indicators 
        indicatorColor = {r: 255, g: 0, b: 0, a: 255/2}
        #indicator size uniform x and y
        size = 10
        if (args.inputs.mouse.inside_circle?(@topLeftPos, radius))
            @isCornerHovered[:topLeft] = true
            output.push [centerOnPoint(@topLeftPos[:x], size), centerOnPoint(@topLeftPos[:y], size), size, size, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        else
            @isCornerHovered[:topLeft] = false
        end
        if (args.inputs.mouse.inside_circle?(@topRightPos, radius))
            @isCornerHovered[:topRight] = true
            output.push [centerOnPoint(@topRightPos[:x], size), centerOnPoint(@topRightPos[:y], size), size, size, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        else
            @isCornerHovered[:topRight] = false
        end
        if (args.inputs.mouse.inside_circle?(@bottomRightPos, radius))
            @isCornerHovered[:bottomRight] = true
            output.push [centerOnPoint(@bottomRightPos[:x], size), centerOnPoint(@bottomRightPos[:y], size), size, size, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        else
            @isCornerHovered[:bottomRight] = false
        end
        if (args.inputs.mouse.inside_circle?(@bottomLeftPos, radius))
            @isCornerHovered[:bottomLeft] = true
            output.push [centerOnPoint(@bottomLeftPos[:x], size), centerOnPoint(@bottomLeftPos[:y], size), size, size, indicatorColor[:r], indicatorColor[:g], indicatorColor[:b], indicatorColor[:a]]
        else
            @isCornerHovered[:bottomLeft] = false
        end
        return output
    end

    def onCornerClicked
    end

    def tick args
        cornerIndicators = checkCornerHovered args
        if ()
        args.outputs.solids << self
        cornerIndicators.each do |cornerIndicator|
            args.outputs.solids << cornerIndicator
        end
    end
end

def centerOnPoint(point, size)
    return point - (size / 2)
end

