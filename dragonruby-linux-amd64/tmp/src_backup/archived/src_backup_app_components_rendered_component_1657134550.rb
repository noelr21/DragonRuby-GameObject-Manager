class RenderedComponent < Component  
    def initialize (name, gameObject, primitiveType = :solid, blendModeEnum = 0)
        @name = name
        @gameObject = gameObject
        @primitiveType = primitiveType
    end

    def primitive_marker
        @primitiveType
    end

    def 

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