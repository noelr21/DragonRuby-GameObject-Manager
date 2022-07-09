class Component
    attr_accessor :name, :gameObject
    def initialize (name, gameObject)
        @name = name
        @gameObject = gameObject
        @args
    end
    def start args
        puts "Successfully loaded #{@name} component from #{@gameObject.name}"
    end
    def tick args
    end
    def updateArgs args

    end
    #TODO create method to validate an object is a component
    def self.validate testClass
        tests = Array.new
        #add respond_to to all methods of the Component super class
        tests.push(testClass.respond_to?(:main))
        #check if any of the tests are false
        tests.each do |test|
            if !test
                false
            end
        end
        true
    end
end