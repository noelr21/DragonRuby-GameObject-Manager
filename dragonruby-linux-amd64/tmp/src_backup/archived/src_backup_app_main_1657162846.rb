require 'app/game_object.rb'
require 'app/components/component.rb'
require 'app/components/rendered_component.rb'
require 'app/components/solid.rb'

def tick args
    if !args.state.init
        args.state.init ||= true
        args.state.gameObjects ||= []
        args.state.gameObjects.push GameObject.new("Black Square")
        blackSquareW = 100
        blackSquareH = 100
        args.state.gameObjects[0].addComponent Solid.new("Black Square", args.state.gameObjects[0], blackSquareW, blackSquareH, {r: 0, g: 0, b: 0, a: 255}, {x: centerOnPoint(args.grid.w / 2, blackSquareW), y: centerOnPoint(args.grid.h / 2, blackSquareH)})
        args.state.gameObjects.each do |gameObject|
            gameObject.processStart args
        end
    end
    args.state.gameObjects.each do |gameObject|
        gameObject.processTick args
    end
    args.outputs.labels << [100, 500, "Hello World", 0, 0, 0, 255]
end

def centerOnPoint(point, size)
    return point - (size / 2)
end