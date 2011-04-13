/*
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
 */var Crema;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
_.isTabItem = function(obj) {
  return _.isViewController(obj) && _.ducktype(obj, ["name"]);
};
Crema = {
  Views: {},
  Controllers: {},
  ViewControllers: {}
};
Crema.EventMachine = (function() {
  function EventMachine() {}
  EventMachine.prototype.fireEvent = function(type, data) {
    var event;
    if (typeof event !== "object") {
      event = jQuery.Event(type);
    }
    jQuery.event.trigger(event, data, this);
    if ((this.parent != null) && !event.isPropagationStopped()) {
      jQuery.event.trigger(event, data, this.parent);
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
  return EventMachine;
})();
Crema.Module = (function() {
  __extends(Module, Crema.EventMachine);
  function Module() {
    Module.__super__.constructor.call(this);
    this.children = [];
    this.parent = null;
  }
  Module.prototype.add = function(module) {
    if (_.isModule(module)) {
      if (!(_.contains(this.children, module) && (module.parent != null))) {
        this.children.push(module);
        module.parent = this;
      }
    }
    return this;
  };
  Module.prototype.remove = function(module) {
    if (_.isNumber(module)) {
      this.children.splice(module, 1);
    } else {
      this.children = _.without(this.children, module);
      module.parent = null;
    }
    return this;
  };
  return Module;
})();
Crema.View = (function() {
  __extends(View, Crema.Module);
  function View() {
    View.__super__.constructor.call(this);
    this.ui = {};
    this.ui.container = $("<div/>");
    this.ui.childContainer = this.ui.container;
    this.html = this.ui.container;
  }
  View.prototype.add = function(view) {
    if (_.isView(view)) {
      View.__super__.add.call(this, view);
      return this.ui.childContainer.append(view.html);
    }
  };
  View.prototype.update = function() {
    var child, i, _len, _ref;
    _ref = this.children;
    for (i = 0, _len = _ref.length; i < _len; i++) {
      child = _ref[i];
      child.update();
    }
    return this;
  };
  View.prototype.dispose = function() {
    return this.html.remove();
  };
  return View;
})();
Crema.ViewController = (function() {
  __extends(ViewController, Crema.Module);
  function ViewController() {
    ViewController.__super__.constructor.call(this);
    this.view = new Crema.View();
  }
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
    this.view.update();
    return this;
  };
  ViewController.prototype.dispose = function() {
    ViewController.__super__.dispose.call(this);
    this.view.dispose();
    return null;
  };
  return ViewController;
})();