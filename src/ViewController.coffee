class crema.ViewController extends crema.Module
    constructor: ( options = {} ) ->
        super()
        
        {
            @isShown
        } = options
        
        
        @isShown ?= true
        
        @view = new crema.View( @ )
    
    
    _commandChecker: ( type, bind ) ->
        if bind
            actionName = "bound"
            methodName = "bind"
        else
            actionName = "unbound"
            methodName = "unbind"

        if type.split( "." )[ 0 ] is "command"
            throw new Error( "'command' events cannot be #{actionName} via #{methodName}Event.\nUse #{methodName}Command instead." )
    

    bindEvent: ( type, data, fn, once = false, isInternal = false ) ->
        unless isInternal is true
            if typeof type is "object"
                for key, value of type
                    @_commandChecker( key, true )
            else
                @_commandChecker( type, true )

        super( type, data, fn, once )

        return @
    

    unbindEvent: ( type, fn, isInternal = false ) ->
        unless isInternal is true
            if typeof type is "object"
                for key, value of type
                    @_commandChecker( key, false )

            else
                @_commandChecker( type, false )

        super( type, fn, true )

        return @
    

    sendCommand: ( command, data) ->
        @fireEvent( "command.#{command}", data )

        return @
    

    bindCommand: ( command, data, fn, once = false ) ->
        if typeof command is "object"
            for key, value of command
                @bindCommand( key, data, value, once )

            return @

        if _.isFunction( data )
            fn = data
            data = undefined

        @bindEvent( "command.#{command}", data, fn, once, true )

        return @
    

    unbindCommand: ( command, fn ) ->
        if typeof command is "object"
            for key, value of command
                @unbindCommand( key, value )

            return @

        @unbindEvent( "command.#{command}", fn, true )

        return @
    

    add: ( obj ) ->
        super( obj )
        @view.add( obj.view )
        return @
    

    remove: ( obj ) ->
        super( obj )
        @view.remove( obj.view )
        return @
    
    
    updateUI: ->
        @view.update()
        for child, i in @children.items
            child.updateUI()

        return @
    
    
    dispose: ->
        super()
        @view.dispose()
        @fireEvent( "dispose" )
        return null
    
