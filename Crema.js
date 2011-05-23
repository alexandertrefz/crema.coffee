(function() {
  /*
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
   */  var crema;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  _.ducktype = function(obj, methods) {
    var method, _i, _len;
    if (!_.isArray(methods)) {
      methods = [methods];
    }
    for (_i = 0, _len = methods.length; _i < _len; _i++) {
      method = methods[_i];
      if ((obj != null ? obj[method] : void 0) == null) {
        return false;
      }
    }
    return true;
  };
  _.isEventMachine = function(obj) {
    return _.ducktype(obj, ["fireEvent", "bindEvent", "unbindEvent"]);
  };
  _.isModule = function(obj) {
    return _.isEventMachine(obj) && _.ducktype(obj, ["add", "remove"]);
  };
  _.isViewController = function(obj) {
    return _.isModule(obj) && _.ducktype(obj, ["bindCommand", "unbindCommand", "sendCommand", "updateUI"]);
  };
  _.isView = function(obj) {
    return _.isModule(obj) && _.ducktype(obj, ["update", "dispose"]);
  };
  crema = {
    version: "0.0.5pre",
    views: {},
    controllers: {},
    viewControllers: {}
  };
  window.crema = crema;
  crema.EventMachine = (function() {
    function EventMachine() {
      this._registeredObjects = new crema.Collection();
    }
    EventMachine.prototype.fireEvent = function(event, data) {
      var clonedEvent, eventType, i, item, sendClone, _i, _len, _len2, _ref, _ref2;
      if (typeof event !== "object") {
        event = jQuery.Event(event);
      }
      jQuery.event.trigger(event, data, this);
      if ((this.parent != null) && !event.isPropagationStopped()) {
        jQuery.event.trigger(event, data, this.parent);
      }
      if (this._registeredObjects.count) {
        _ref = this._registeredObjects.items;
        for (i = 0, _len = _ref.length; i < _len; i++) {
          item = _ref[i];
          sendClone = false;
          clonedEvent = _.clone(event);
          clonedEvent.isRegisteredEvent = true;
          clonedEvent.isClonedEvent = true;
          clonedEvent.type += "." + item.namespace;
          if (item.events.length === 0) {
            sendClone = true;
          } else {
            _ref2 = item.events;
            for (_i = 0, _len2 = _ref2.length; _i < _len2; _i++) {
              eventType = _ref2[_i];
              if (eventType === clonedEvent.type) {
                sendClone = true;
                break;
              }
            }
          }
          if (sendClone) {
            jQuery.event.trigger(clonedEvent, data, item.object);
          }
        }
      }
      return this;
    };
    EventMachine.prototype.bindEvent = function(type, data, fn, once) {
      var handler, key, value;
      if (once == null) {
        once = false;
      }
      if (typeof type === "object") {
        for (key in type) {
          value = type[key];
          this.bindEvent(key, data, value, once);
        }
        return this;
      }
      if (jQuery.isFunction(data)) {
        fn = data;
        data = void 0;
      }
      if (handler = once === true) {
        jQuery.proxy(fn, function(event) {
          this.unbindEvent(event, handler);
          return fn.apply(this, arguments);
        });
      }
      if (type === "unload" && once !== true) {
        this.bindEvent(type, data, fn, true);
      } else {
        jQuery.event.add(this, type, fn, data);
      }
      return this;
    };
    EventMachine.prototype.unbindEvent = function(type, fn) {
      var key, value;
      if (typeof type === "object" && !type.preventDefault) {
        for (key in type) {
          value = type[key];
          this.unbindEvent(key, value);
        }
      } else {
        jQuery.event.remove(this, type, fn);
      }
      return this;
    };
    EventMachine.prototype.register = function(namespace, events, object) {
      if (!this._registeredObjects.contains(object)) {
        this._registeredObjects.add({
          namespace: namespace,
          events: events,
          object: object
        });
        return true;
      }
      return false;
    };
    EventMachine.prototype.unregister = function(object) {
      var i, item, _len, _ref;
      _ref = this._registeredObjects.items;
      for (i = 0, _len = _ref.length; i < _len; i++) {
        item = _ref[i];
        if (item.object === object) {
          console.log(item);
          console.log(i);
          __bind(function(i) {
            return this._registeredObjects.removeAt(i);
          }, this)(i);
          console.log("removed");
          return true;
        }
      }
      return false;
    };
    return EventMachine;
  })();
  crema.Module = (function() {
    function Module(options) {
      var child, _i, _len, _ref, _ref2;
      if (options == null) {
        options = {};
      }
      Module.__super__.constructor.call(this);
      this.children = new crema.Collection();
      this.parent = null;
      if ((_ref = options.parent) != null) {
        _ref.add(this);
      }
      if (options.children != null) {
        _ref2 = options.children;
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          child = _ref2[_i];
          this.add(child);
        }
      }
    }
    __extends(Module, crema.EventMachine);
    Module.prototype.add = function(module) {
      if (_.isModule(module)) {
        if (!(_.contains(this.children, module) && (module.parent != null))) {
          this.children.add(module);
          module.parent = this;
          module.fireEvent("gotAdded");
          this.fireEvent("add", [module]);
        }
      }
      return this;
    };
    Module.prototype.remove = function(module) {
      if (_.isModule(module) && module.parent === this.controller) {
        this.children.remove(module);
        module.parent = null;
        module.fireEvent("gotRemoved");
        this.fireEvent("remove", [module]);
      }
      return this;
    };
    Module.prototype.dispose = function() {
      var child, _i, _len, _ref, _ref2;
      _ref = this.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        child.parent = null;
      }
      if ((_ref2 = this.parent) != null) {
        _ref2.remove(this);
      }
      return null;
    };
    return Module;
  })();
  crema.View = (function() {
    function View(controller, options) {
      this.controller = controller;
      View.__super__.constructor.call(this);
      this.ui = {};
      this.ui.container = $("<div/>");
      this.ui.childContainer = this.ui.container;
      this.html = this.ui.container;
    }
    __extends(View, crema.Module);
    View.prototype.add = function(view) {
      if (_.isView(view)) {
        View.__super__.add.call(this, view);
        this.ui.childContainer.append(view.html);
      }
      return this;
    };
    View.prototype.remove = function(view) {
      if (_.isView(view)) {
        View.__super__.remove.call(this, view);
        view.html.remove();
      }
      return this;
    };
    View.prototype.update = function() {
      var item, key, _ref;
      _ref = this.ui;
      for (key in _ref) {
        item = _ref[key];
        if (typeof item.updateUI === "function") {
          item.updateUI();
        }
      }
      return this;
    };
    View.prototype.dispose = function() {
      return this.html.remove();
    };
    return View;
  })();
  crema.ViewController = (function() {
    function ViewController(options) {
      var _ref;
      if (options == null) {
        options = {};
      }
      ViewController.__super__.constructor.call(this);
      this.isShown = options.isShown;
            if ((_ref = this.isShown) != null) {
        _ref;
      } else {
        this.isShown = true;
      };
      this.view = new crema.View(this);
    }
    __extends(ViewController, crema.Module);
    ViewController.prototype._initChildren = function(elements) {
      var check, element, item, refs, _fn, _i, _j, _len, _len2, _ref;
      refs = 0;
      for (_i = 0, _len = elements.length; _i < _len; _i++) {
        element = elements[_i];
        _ref = element.data;
        _fn = __bind(function(item) {
          return this._callAsync(__bind(function() {
            element.handler(item);
            return refs--;
          }, this));
        }, this);
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          item = _ref[_j];
          refs++;
          _fn(item);
        }
      }
      check = setInterval(__bind(function() {
        if (refs === 0) {
          this.fireEvent("childrenInitialized");
          return clearInterval(check);
        }
      }, this), 10);
    };
    ViewController.prototype._callAsync = function(func) {
      return setTimeout(func, 0);
    };
    ViewController.prototype._commandChecker = function(type, bind) {
      var actionName, methodName;
      if (bind) {
        actionName = "bound";
        methodName = "bind";
      } else {
        actionName = "unbound";
        methodName = "unbind";
      }
      if (type.split(".")[0] === "command") {
        throw new Error("'command' events cannot be " + actionName + " via " + methodName + "Event.\nUse " + methodName + "Command instead.");
      }
    };
    ViewController.prototype.bindEvent = function(type, data, fn, once, isInternal) {
      var key, value;
      if (once == null) {
        once = false;
      }
      if (isInternal == null) {
        isInternal = false;
      }
      if (isInternal !== true) {
        if (typeof type === "object") {
          for (key in type) {
            value = type[key];
            this._commandChecker(key, true);
          }
        } else {
          this._commandChecker(type, true);
        }
      }
      ViewController.__super__.bindEvent.call(this, type, data, fn, once);
      return this;
    };
    ViewController.prototype.unbindEvent = function(type, fn, isInternal) {
      var key, value;
      if (isInternal == null) {
        isInternal = false;
      }
      if (isInternal !== true) {
        if (typeof type === "object") {
          for (key in type) {
            value = type[key];
            this._commandChecker(key, false);
          }
        } else {
          this._commandChecker(type, false);
        }
      }
      ViewController.__super__.unbindEvent.call(this, type, fn, true);
      return this;
    };
    ViewController.prototype.sendCommand = function(command, data) {
      this.fireEvent("command." + command, data);
      return this;
    };
    ViewController.prototype.bindCommand = function(command, data, fn, once) {
      var key, value;
      if (once == null) {
        once = false;
      }
      if (typeof command === "object") {
        for (key in command) {
          value = command[key];
          this.bindCommand(key, data, value, once);
        }
        return this;
      }
      if (_.isFunction(data)) {
        fn = data;
        data = void 0;
      }
      this.bindEvent("command." + command, data, fn, once, true);
      return this;
    };
    ViewController.prototype.unbindCommand = function(command, fn) {
      var key, value;
      if (typeof command === "object") {
        for (key in command) {
          value = command[key];
          this.unbindCommand(key, value);
        }
        return this;
      }
      this.unbindEvent("command." + command, fn, true);
      return this;
    };
    ViewController.prototype.add = function(obj) {
      ViewController.__super__.add.call(this, obj);
      this.view.add(obj.view);
      return this;
    };
    ViewController.prototype.remove = function(obj) {
      ViewController.__super__.remove.call(this, obj);
      this.view.remove(obj.view);
      return this;
    };
    ViewController.prototype.updateUI = function() {
      var child, i, _len, _ref;
      this.view.update();
      _ref = this.children.items;
      for (i = 0, _len = _ref.length; i < _len; i++) {
        child = _ref[i];
        child.updateUI();
      }
      return this;
    };
    ViewController.prototype.dispose = function() {
      ViewController.__super__.dispose.call(this);
      this.view.dispose();
      this.fireEvent("dispose");
      return null;
    };
    return ViewController;
  })();
  crema.Collection = (function() {
    function Collection(array) {
      if (array == null) {
        array = [];
      }
      this.count = array.length;
      this.items = array;
    }
    __extends(Collection, crema.EventMachine);
    Collection.prototype.indexOf = function(item) {
      this.items.indexOf(item);
      return this;
    };
    Collection.prototype.contains = function(item) {
      return !!!this.indexOf(item);
    };
    Collection.prototype.add = function(item) {
      this.items.push(item);
      this._updateRange();
      return this;
    };
    Collection.prototype.addRange = function(items) {
      var item, _i, _len;
      for (_i = 0, _len = items.length; _i < _len; _i++) {
        item = items[_i];
        this.items.push(item);
      }
      this._updateRange();
      return this;
    };
    Collection.prototype.insert = function(item, index) {
      this.items.splice(index, 0, item);
      this._updateRange();
      return this;
    };
    Collection.prototype.insertRange = function(items, index) {
      Function.prototype.apply.apply(this.items.splice, [this.items, [index, 0].concat(items)]);
      this._updateRange();
      return this;
    };
    Collection.prototype.remove = function(item) {
      var index;
      index = this.indexOf(item);
      this._removeAt(index);
      return this;
    };
    Collection.prototype.removeAt = function(index) {
      this._removeAt(index);
      return this;
    };
    Collection.prototype.removeRange = function(from, to) {
      this._removeRange(from, to);
      return this;
    };
    Collection.prototype._removeRange = function(from, to) {
      this.items.splice(from, !to || 1 + to - from + (!(to < 0 ^ from >= 0) && (to < 0 || -1) * this.items.length));
      return this._updateRange();
    };
    Collection.prototype._removeAt = function(index) {
      return this._removeRange(index, index);
    };
    Collection.prototype._updateRange = function() {
      return this.count = this.items.length;
    };
    Collection.prototype.set = function(index, value) {
      try {
        this.items[index] = value;
        return true;
      } catch (err) {
        console.log(err);
        return false;
      }
    };
    Collection.prototype.get = function(index) {
      return this.items[index];
    };
    return Collection;
  })();
  (function() {
    var eventController;
    eventController = new Crema.EventMachine();
    Crema.publish = eventController.fireEvent;
    Crema.subscribe = eventController.bindEvent;
    return Crema.unsubscribe = eventController.unbindEvent;
  })();
}).call(this);
