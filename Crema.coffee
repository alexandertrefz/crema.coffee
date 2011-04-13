###
 * Crema JavaScript Application Library v0.0.1
 * coming soon: http://alexandertrefz.de/projects/Crema
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

# =========
# = Todos =
# =========
# - UpdateUI eventbasiert(Asynchron) umsetzen um Performanceprobleme bei großen Applikationen zu vermeiden
# - 
 
# ================
# = Dependencies =
# ================
# - jQuery 1.5
# - underscore

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
# private functions/methods and variables/properties should be prefixed with a single underscore: 
# _myPrettyNiftyPrivateFunction
# 

# ======================
# = General Guidelines =
# ======================
# all "Util"-Methods should be attached to '_' which is created by underscore.coffee
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


_.isTabItem = ( obj ) ->
    return _.isViewController( obj ) and _.ducktype( obj, ["name"] )

    
# ====================
# = Initialize Crema =
# ====================
Crema = {
    Version: "0.0.1"
    Views: {}
    Controllers: {}
    ViewControllers: {}
}


# ======================
# = EventMachine Class =
# ======================
class Crema.EventMachine
    fireEvent: ( type, data ) ->
        event = jQuery.Event( type ) unless typeof event is "object"
        
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
class Crema.Module extends Crema.EventMachine
    constructor: ( options = {} ) ->
        super()
        @children = []
        @parent = null
        
        options.parent?.add( @ )
        for child in options.children
            @add( child )
    

    add: ( module ) ->
        
        if _.isModule( module )
            unless _.contains( @children, module ) and module.parent?
                @children.push( module )
                module.parent = @
        
        return @
    

    remove: ( module ) ->
        
        if _.isNumber( module )
            @children.splice( module, 1 )
            
        else
            @children = _.without( @children, module )
            module.parent = null
            
        return @
    


# ==============
# = View-Class =
# ==============
class Crema.View extends Crema.Module
    constructor: () ->
        super()
        @ui = {}
        
        @ui.container = $( "<div/>" )
        
        @ui.childContainer = @ui.container
        
        @html = @ui.container
    

    add: ( view ) ->
        if _.isView( view )
            super( view )
            @ui.childContainer.append( view.html )
    

    update: () ->
        for child, i in @children
            child.update()
            
        return @
    

    dispose: () ->
        @html.remove()
    


# ========================
# = ViewController Class =
# ========================
class Crema.ViewController extends Crema.Module
    constructor: () ->
        super()
        @view = new Crema.View( @ )
    

    _commandChecker: ( type, bind ) ->
        if bind
            actionName = "bound"
            methodName = "bind"
        else
            actionName = "unbound"
            methodName = "unbind"
        
        if type.split( "." )[0] is "command"
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
    

    updateUI: () ->
        @view.update()
        #TODO: Decide which child-chain should be called to update, but dont update twice.
        #for child, i in @children
        #    child.updateUI()
        
        return @
    

    dispose: () ->
        super()
        @view.dispose()
        return null
    







