test "_.ducktype", () ->
    x = y = z = () ->
        
    
    ok( _.ducktype( { x, y, z }, ["x", "y", "z"] ) )
    ok( _.ducktype( { x, y, z }, ["x", "y"] ) )
    ok( not _.ducktype( { x, y, z }, ["x", "y", "z", "a"] ) )
    ok( not _.ducktype( {}, ["x", "y", "z", "a"] ) )

test "_.isEventMachine", () ->
    eventMachine = new crema.EventMachine()
    
    ok( _.isEventMachine( eventMachine ) )

test "_.isModule", () ->
    
    module = new crema.Module()
    
    ok( _.isModule( module ) )

test "_.isViewController", () ->
    
    viewController = new crema.ViewController()
    
    ok( _.isViewController( viewController ) )    

test "_.isView", () ->
    
    view = new crema.View()
    
    ok( _.isView( view ) )  

test "_.isModel", () ->
    
    model = new crema.Model()
    
    ok( _.isModel( model ) )  

test "Namespaces", () ->
    ok( crema.version?, "crema.version exists" )
    ok( crema.views?, "crema.views exists" )
    ok( crema.controllers?, "crema.controllers exists" )
    ok( crema.viewControllers?, "crema.viewControllers exists" )
    ok( crema.models?, "crema.models exists" )
    ok( crema.types?, "crema.types exists" )

