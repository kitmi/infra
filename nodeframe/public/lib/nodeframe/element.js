'use strict';

var Element = function(name, attrs, body) {
    this.name = name;
    this.attrs = attrs;
    this.body = body;

    if (attrs && attrs.class) {
        this.styleClass = attrs.class;
    }
};

Element.formatAttributes = function(attrs) {

    var pairs = [];
    for (var a in attrs) {
        if (attrs[a] === true) {
            pairs.push(a);
        } else if (attrs[a] === false) {

        } else {
            pairs.push(a + '="' + attrs[a] + '"');
        }
    }

    return pairs.join(' ');
};

Element.normalizeClasses = function (classes) {
    var parts = classes.split(' ');
    return _.uniq(parts).join(' ');
};

Element.prototype.toString = function() {
    var r = '';

    if (this.name) {
        var attrs = this.attrs;

        if (this.styleClass) {
            if (!attrs) attrs = {};
            else attrs = _.clone(this.attrs);

            attrs['class'] = Element.normalizeClasses(this.styleClass);
        }

        r = '<' + this.name;
        if (attrs) {
            r += ' ' + Element.formatAttributes(attrs);
        }
        r += '>';
    }

    if (typeof this.body != "undefined") {
        r += (_.isFunction(this.body) ? this.body() : (_.isArray(this.body) ? this.body.join('\n') : this.body));
        if (this.name) {
            r += '</' + this.name + '>';
        }
    }

    return r;
};

Element.prototype.appendClass = function(newClass) {
    this.styleClass = this.styleClass ? this.styleClass + ' ' + newClass : newClass;
    return this;
};

Element.prototype.insertClass = function(newClass) {
    this.styleClass = this.styleClass ? newClass + ' ' + this.styleClass : newClass;
    return this;
};

Element.prototype.appendContent = function(content) {
    if (this.body) {
        if (_.isArray(this.body)) {
            this.body.push(content);
        } else if (_.isFunction(this.body)) {
            this.body = [ this.body(), content ];
        } else {
            this.body = [ this.body, content ];
        }
    } else {
        this.body = content;
    }

    return this;
};

Element.prototype.resetContent = function() {
    this.body = null;
    return this;
};

Element.prototype.setAttribute = function(key, value) {
    var newAttrs = {};
    newAttrs[key] = value;

    this.attrs = _.extend(this.attrs, newAttrs);

    if (key == 'class') {
        this.styleClass = this.attrs.class;
    }
    return this;
};

module.exports = Element;
