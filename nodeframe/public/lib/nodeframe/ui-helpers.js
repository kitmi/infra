'use strict';

var Element = require('./element.js'),
    Helpers = function() {};

Helpers.prototype.hello = function() {
    return "--- nodeframe ui helper v1.0 ---";
};

Helpers.prototype.link = function(attrs, content) {
    attrs = _.extend({href: 'javascript:void(0);'}, attrs);
    return new Element('a', attrs, content || '');
};

Helpers.prototype.styledText = function(style, text) {
    return '<span class="' + style + '">' + text + '</span>';
};

module.exports = Helpers;
