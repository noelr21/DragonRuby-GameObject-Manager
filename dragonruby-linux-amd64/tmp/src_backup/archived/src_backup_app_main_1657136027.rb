require 'app/game_object.rb'
require 'app/components/component.rb'
require 'app/components/rendered_component.rb'
require 'app/components/solid.rb'
def tick args
    if !args.state.init
        args.outputs.solids << [0, 0, 100, 100]
        args.state.init ||= true
        args.state.gameObjects ||= []
        args.state.gameObjects.push GameObject.new("Black Square")
        puts "Before Calling Solid constructor"
        args.state.gameObjects[0].addComponent Solid.new("Black Square", args.state.gameObjects[0], 10, 10, {r: 0, g: 0, b: 0, a: 255})
        puts "After Calling Solid constructor"
        args.state.gameObjects.each do |gameObject|
            gameObject.processStart args
        end
    end
    args.state.gameObjects.each do |gameObject|
        gameObject.processTick args
    end
end
