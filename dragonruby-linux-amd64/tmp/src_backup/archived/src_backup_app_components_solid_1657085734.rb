class Solid < RenderedComponent
    attr_accessor :x, :y, :w, :h, :r, :g, :b, :a
    def initialize (name, gameObject, width = 10, height = 10, color = {r: 255, g: 255, b: 255, a: 255}, coords = {x: 0, y: 0})
        this.name = name
        this.gameObject = gameObject
        this.primitiveType = :solid
        @x = coords[:x]
        @y = coords[:y]
        @w = width
        @h = height
        @r = color[:r]
        @g = color[:g]
        @b = color[:b]
        @a = color.fetch(:a) {255}
    end

    def start args
        args.outputs.solid << self
    end
end