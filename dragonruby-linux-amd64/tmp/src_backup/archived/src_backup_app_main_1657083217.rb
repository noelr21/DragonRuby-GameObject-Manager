require 'app/game_object.rb'
require 'app/components/component.rb'
require 'app/components/rendered_component.rb'
require 'app/components/solid.rb'
def tick args
    if !args.state.init
        args.state.init ||= true
        args.state.gameObjects ||= []
        args.state.gameObjects.push new GameObject("Black Square")
        args.state.gameObjects[0].addComponent new Solid("Black Square", args.state.gameObjects[0], 10, 10, {r: 0, g: 0, b: 0, a: 255})
        args.state.gameObjects.each do |gameObject|
            gameObject.processStart args
        end
    end
    args.state.gameObjects.each do |gameObject|
        gameObject.processTick args
    end
end
