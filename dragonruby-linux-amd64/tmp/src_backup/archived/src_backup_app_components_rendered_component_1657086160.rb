class RenderedComponent < Component  
    def initialize (name, gameObject, primitiveType = :solid)
        self.name = name
        self.gameObject = gameObject
        @primitiveType = primitiveType
    end

    def primitive_marker 
        @primitiveType
    end
end