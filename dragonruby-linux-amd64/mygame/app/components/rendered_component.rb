class RenderedComponent < Component 
    attr_accessor :blendmode_enum
    def initialize (name, gameObject, primitiveType = :solid, blendModeEnum = 0)
        @name = name
        @gameObject = gameObject
        @primitiveType = primitiveType
        @blendmode_enum = blendModeEnum
    end

    def primitive_marker
        @primitiveType
    end 

    def serialize
        {name: @name, gameObject: @gameObject, primitiveType: @primitiveType}
    end

    def inspect
        "#{serialize}"
    end

    def to_s
        "#{serialize}"
    end
end