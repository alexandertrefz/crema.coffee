var containsGroup, notContainsGroup;
module("Base");
test("_.ducktype", function() {
  var x, y, z;
  x = y = z = function() {};
  ok(_.ducktype({
    x: x,
    y: y,
    z: z
  }, ["x", "y", "z"]));
  ok(_.ducktype({
    x: x,
    y: y,
    z: z
  }, ["x", "y"]));
  ok(!_.ducktype({
    x: x,
    y: y,
    z: z
  }, ["x", "y", "z", "a"]));
  return ok(!_.ducktype({}, ["x", "y", "z", "a"]));
});
test("_.isEventMachine", function() {
  var eventMachine;
  eventMachine = new crema.EventMachine();
  return ok(_.isEventMachine(eventMachine));
});
test("_.isModule", function() {
  var module;
  module = new crema.Module();
  return ok(_.isModule(module));
});
test("_.isViewController", function() {
  var viewController;
  viewController = new crema.ViewController();
  return ok(_.isViewController(viewController));
});
test("_.isView", function() {
  var view;
  view = new crema.View();
  return ok(_.isView(view));
});
test("_.isModel", function() {
  var model;
  model = new crema.Model();
  return ok(_.isModel(model));
});
test("Namespaces", function() {
  ok(crema.version != null, "crema.version exists");
  ok(crema.views != null, "crema.views exists");
  ok(crema.controllers != null, "crema.controllers exists");
  ok(crema.viewControllers != null, "crema.viewControllers exists");
  ok(crema.models != null, "crema.models exists");
  return ok(crema.types != null, "crema.types exists");
});
module("EventMachine");
test("constructor", function() {});
module("Collection");
containsGroup = function(collection, group) {
  var value, _i, _len;
  for (_i = 0, _len = group.length; _i < _len; _i++) {
    value = group[_i];
    if (!collection.contains(value )) {
      return false;
    }
  }
  return true;
};
notContainsGroup = function(collection, group) {
  var value, _i, _len;
  for (_i = 0, _len = group.length; _i < _len; _i++) {
    value = group[_i];
    if (collection.contains(value )) {
      result(false);
    }
  }
  return true;
};
test("_updateRange", function() {
  var arr, collection;
  collection = new crema.Collection(arr);
  equal(collection.count, 0);
  arr = [0, 1, 2];
  collection.items = arr;
  collection._updateRange();
  equal(collection.count, arr.length);
  arr = [0, 1, 2, 3, 4, 5];
  collection.items = arr;
  collection._updateRange();
  equal(collection.count, arr.length);
  arr = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  collection.items = arr;
  collection._updateRange();
  return equal(collection.count, arr.length);
});
test("constructor", function() {
  var arr, collection;
  collection = new crema.Collection();
  equals(collection.count, 0, "Collection without Arguments");
  arr = [];
  collection = new crema.Collection(arr);
  equals(collection.count, 0, "Collection with []");
  arr = [0, 1, 2, 3];
  collection = new crema.Collection(arr);
  equals(collection.count, 4, "Collection with [0, 1, 2, 3]");
  arr = [];
  arr[0] = 0;
  arr[3] = 3;
  collection = new crema.Collection(arr);
  equals(collection.count, 4, "Collection with [0, undefined, undefined, 3]");
  arr = [];
  collection = new crema.Collection(arr, true);
  equals(collection.count, 0, "Collection with [], true");
  arr = [0, 1, 2, 3];
  collection = new crema.Collection(arr, true);
  equals(collection.count, 4, "Collection with [0, 1, 2, 3], true");
  arr = [];
  arr[0] = 0;
  arr[3] = 3;
  collection = new crema.Collection(arr, true);
  equals(collection.count, 2, "Collection with [0, undefined, undefined, 3], true");
  arr = [];
  collection = new crema.Collection(arr, false);
  equals(collection.count, 0, "Collection with [], false");
  arr = [0, 1, 2, 3];
  collection = new crema.Collection(arr, false);
  equals(collection.count, 4, "Collection with [0, 1, 2, 3], false");
  arr = [];
  arr[0] = 0;
  arr[3] = 3;
  collection = new crema.Collection(arr, false);
  return equals(collection.count, 4, "Collection with [0, undefined, undefined, 3], false");
});
test("indexOf", function() {
  var arr, collection;
  arr = [0, 1, 2, 3];
  collection = new crema.Collection(arr);
  equals(collection.indexOf(0), 0, "indexOf 0 in [0, 1, 2, 3]");
  equals(collection.indexOf(1), 1, "indexOf 1 in [0, 1, 2, 3]");
  equals(collection.indexOf(2), 2, "indexOf 2 in [0, 1, 2, 3]");
  equals(collection.indexOf(3), 3, "indexOf 3 in [0, 1, 2, 3]");
  arr = [];
  arr[0] = 0;
  arr[3] = 3;
  collection = new crema.Collection(arr, true);
  equals(collection.indexOf(0), 0, "indexOf 0 in [0, undefined, undefined, 3], true");
  equals(collection.indexOf(1), -1, "indexOf 1 in [0, undefined, undefined, 3], true");
  equals(collection.indexOf(2), -1, "indexOf 2 in [0, undefined, undefined, 3], true");
  return equals(collection.indexOf(3), 1, "indexOf 3 in [0, undefined, undefined, 3], true");
});
test("contains", function() {
  var arr, collection;
  arr = [0, 1, 2, 3];
  collection = new crema.Collection(arr);
  equals(collection.contains(0), true, "contains 0 in [0, 1, 2, 3]");
  equals(collection.contains(1), true, "contains 1 in [0, 1, 2, 3]");
  equals(collection.contains(2), true, "contains 2 in [0, 1, 2, 3]");
  equals(collection.contains(3), true, "contains 3 in [0, 1, 2, 3]");
  arr = [];
  arr[0] = 0;
  arr[3] = 3;
  collection = new crema.Collection(arr, true);
  equals(collection.contains(0), true, "contains 0 in [0, undefined, undefined, 3], true");
  equals(collection.contains(1), false, "contains 1 in [0, undefined, undefined, 3], true");
  equals(collection.contains(2), false, "contains 2 in [0, undefined, undefined, 3], true");
  return equals(collection.contains(3), true, "contains 3 in [0, undefined, undefined, 3], true");
});
test("add", function() {
  var arr, collection;
  arr = [];
  collection = new crema.Collection(arr);
  collection.add(0);
  ok(collection.count === 1 && collection.items.length === 1 && collection.contains(0));
  collection.add(1);
  ok(collection.count === 2 && collection.items.length === 2 && containsGroup(collection, [0, 1]));
  collection.add(2);
  return ok(collection.count === 3 && collection.items.length === 3 && containsGroup(collection, [0, 1, 2]));
});
test("addRange", function() {
  var arr, collection, range;
  arr = [];
  collection = new crema.Collection(arr);
  range = [0, 1, 2];
  collection.addRange(range);
  ok(collection.count === 3 && collection.items.length === 3 && containsGroup(collection, [0, 1, 2]));
  range = [3, 4, 5];
  collection.addRange(range);
  ok(collection.count === 6 && collection.items.length === 6 && containsGroup(collection, [0, 1, 2, 3, 4, 5]));
  range = [6, 7, 8];
  collection.addRange(range);
  return ok(collection.count === 9 && collection.items.length === 9 && containsGroup(collection, [0, 1, 2, 3, 4, 5, 6, 7, 8]));
});
test("insert", function() {
  var arr, collection;
  arr = [0, 2, 5];
  collection = new crema.Collection(arr);
  collection.insert(1, 1);
  ok(collection.count === 4 && collection.items.length === 4 && containsGroup(collection, [0, 1, 2, 5]));
  collection.insert(3, 3);
  ok(collection.count === 5 && collection.items.length === 5 && containsGroup(collection, [0, 1, 2, 3, 5]));
  collection.insert(4, -1);
  return ok(collection.count === 6 && collection.items.length === 6 && containsGroup(collection, [0, 1, 2, 3, 4, 5]));
});
test("insertRange", function() {
  var arr, collection, range;
  arr = [];
  collection = new crema.Collection(arr);
  range = [0, 4, 8];
  collection.insertRange(range, 0);
  ok(collection.count === 3 && collection.items.length === 3 && containsGroup(collection, [0, 4, 8]));
  range = [1, 2, 3];
  collection.insertRange(range, 1);
  ok(collection.count === 6 && collection.items.length === 6 && containsGroup(collection, [0, 1, 2, 3, 4, 8]));
  range = [5, 6, 7];
  collection.insertRange(range, -1);
  return ok(collection.count === 9 && collection.items.length === 9 && containsGroup(collection, [0, 1, 2, 3, 4, 5, 6, 7, 8]));
});
test("_calculateSpliceIndex", function() {
  var arr, collection, startIndex;
  startIndex = 1;
  arr = [0, 1, 2, 3, 4];
  collection = new crema.Collection(arr);
  equal(collection._calculateSpliceIndex(startIndex, 4), 4);
  equal(collection._calculateSpliceIndex(startIndex, 3), 3);
  equal(collection._calculateSpliceIndex(startIndex, 2), 2);
  equal(collection._calculateSpliceIndex(startIndex, 1), 1);
  equal(collection._calculateSpliceIndex(startIndex, 0), true);
  equal(collection._calculateSpliceIndex(startIndex, -1), 4);
  equal(collection._calculateSpliceIndex(startIndex, -2), 3);
  equal(collection._calculateSpliceIndex(startIndex, -3), 2);
  equal(collection._calculateSpliceIndex(startIndex, -4), 1);
  return equal(collection._calculateSpliceIndex(startIndex, -5), 0);
});
test("_calculateIndex", function() {
  var arr, collection;
  arr = [0, 1, 2, 3, 4];
  collection = new crema.Collection(arr);
  equal(collection._calculateIndex(4), 4);
  equal(collection._calculateIndex(3), 3);
  equal(collection._calculateIndex(2), 2);
  equal(collection._calculateIndex(1), 1);
  equal(collection._calculateIndex(0), 0);
  equal(collection._calculateIndex(-1), 4);
  equal(collection._calculateIndex(-2), 3);
  equal(collection._calculateIndex(-3), 2);
  equal(collection._calculateIndex(-4), 1);
  return equal(collection._calculateIndex(-5), 0);
});
test("_removeRange", function() {
  var arr, collection;
  arr = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  collection = new crema.Collection(arr);
  collection._removeRange(3, 5);
  ok(collection.count === 6 && collection.items.length === 6 && containsGroup(collection, [0, 1, 2, 6, 7, 8]) && notContainsGroup(collection, [3, 4, 5]));
  collection._removeRange(3, 5);
  ok(collection.count === 3 && collection.items.length === 3 && containsGroup(collection, [0, 1, 2]) && notContainsGroup(collection, [3, 4, 5, 6, 7, 8]));
  collection._removeRange(0, 2);
  return ok(collection.count === 0 && collection.items.length === 0 && notContainsGroup(collection, [0, 1, 2, 3, 4, 5, 6, 7, 8]));
});
test("_removeAt", function() {
  var arr, collection;
  arr = [0, 1, 2];
  collection = new crema.Collection(arr);
  collection._removeAt(1);
  ok(collection.count === 2 && collection.items.length === 2 && !collection.contains(1) && containsGroup(collection, [0, 2]));
  collection._removeAt(1);
  ok(collection.count === 1 && collection.items.length === 1 && !collection.contains(1) && !collection.contains(2) && collection.contains(0));
  collection._removeAt(0);
  return ok(collection.count === 0 && collection.items.length === 0 && !collection.contains(0) && !collection.contains(1) && !collection.contains(2));
});
test("removeAt", function() {
  var arr, collection;
  arr = [0, 1, 2];
  collection = new crema.Collection(arr);
  collection.removeAt(1);
  ok(collection.count === 2 && collection.items.length === 2 && !collection.contains(1) && containsGroup(collection, [0, 2]));
  collection.removeAt(1);
  ok(collection.count === 1 && collection.items.length === 1 && !collection.contains(1) && !collection.contains(2) && collection.contains(0));
  collection.removeAt(0);
  return ok(collection.count === 0 && collection.items.length === 0 && !collection.contains(0) && !collection.contains(1) && !collection.contains(2));
});
test("removeRange", function() {
  var arr, collection;
  arr = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  collection = new crema.Collection(arr);
  collection.removeRange(3, 5);
  ok(collection.count === 6 && collection.items.length === 6 && containsGroup(collection, [0, 1, 2, 6, 7, 8]) && notContainsGroup(collection, [3, 4, 5]));
  collection.removeRange(3, 5);
  ok(collection.count === 3 && collection.items.length === 3 && containsGroup(collection, [0, 1, 2]) && notContainsGroup(collection, [3, 4, 5, 6, 7, 8]));
  collection.removeRange(0, 2);
  return ok(collection.count === 0 && collection.items.length === 0 && notContainsGroup(collection, [0, 1, 2, 3, 4, 5, 6, 7, 8]));
});
test("remove", function() {
  var arr, collection;
  arr = [0, 1, 2];
  collection = new crema.Collection(arr);
  collection.remove(0);
  ok(collection.count === 2 && collection.items.length === 2 && !collection.contains(0) && containsGroup(collection, [1, 2]));
  collection.remove(1);
  ok(collection.count === 1 && collection.items.length === 1 && !collection.contains(0) && !collection.contains(1) && collection.contains(2));
  collection.remove(2);
  return ok(collection.count === 0 && collection.items.length === 0 && !collection.contains(0) && !collection.contains(1) && !collection.contains(2));
});
test("get", function() {
  var arr, collection;
  arr = [0, 1, 2, 3, 4];
  collection = new crema.Collection(arr);
  equal(collection.get(4), 4);
  equal(collection.get(3), 3);
  equal(collection.get(2), 2);
  equal(collection.get(1), 1);
  equal(collection.get(0), 0);
  equal(collection.get(-1), 4);
  equal(collection.get(-2), 3);
  equal(collection.get(-3), 2);
  equal(collection.get(-4), 1);
  return equal(collection.get(-5), 0);
});
test("set", function() {
  var arr, collection;
  arr = [0, 1, 2, 3, 4];
  collection = new crema.Collection(arr);
  equal(collection.set(4, 8), true);
  equal(collection.get(4), 8);
  equal(collection.set(3, 6), true);
  equal(collection.get(3), 6);
  equal(collection.set(2, 4), true);
  equal(collection.get(2), 4);
  equal(collection.set(1, 2), true);
  equal(collection.get(1), 2);
  equal(collection.set(0, 1), true);
  equal(collection.get(0), 1);
  equal(collection.set(-1, 4), true);
  equal(collection.get(-1), 4);
  equal(collection.set(-2, 3), true);
  equal(collection.get(-2), 3);
  equal(collection.set(-3, 2), true);
  equal(collection.get(-3), 2);
  equal(collection.set(-4, 1), true);
  equal(collection.get(-4), 1);
  equal(collection.set(-5, 0), true);
  equal(collection.get(-5), 0);
  raises(collection.get(-6), "Index -6 is out of Range.");
  return raises(collection.get(6), "Index 6 is out of Range.");
});