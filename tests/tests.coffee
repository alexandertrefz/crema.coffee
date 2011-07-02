$ = crema

containsGroup = ( collection, group ) ->
    result = true
    
    for value in group
        result = false unless collection.contains( value )
    
    return result


notContainsGroup = ( collection, group ) ->
    result = true
    
    for value in group
        result = false if collection.contains( value )
    
    return result


module "Collection"
test "_updateRange", () ->
    collection = new $.Collection(arr)
    equal(collection.count, 0)
    
    arr = [0, 1, 2]
    collection.items = arr
    collection._updateRange()
    equal(collection.count, arr.length)
    
    arr = [0, 1, 2, 3, 4, 5]
    collection.items = arr
    collection._updateRange()
    equal(collection.count, arr.length)
    
    arr = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    collection.items = arr
    collection._updateRange()
    equal(collection.count, arr.length)

test "constructor", () ->
    
    # ===============
    # = 0 Arguments =
    # ===============
    collection = new $.Collection()
    equals( collection.count, 0, "Collection without Arguments" )
    
    # ==============
    # = 1 Argument =
    # ==============
    arr = []
    collection = new $.Collection( arr )
    equals( collection.count, 0, "Collection with []" )
    
    arr = [0..3]
    collection = new $.Collection( arr )
    equals( collection.count, 4, "Collection with [0, 1, 2, 3]" )
    
    arr = []
    arr[0] = 0
    arr[3] = 3
    collection = new $.Collection( arr )
    equals( collection.count, 4, "Collection with [0, undefined, undefined, 3]" )
    
    # ===============
    # = 2 Arguments =
    # ===============
    # 2nd arg: true
    arr = []
    collection = new $.Collection( arr, true )
    equals( collection.count, 0, "Collection with [], true" )
    
    arr = [0..3]
    collection = new $.Collection( arr, true )
    equals( collection.count, 4, "Collection with [0, 1, 2, 3], true" )
    
    arr = []
    arr[0] = 0
    arr[3] = 3
    collection = new $.Collection( arr, true )
    equals( collection.count, 2, "Collection with [0, undefined, undefined, 3], true" )
    
    # 2nd arg: false
    arr = []
    collection = new $.Collection( arr, false )
    equals( collection.count, 0, "Collection with [], false" )
    
    arr = [0..3]
    collection = new $.Collection( arr, false )
    equals( collection.count, 4, "Collection with [0, 1, 2, 3], false" )
    
    arr = []
    arr[0] = 0
    arr[3] = 3
    collection = new $.Collection( arr, false )
    equals( collection.count, 4, "Collection with [0, undefined, undefined, 3], false" )

test "indexOf", () ->
    
    arr = [0, 1, 2, 3]
    collection = new $.Collection( arr )
    equals( collection.indexOf( 0 ), 0, "indexOf 0 in [0, 1, 2, 3]" )
    equals( collection.indexOf( 1 ), 1, "indexOf 1 in [0, 1, 2, 3]" )
    equals( collection.indexOf( 2 ), 2, "indexOf 2 in [0, 1, 2, 3]" )
    equals( collection.indexOf( 3 ), 3, "indexOf 3 in [0, 1, 2, 3]" )
    
    arr = []
    arr[0] = 0
    arr[3] = 3
    collection = new $.Collection( arr, true )
    equals( collection.indexOf( 0 ), 0, "indexOf 0 in [0, undefined, undefined, 3], true" )
    equals( collection.indexOf( 1 ), -1, "indexOf 1 in [0, undefined, undefined, 3], true" )
    equals( collection.indexOf( 2 ), -1, "indexOf 2 in [0, undefined, undefined, 3], true" )
    equals( collection.indexOf( 3 ), 1, "indexOf 3 in [0, undefined, undefined, 3], true" )

test "contains", () ->
    arr = [0, 1, 2, 3]
    collection = new $.Collection( arr )
    equals( collection.contains( 0 ), true, "contains 0 in [0, 1, 2, 3]" )
    equals( collection.contains( 1 ), true, "contains 1 in [0, 1, 2, 3]" )
    equals( collection.contains( 2 ), true, "contains 2 in [0, 1, 2, 3]" )
    equals( collection.contains( 3 ), true, "contains 3 in [0, 1, 2, 3]" )
    
    arr = []
    arr[0] = 0
    arr[3] = 3
    collection = new $.Collection( arr, true )
    equals( collection.contains( 0 ), true, "contains 0 in [0, undefined, undefined, 3], true" )
    equals( collection.contains( 1 ), false, "contains 1 in [0, undefined, undefined, 3], true" )
    equals( collection.contains( 2 ), false, "contains 2 in [0, undefined, undefined, 3], true" )
    equals( collection.contains( 3 ), true, "contains 3 in [0, undefined, undefined, 3], true" )

test "add", () ->
    
    arr = []
    collection = new $.Collection( arr )
    
    collection.add(0)
    ok( collection.count is 1 and collection.items.length is 1 and collection.contains(0))
    
    collection.add(1)
    ok( collection.count is 2 and collection.items.length is 2 and containsGroup(collection, [0, 1]))
    
    collection.add(2)
    ok( collection.count is 3 and collection.items.length is 3 and containsGroup(collection, [0, 1, 2]))

test "addRange", () ->
    
    arr = []
    collection = new $.Collection( arr )
    
    range = [0, 1, 2]
    collection.addRange(range)
    ok( collection.count is 3 and collection.items.length is 3 and containsGroup(collection, [0, 1, 2]))
    
    range = [3, 4, 5]
    collection.addRange(range)
    ok( collection.count is 6 and collection.items.length is 6 and containsGroup(collection, [0, 1, 2, 3, 4, 5]))
    
    range = [6, 7, 8]
    collection.addRange(range)
    ok( collection.count is 9 and collection.items.length is 9 and containsGroup(collection, [0, 1, 2, 3, 4, 5, 6, 7, 8]))

test "insert", () ->
    
    arr = [0, 2, 4]
    collection = new $.Collection( arr )
    
    collection.insert( -1, -1 )
    ok( collection.count is 4 and collection.items.length is 4 and containsGroup(collection, [-1, 0, 2, 4]))
    
    collection.insert( 1, 1 )
    ok( collection.count is 5 and collection.items.length is 5 and containsGroup(collection, [-1, 0, 1, 2, 4]))
    
    collection.insert( 3, 3 )
    ok( collection.count is 6 and collection.items.length is 6 and containsGroup(collection, [-1, 0, 1, 2, 3, 4]))
    
    collection.insert( 5, 5 )
    ok( collection.count is 7 and collection.items.length is 7 and containsGroup(collection, [-1, 0, 1, 2, 3, 4, 5]))

test "insertRange", () ->
    
    arr = []
    collection = new $.Collection( arr )
    
    range = [0, 4, 8]
    collection.insertRange( range, 0 )
    ok( collection.count is 3 and collection.items.length is 3 and containsGroup(collection, [0, 4, 8]))
    
    range = [1, 2, 3]
    collection.insertRange( range, 1 )
    ok( collection.count is 6 and collection.items.length is 6 and containsGroup(collection, [0, 1, 2, 3, 4, 8]))
    
    range = [5, 6, 7]
    collection.insertRange( range, 6)
    ok( collection.count is 9 and collection.items.length is 9 and containsGroup(collection, [0, 1, 2, 3, 4, 5, 6, 7, 8]))

test "_calculateSpliceIndex", () ->
    startIndex = 1
    arr = [0, 1, 2, 3, 4]
    collection = new $.Collection( arr )
    equal(collection._calculateSpliceIndex( startIndex, 4 ), 4)
    equal(collection._calculateSpliceIndex( startIndex, 3 ), 3)
    equal(collection._calculateSpliceIndex( startIndex, 2 ), 2)
    equal(collection._calculateSpliceIndex( startIndex, 1 ), 1)
    equal(collection._calculateSpliceIndex( startIndex, 0 ), true)
    equal(collection._calculateSpliceIndex( startIndex, -1 ), 4)
    equal(collection._calculateSpliceIndex( startIndex, -2 ), 3)
    equal(collection._calculateSpliceIndex( startIndex, -3 ), 2)
    equal(collection._calculateSpliceIndex( startIndex, -4 ), 1)
    equal(collection._calculateSpliceIndex( startIndex, -5 ), 0)

test "_calculateIndex", () ->
    arr = [0, 1, 2, 3, 4]
    collection = new $.Collection( arr )
    equal(collection._calculateIndex( 4 ), 4)
    equal(collection._calculateIndex( 3 ), 3)
    equal(collection._calculateIndex( 2 ), 2)
    equal(collection._calculateIndex( 1 ), 1)
    equal(collection._calculateIndex( 0 ), 0)
    equal(collection._calculateIndex( -1 ), 4)
    equal(collection._calculateIndex( -2 ), 3)
    equal(collection._calculateIndex( -3 ), 2)
    equal(collection._calculateIndex( -4 ), 1)
    equal(collection._calculateIndex( -5 ), 0)

test "_removeRange", () ->
    
    arr = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    collection = new $.Collection( arr )
    
    collection._removeRange( 3, 5 )
    ok( collection.count is 6 and collection.items.length is 6 and containsGroup(collection, [0, 1, 2, 6, 7, 8]) and notContainsGroup(collection, [3, 4, 5]))
    
    collection._removeRange( 3, 5 )
    ok( collection.count is 3 and collection.items.length is 3 and containsGroup(collection, [0, 1, 2]) and notContainsGroup(collection, [3, 4, 5, 6, 7, 8]))
    
    collection._removeRange( 0, 2)
    ok( collection.count is 0 and collection.items.length is 0 and notContainsGroup(collection, [0, 1, 2, 3, 4, 5, 6, 7, 8]))

test "_removeAt", () ->
    
    arr = [0, 1, 2]
    collection = new $.Collection( arr )
    
    collection._removeAt(1)
    ok( collection.count is 2 and collection.items.length is 2 and not collection.contains(1) and containsGroup(collection, [0, 2]))
    
    collection._removeAt(1)
    ok( collection.count is 1 and collection.items.length is 1 and not collection.contains(1) and not collection.contains(2) and collection.contains(0))
    
    collection._removeAt(0)
    ok( collection.count is 0 and collection.items.length is 0 and not collection.contains(0) and not collection.contains(1) and not collection.contains(2))

test "removeAt", () ->
    
    arr = [0, 1, 2]
    collection = new $.Collection( arr )
    
    collection.removeAt(1)
    ok( collection.count is 2 and collection.items.length is 2 and not collection.contains(1) and containsGroup(collection, [0, 2]))
    
    collection.removeAt(1)
    ok( collection.count is 1 and collection.items.length is 1 and not collection.contains(1) and not collection.contains(2) and collection.contains(0))
    
    collection.removeAt(0)
    ok( collection.count is 0 and collection.items.length is 0 and not collection.contains(0) and not collection.contains(1) and not collection.contains(2))

test "removeRange", () ->
    
    arr = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    collection = new $.Collection( arr )
    
    collection.removeRange( 3, 5 )
    ok( collection.count is 6 and collection.items.length is 6 and containsGroup(collection, [0, 1, 2, 6, 7, 8]) and notContainsGroup(collection, [3, 4, 5]))
    
    collection.removeRange( 3, 5 )
    ok( collection.count is 3 and collection.items.length is 3 and containsGroup(collection, [0, 1, 2]) and notContainsGroup(collection, [3, 4, 5, 6, 7, 8]))
    
    collection.removeRange( 0, 2)
    ok( collection.count is 0 and collection.items.length is 0 and notContainsGroup(collection, [0, 1, 2, 3, 4, 5, 6, 7, 8]))

test "remove", () ->
    
    arr = [0, 1, 2]
    collection = new $.Collection( arr )
    
    collection.remove(0)
    ok( collection.count is 2 and collection.items.length is 2 and not collection.contains(0) and containsGroup(collection, [1, 2]))
    
    collection.remove(1)
    ok( collection.count is 1 and collection.items.length is 1 and not collection.contains(0) and not collection.contains(1) and collection.contains(2))
    
    collection.remove(2)
    ok( collection.count is 0 and collection.items.length is 0 and not collection.contains(0) and not collection.contains(1) and not collection.contains(2))

test "get", () ->
    arr = [0, 1, 2, 3, 4]
    collection = new $.Collection( arr )
    equal(collection.get( 4 ), 4)
    equal(collection.get( 3 ), 3)
    equal(collection.get( 2 ), 2)
    equal(collection.get( 1 ), 1)
    equal(collection.get( 0 ), 0)
    equal(collection.get( -1 ), 4)
    equal(collection.get( -2 ), 3)
    equal(collection.get( -3 ), 2)
    equal(collection.get( -4 ), 1)
    equal(collection.get( -5 ), 0)

test "set", () ->
    arr = [0, 1, 2, 3, 4]
    collection = new $.Collection( arr )
    equal(collection.set( 4, 8 ), true)
    equal(collection.get( 4 ), 8)
    
    equal(collection.set( 3, 6 ), true)
    equal(collection.get( 3 ), 6)
    
    equal(collection.set( 2, 4 ), true)
    equal(collection.get( 2 ), 4)
    
    equal(collection.set( 1, 2 ), true)
    equal(collection.get( 1 ), 2)
    
    equal(collection.set( 0, 1 ), true)
    equal(collection.get( 0 ), 1)
    
    equal(collection.set( -1, 4 ), true)
    equal(collection.get( -1 ), 4)
    
    equal(collection.set( -2, 3 ), true)
    equal(collection.get( -2 ), 3)
    
    equal(collection.set( -3, 2 ), true)
    equal(collection.get( -3 ), 2)
    
    equal(collection.set( -4, 1 ), true)
    equal(collection.get( -4 ), 1)
    
    equal(collection.set( -5, 0 ), true)
    equal(collection.get( -5 ), 0)
    
    raises(collection.get( -6 ), "Index -6 is out of Range.")
    raises(collection.get( 6 ), "Index 6 is out of Range.")






