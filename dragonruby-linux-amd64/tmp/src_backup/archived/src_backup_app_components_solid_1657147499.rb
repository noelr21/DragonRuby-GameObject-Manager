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
        @isCornerHovered = {topLeft: false, topRight: false, bottomRight: false, bottomLeft: false} 
    end

    def serialize
        {x: @x, y: @y, w: @w, h: @h, r: @r, g: @g, b: @b, a: @a}
    end
    
    def start args
        puts x: @x - @w/2, y: @y + @h/2}
    end

    def checkCornerHovered args
        output = Array.new
        topLeftPos = {x: @x - @w/2, y: @y + @h/2}
        topRightPos = {x: @x + @w/2, y: @y + @h/2}
        bottomRightPos = {x: @x + @w/2, y: @y - @h/2}
        bottomLeftPos = {x: @x - @w/2, y: @y - @h/2}
        radius = 5
        if (args.inputs.mouse.inside_circle?(topLeftPos, radius))
            output.push [centerOnPoint(topLeftPos[:x], 10), centerOnPoint(topLeftPos[:y], 10), 10, 10, 255, 0, 0, 255]
        end
        # output.push [centerOnPoint(topLeftPos[:x], 10), centerOnPoint(topLeftPos[:y], 10) , 10, 10, 255, 0, 0, 255]
        output.push [topLeftPos[:x], topLeftPos[:y], 10, 10, 255, 0, 0, 255]
        if (args.inputs.mouse.inside_circle?(topRightPos, radius))
            output.push [centerOnPoint(topRightPos[:x], 10), centerOnPoint(topRightPos[:y], 10), 10, 10, 255, 0, 0, 255]
        end
        if (args.inputs.mouse.inside_circle?(bottomRightPos, radius))
            output.push [centerOnPoint(bottomRightPos[:x], 10), centerOnPoint(bottomRightPos[:y], 10), 10, 10, 255, 0, 0, 255]
        end
        if (args.inputs.mouse.inside_circle?(bottomLeftPos, radius))
            output.push [centerOnPoint(bottomLeftPos[:x], 10), centerOnPoint(bottomLeftPos[:y], 10), 10, 10, 255, 0, 0, 255]
        end
        return output
    end

    def tick args
        cornerIndicators = checkCornerHovered args
        args.outputs.solids << self
        cornerIndicators.each do |cornerIndicator|
            args.outputs.solids << cornerIndicator
        end
    end
end

def centerOnPoint(point, size)
    return point - (size / 2)
end