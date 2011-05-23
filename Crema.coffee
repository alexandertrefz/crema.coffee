###
 * Crema JavaScript Application Library v0.0.5pre
 * coming soon: http://alexandertrefz.de/projects/crema
 *
 * Copyright (c) 2011, Alexander Trefz
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 ###
 
# ================
# = Dependencies =
# ================
# - jQuery 1.5+
# - underscore 1.1+

# ==========================
# = Core Coding Guidelines =
# ==========================

# ===========
# = Spacing =
# ===========
# [] / {}
# [value, value] / {key: value} 
# BUT: {
#   key: value
#   key: value   
# }
# AND: [
#   value 
#   value
#   value
# ]
# method()
# method( parameter )
# method( methode(parameter, parameter) )
# variable = ( parameter ) ->
# if an Object or an Array are the first or the last parameter, the space between the literal and the brackets are omitted:
# method({
#   key: value
#   key: value    
# })
#
# ============
# = Keywords =
# ============
# `if not` should be `unless`
# Array and Object Literals should be used every time instead of omit or new Array/new Object
# and/or/is/isnt should be favored over &&/||/==/!=
# return should be explicitly used:
# return @
# instead of:
# @
# also, return should be always prefixed by an complete empty line  
#
# ============
# = Comments =
# ============
# Comments should always be on top of the Line they explain
# # if statement
# if true
# Comments should be always `#` to remove them automatically before deployment
# Exceptions:
# - License
# - Credits for Original Authors of fixes
# - Blog Entries that describe fixes / bugs
#
# ===========
# = Strings =
# ===========
# always use "" instead of ''
#
# ==========
# = Naming =
# ==========
# functions/methods and variables/properties should use camelCase:
# myPrettyNiftyFunction
# 
# classes should use PascalCase:
# MyPrettyNiftyClass
# 
# internal functions/methods and variables/properties should be prefixed with a single underscore: 
# _myPrettyNiftyInternalFunction
# 
# for real private Variables use the Closure around Modules - but attention,
# this might get depreciated, because private Variables can not be derivated

# ======================
# = General Guidelines =
# ======================
# all "Util"-Methods should be attached to "_" which is created by underscore.coffee
# use @property instead of @.property/this.property
# 


# ==========================================
# = Add Core-Utils to Underscore Namespace =
# ==========================================

# Ducktype checking for Objects
_.ducktype = ( obj, methods ) ->
    unless _.isArray( methods )
        methods = [methods]
        
    for method in methods
        unless obj?[method]?
            return false
            
    return true


# Shortcuts or often used type Checks
_.isEventMachine = ( obj ) ->
    return _.ducktype( obj, ["fireEvent", "bindEvent", "unbindEvent"] )


_.isModule = ( obj ) ->
    return _.isEventMachine( obj ) and _.ducktype( obj, ["add", "remove"] )


_.isViewController = ( obj ) ->
    return _.isModule( obj ) and _.ducktype( obj, ["bindCommand", "unbindCommand", "sendCommand", "updateUI"] )


_.isView = ( obj ) ->
    return _.isModule( obj ) and _.ducktype( obj, ["update", "dispose"] )

 
# ====================
# = Initialize crema =
# ====================
crema = {
    version: "0.0.5pre"
    views: {}
    controllers: {}
    viewControllers: {}
}


# ======================
# = EventMachine Class =
# ======================
class crema.EventMachine
    fireEvent: ( event, data ) ->
        event = jQuery.Event( event ) unless typeof event is "object"
        
        jQuery.event.trigger( event, data, @ )
        
        if @parent? and not event.isPropagationStopped()
            jQuery.event.trigger( event, data, @parent )
            
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
    


# ================
# = Module Class =
# ================
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
    


# ==============
# = View-Class =
# ==============
class crema.View extends crema.Module
    constructor: ( @controller, options ) ->
        super()
        
        @ui = {}
        
        @ui.container = $( "<div/>" )
        
        @ui.childContainer = @ui.container
        
        @html = @ui.container
    

    add: ( view ) ->
        if _.isView( view )
            super( view )
            @ui.childContainer.append( view.html )
            
        return @
    
    
    remove: ( view ) ->
        if _.isView( view )
            super( view )
            view.html.remove()
            
        return @
    

    update: ->
        for key, item of @ui
            item.updateUI?()
        
        return @
    

    dispose: ->
        @html.remove()
    


# ========================
# = ViewController Class =
# ========================
class crema.ViewController extends crema.Module
    constructor: ( options = {} ) ->
        super()
        
        {
            @isShown
        } = options
        
        
        @isShown ?= true
        
        @view = new crema.View( @ )
    

    _initChildren: ( elements ) ->
        refs = 0
        for element in elements
            for item in element.data
                refs++
                do(item) =>
                    
                    @_callAsync( =>
                        element.handler( item )
                        refs--
                    )
                    
                
            
        
        
        check = setInterval( =>
            if refs is 0
                @fireEvent( "childrenInitialized" )
                clearInterval( check )
        , 10)
        
        
        return undefined
    

    _callAsync: ( func ) ->
        setTimeout( func, 0 )
    

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
    
    
# ==============
# = Collection =
# ==============
class crema.Collection extends crema.EventMachine
    constructor: ( array = [] ) ->
        
        @count = array.length
        @items = array
    
        
    indexOf: ( item ) ->
        @items.indexOf( item )
        @
    
        
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
    



    


# =============================
# = Publish/Subscribe Pattern =
# =============================
( ->
    eventController = new Crema.EventMachine()
    
    Crema.publish = eventController.fireEvent
    Crema.subscribe = eventController.bindEvent
    Crema.unsubscribe = eventController.unbindEvent

)()



