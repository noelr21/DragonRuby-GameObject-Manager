#GameObject class
class GameObject
    ###
    ### Defining setters and getters
    ###
    # components array of components attached to the GameObject
    def components
        @components
    end
    def components= components
        @components = components
    end
    # The name of the game object with no setter
    def name
        @name
    end
    ###
    ### End Section
    ##

    def serialize
        {name: @name, components: @components}
    end

    def inspect
        "#{serialize}"
    end

    def to_s
        "#{serialize}"
    end

    def initialize (name = "GameObject", components = Array.new)
        @name = name
        @components = components
    end
    def processStart
        @components.each do |component|
            component.start args
        end
    end
    def processTick
        #run component tick functions
        @components.each do |component|
            component.tick args
        end
    end
    def addComponent newComponent
        if !Component.validate newComponent
            return
        end
        @components.push newComponent
    end
    def removeComponent componentName
        #Remove the component with componentName
        removedComponent = @components.reject { |component| component.name != componentName }
        #TODO remove this debug puts
        puts removedComponent
        if !removedComponent.empty?
            puts "Successfully removed component #{removedComponent} from GameObject: #{@name}."
        end
    end
end