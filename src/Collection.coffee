class crema.Collection extends crema.EventMachine
    constructor: ( array = [] ) ->
        
        @count = array.length
        @items = array
    
        
    indexOf: ( item ) ->
        @items.indexOf( item )
    
        
    contains: ( item ) ->
        !!!@indexOf( item )
    
        
    add: ( item ) ->
        @items.push( item )
        @_updateRange()
        @
    

    addRange: ( items ) ->
        for item in items
            @items.push( item )
        @_updateRange()
        @
    

    insert: ( item, index ) ->
        @items.splice( index, 0, item )
        @_updateRange()
        @
    

    insertRange: ( items, index ) ->
        Function.prototype.apply.apply( @items.splice, [@items, [index, 0].concat(items)] )
        @_updateRange()
        @
    

    remove: ( item ) ->
        index = @indexOf(item)
        @_removeAt( index )
        @
    

    removeAt: ( index ) ->
        @_removeAt( index )
        @
    

    removeRange: ( from, to ) ->
        @_removeRange( from, to )
        @
    
        
    _removeRange: ( from, to ) ->
        # http://ejohn.org/blog/javascript-array-remove/ (comments)
        @items.splice( from, !to || 1 + to - from + (!(to < 0 ^ from >= 0) && (to < 0 || -1) * @items.length) );
        @_updateRange()
    
    
    _removeAt: ( index ) ->
        @_removeRange( index, index )

    _updateRange: ->
        @count = @items.length
    

    set: ( index, value ) ->
        try
            @items[ index ] = value
            return true
        catch err
            console.log( err )
            return false
    

    get: ( index ) ->
        @items[index]
    
