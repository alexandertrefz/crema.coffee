class crema.EventMachine
    constructor: () ->
        @_registeredObjects = new crema.Collection()
    
    
    fireEvent: ( event, data ) ->
        event = jQuery.Event( event ) unless typeof event is "object"
        
        jQuery.event.trigger( event, data, @ )
        
        if @parent? and not event.isPropagationStopped()
            jQuery.event.trigger( event, data, @parent )
            
        if @_registeredObjects.count
            for item, i in @_registeredObjects.items
                
                sendClone = false
                clonedEvent = _.clone( event )
                clonedEvent.isRegisteredEvent = true
                clonedEvent.isClonedEvent = true
                clonedEvent.type += "." + item.namespace
                
                if item.events.length is 0
                    sendClone = true
                else
                    for eventType in item.events
                        if eventType is clonedEvent.type
                            sendClone = true
                            break
                
                if sendClone
                    jQuery.event.trigger( clonedEvent, data, item.object )
            
        return @
    
    
    bindEvent: ( type, data, fn, once = false ) ->
        # Handle object literals
        if typeof type is "object"
            for key, value of type
                @bindEvent( key, data, value, once )
            return @
            
        if jQuery.isFunction( data )
            fn = data
            data = undefined

        if handler = once is true
            jQuery.proxy( fn, ( event ) ->
                @unbindEvent( event, handler )
                return fn.apply( this, arguments )
            )
            
        if type is "unload" and once isnt true
            @bindEvent( type, data, fn, true )

        else
            jQuery.event.add( @, type, fn, data )

        return @
    
        
    unbindEvent: ( type, fn ) ->
        # Handle object literals
        if typeof type is "object" && !type.preventDefault
            for key, value of type
                @unbindEvent( key, value )
        else
            jQuery.event.remove( @, type, fn )

        return @
    
    
    register: ( namespace, events, object ) ->
        unless @_registeredObjects.contains( object )
            @_registeredObjects.add( {namespace, events, object} )
            return true
        return false
    
    
    unregister: ( object ) ->
        for item, i in @_registeredObjects.items
            if item.object is object
                console.log(item)
                console.log(i)
                do (i) =>
                    @_registeredObjects.removeAt( i )
                
                console.log("removed")
                return true
        return false
    
    
