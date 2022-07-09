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
    end

    def checkCornerHovered args
        output = Array.new
        topLeftPos = {x: @x - @w/2, y: @y + @h/2}
        topRightPos = {x: @x + @w/2, y: @y + @h/2}
        bottomRightPos = {x: @x + @w/2, y: @y - @h/2}
        bottomLeftPos = {x: @x - @w/2, y: @y - @h/2}
        radius = 5
        if (args.inputs.mouse.inside_circle?(topLeftPos, radius))
            args.outputs.solids << [centerOnPoint(topLeftPos[:x], 10), centerOnPoint(topLeftPos[:y], 10), 10, 10, 255, 0, 0, 255]
        end
        # args.outputs.solids << [centerOnPoint(topLeftPos[:x], 10), centerOnPoint(topLeftPos[:y], 10), 10, 10, 255, 0, 0, 255]
        args.outputs.solids << [topLeftPos[:x], topLeftPos[:y], 10, 10, 255, 0, 0, 255]
        if (args.inputs.mouse.inside_circle?(topRightPos, radius))
            args.outputs.solids << [centerOnPoint(topRightPos[:x], 10), centerOnPoint(topRightPos[:y], 10), 10, 10, 255, 0, 0, 255]
        end
        args.outputs.solids << [centerOnPoint(topRightPos[:x], 10), centerOnPoint(topRightPos[:y], 10), 10, 10, 255, 0, 0, 255]
        if (args.inputs.mouse.inside_circle?(bottomRightPos, radius))
            args.outputs.solids << [centerOnPoint(bottomRightPos[:x], 10), centerOnPoint(bottomRightPos[:y], 10), 10, 10, 255, 0, 0, 255]
        end
        args.outputs.solids << [centerOnPoint(bottomRightPos[:x], 10), centerOnPoint(bottomRightPos[:y], 10), 10, 10, 255, 0, 0, 255]
        if (args.inputs.mouse.inside_circle?(bottomLeftPos, radius))
            args.outputs.solids << [centerOnPoint(bottomLeftPos[:x], 10), centerOnPoint(bottomLeftPos[:y], 10), 10, 10, 255, 0, 0, 255]
        end
        args.outputs.solids << [centerOnPoint(bottomLeftPos[:x], 10), centerOnPoint(bottomLeftPos[:y], 10), 10, 10, 255, 0, 0, 255]
    end

    def tick args
        checkCornerHovered args
        args.outputs.solids << self
    end
end

def centerOnPoint(point, size)
    return point - (size / 2)
end