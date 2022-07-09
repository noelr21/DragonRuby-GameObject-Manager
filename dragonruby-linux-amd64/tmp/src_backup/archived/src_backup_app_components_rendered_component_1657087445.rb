class RenderedComponent < Component  
    def initialize (name, gameObject, primitiveType = :solid)
        self.name = name
        self.gameObject = gameObject
        @primitiveType = primitiveType
    end

    def primitive_marker 
        @primitiveType
    end

    def serialize
    end

    def inspect
        "#{serialize}"
    end

    def to_s
        "#{serialize}"
    end
end