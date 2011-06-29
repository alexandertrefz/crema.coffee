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
# - jQuery 1.6.1+
# - underscore 1.1.6+

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


_.isModel = ( obj ) ->
    return _.isModule( obj ) and _.ducktype( obj, ["getData"] )


# ====================
# = Initialize crema =
# ====================
crema = {
    version: "0.0.5pre"
    views: {}
    controllers: {}
    viewControllers: {}
    models: {}
    types: {}
}