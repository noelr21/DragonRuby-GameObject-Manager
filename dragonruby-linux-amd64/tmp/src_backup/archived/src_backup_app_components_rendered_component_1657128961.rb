class RenderedComponent < Component  
    def initialize (name, gameObject)
        self.name = name
        self.gameObject = gameObject
    end

    def primitive_marker 
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