class crema.Module extends crema.EventMachine
    constructor: ( options = {} ) ->
        super()
        @children = new crema.Collection()
        @parent = null
        
        options.parent?.add( @ )
        if options.children?
            for child in options.children 
                @add( child )
    

    add: ( module ) ->
        
        if _.isModule( module )
            unless _.contains( @children, module ) and module.parent?
                @children.add( module )
                module.parent = @
                module.fireEvent( "gotAdded" )
                @fireEvent( "add", [ module ] )
        
        return @
    

    remove: ( module ) ->

        if _.isModule( module ) and module.parent is @controller
            @children.remove( module )
            module.parent = null
            module.fireEvent( "gotRemoved" )
            @fireEvent( "remove", [ module ] )
            
        return @
    
        
    dispose: ->
        for child in @children
            child.parent = null
        
        @parent?.remove( @ )
        return null
    

