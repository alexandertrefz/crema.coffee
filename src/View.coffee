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
    

