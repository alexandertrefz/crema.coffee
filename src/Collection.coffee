class crema.Collection extends crema.EventMachine
    constructor: ( array = [], cleanUpItems = false ) ->
        
        array = _.without(array, undefined) if cleanUpItems
        
        @items = array
        @_updateRange()
    
    
    indexOf: ( item ) ->
        @items.indexOf( item )
    
    
    contains: ( item ) ->
        !!~@indexOf( item )
    
    
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
        Array::splice.apply( @items, [index, 0].concat(items) )
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
    
    
    _calculateSpliceIndex: ( from, to ) ->
        !to || 1 + to - from + (!(to < 0 ^ from >= 0) && (to < 0 || -1) * @items.length)
    
    
    _calculateIndex: ( index ) ->
        if index is 0
            index
        else
            @_calculateSpliceIndex( 1, index )
    
    
    _removeRange: ( from, to ) ->
        # http://ejohn.org/blog/javascript-array-remove/ (comments)
        @items.splice( from, @_calculateSpliceIndex(from, to) );
        @_updateRange()
    
    
    _removeAt: ( index ) ->
        @_removeRange( index, index )
    
    
    _updateRange: ->
        @count = @items.length
    
    
    set: ( index, value ) ->
        try
            if index >= @count
                throw new Error("Index is out of range.")
                
            @items[ @_calculateIndex( index ) ] = value
            return true
        catch err
            console.log( err )
            return false
    

    get: ( index ) ->
        @items[ @_calculateIndex( index ) ]
    
