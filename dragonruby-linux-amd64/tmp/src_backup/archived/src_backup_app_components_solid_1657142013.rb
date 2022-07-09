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
        @isCornerHovered = {topLeft: false, topRight: false, bottomRight: false, bottomLeft: false} #TODO: think of using a bitmask or array for this instead of hash
    end

    def serialize
        {x: @x, y: @y, w: @w, h: @h, r: @r, g: @g, b: @b, a: @a}
    end
    
    def start args
    end

    def tick args
        checkCornerHovered 
        args.outputs.solids << self
    end

    def checkCornerHovered
        topLeftPos = {x: @x - @w/2, y: @y + @h/2}
        topRightPos = {x: @x + @w/2, y: @y + @h/2}
        if (args.inputs.mouse.inside_circle? )
    end
end