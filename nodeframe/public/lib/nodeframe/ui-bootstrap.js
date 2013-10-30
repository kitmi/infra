'use strict';

var Element = require('./element.js'),
    Helpers = require('./ui-helpers.js'),
    S = require("string");

Helpers.prototype.icon = function(icon) {
    return '<span class="glyphicon glyphicon-' + icon+ '"></i>';
};

Helpers.prototype.legend = function(title) {
    return '<legend>' + title + '</legend>';
};

/**
 *
 * @param title
 * @param style
 * @returns {*}
 */
Helpers.prototype.label = function(title, style) {
    return this.styledText('label label-'+ style, title);
};

/**
 *
 * @param title
 * @param link
 * @param attrs {type: button|toggle}
 * @returns {*}
 */
Helpers.prototype.button = function(title, link, attrs) {
    attrs = attrs || 'default';
    if (!_.isObject(attrs)) {
        attrs = {class: 'btn-' + attrs};
    } else {
        attrs = _.clone(attrs);
    }

    var type = attrs.type ? attrs.type : 'button';

    if (link) {
        link = _.escape(link);

        if (type == 'toggle') {
            attrs['type'] = 'button';
            attrs['data-toggle'] = link;
        }

        if (link.substr(0, 11) == 'javascript:') {
            attrs['onclick'] = link.substr(11);
        } else if (type == 'button') {
            attrs['data-link'] = link;
        }
    }

    var btn = new Element('button', attrs, title);
    btn.insertClass('btn');

    return btn;
};

/**
 *
 * @param fields {icon, label, attrs, alt, inline }
 * @param attrs
 * @param options {showRequired, isPopUp, title }
 * @param data
 * @returns {*}
 */
Helpers.prototype.form = function(fields, attrs, options, data) {
    attrs = _.extend({role: 'form', method: 'post'}, attrs);
    options = _.extend({showRequired: true}, options);

    var body = new Element('form', attrs, body), l = fields.length,
        continueInline = false, endingInline,
        controlGroup, controls, pushedMsgBlock;

    if (options.isPopUp) {
        body.appendContent(this.button('&times;', null, {
            type: 'button',
            class: 'close',
            'data-dismiss': 'modal',
            'aria-hidden': 'true'
        }));
    }

    if (options.title) {
        body.appendContent(this.legend(options.title));
    }

    //PROCESS ALL FIELDS
    for (var i = 0; i < l; i++) {
        var field = fields[i], code = '', fieldNode;
        if (!field.type || !field.name) {
            throw new Error('Insufficient field properties! Missing "type" or "name".');
        }

        var strName = S(field.name),
            humanName = __(strName.humanize().s),
            fieldLabel = field.label || humanName,
            fieldAlt = field.alt || humanName;

        var fieldValue = data && data[field.name];

        //ICON
        if (field.icon) {
            fieldLabel = this.icon(field.icon) + fieldLabel;
        }

        var fieldAttrs = field.attrs || {};
        fieldAttrs.id = fieldAttrs.id || (field.type + '_' + strName.camelize().s);

        if (!field.prepend && field.inline) {
            fieldAttrs.class = fieldAttrs.class ? Element.normalizeClasses(fieldAttrs.class + ' pull-left') : 'pull-left';
        }

        //BUILD FORM FIELDS
        switch (field.type) {

            case 'input':
                if (fieldLabel && !fieldAttrs.placeholder) {
                    var ph = (field.prepend) ? '' : fieldAlt;
                    if (options.showRequired && field.required) {
                        ph += '&nbsp;' + __('(Required)');
                    }
                    fieldAttrs.placeholder = ph;
                }
                fieldAttrs.type = fieldAttrs.type || 'text';
                fieldAttrs.name = fieldAttrs.name || field.name;
                if (fieldValue) fieldAttrs.value = fieldValue;
                fieldNode = new Element('input', fieldAttrs);
                fieldNode.insertClass('form-control');
                break;

            case 'button':
                fieldNode = this.button(fieldLabel, field.link, fieldAttrs);
                fieldLabel = null;
                break;

            case 'link':
                fieldNode = this.link(fieldAttrs, fieldLabel);
                fieldLabel = null;
                break;

            case 'checkbox':
                if (!field.options) {
                    throw new Error('Missing checkbox options!');
                }

                fieldAttrs.type = fieldAttrs.type || 'checkbox';
                fieldAttrs.name = fieldAttrs.name || field.name;

                var inputFields = ['type', 'name', 'value', 'checked'],
                    labelAttrs = _.omit(fieldAttrs, inputFields),
                    inputAttrs = _.pick(fieldAttrs, inputFields),
                    index = 0;

                fieldNode = new Element('div', {class: 'checkbox'});

                for (var key in field.options) {
                    inputAttrs.id = fieldAttrs.id + index++;
                    inputAttrs.value = key;

                    if (fieldValue && fieldValue == key) {
                        inputAttrs.checked = true;
                    } else {
                        delete inputAttrs.checked;
                    }

                    fieldNode.appendContent(new Element('label', labelAttrs, new Element('input', inputAttrs) + '&nbsp;' + field.options[key]));
                }
                fieldLabel = field.label || null;
                break;

            case 'select':
                break;
        }

        if (!continueInline) {
            controlGroup = new Element('div', {class: 'form-group'});
            body.appendContent(controlGroup);

            if (fieldLabel) {
                var labelNode = new Element('label', {class: 'col-lg-2 control-label', for: fieldAttrs.id},
                    fieldLabel + ((field.required && options.showRequired) ? '<span style="color: red;">*</span>:' : ': '));
                controlGroup.appendContent(labelNode);
                controls = new Element('div', {class: 'col-lg-10'});
            } else {
                controls = new Element('div', {class: 'col-lg-offset-2 col-lg-10'});
            }

            controlGroup.appendContent(controls);
        }

        endingInline = continueInline;
        continueInline = field.inline;

        if (field.prepend) {
            var prependClass = 'input-prepend';
            if (continueInline) prependClass += ' pull-left';
            fieldNode = new Element('div', {class: prependClass},
                this.styledText('add-on', fieldAlt) + fieldNode);
        }

        controls.appendContent(fieldNode);

        var msgInline = new Element('span', {id: 'tip_' + fieldAttrs.id, class: 'help-inline'});
        controls.appendContent(msgInline);

        if (continueInline) {
            controls.appendContent('<div class="pull-left">&nbsp;&nbsp;</div>');

            if (!pushedMsgBlock) pushedMsgBlock = [];
            pushedMsgBlock.push(new Element('span', {id: 'msg_' + fieldAttrs.id, class: 'help-block'}));
        } else {
            if (endingInline) {
                controls.appendContent('<div class="clearfix"></div>');
            }

            if (pushedMsgBlock) {
                controls.appendContent(pushedMsgBlock.join("\n"));
                pushedMsgBlock = null;
            }
            controls.appendContent(new Element('span', {id: 'msg_' + fieldAttrs.id, class: 'help-block'}, field.message));
        }
    }

    return body;
};

/**
 *
 * @param items
 * @param attrs
 * @param activeIndex
 * @param type default|tabs|pills|justified
 * @returns {HTMLElement}
 */
Helpers.prototype.nav = function(items, attrs, activeIndex, type) {
    activeIndex = activeIndex ? activeIndex : 0;

    var l = items.length,
        ul = new Element('ul', attrs);

    for (var i = 0; i < l; i++) {
        var item = items[i],
            li = new Element('li');

        if (_.isArray(item.value)) {
            li.appendClass('dropdown')
                .appendContent(this.link(
                {href: '#', class: 'dropdown-toggle', 'data-toggle': 'dropdown'},
                item.label + ' <span class="caret"></span>'
            ))
                .appendContent(this.nav(item.value, null, item.active, 'dropdown'));
        } else {
            li.appendContent(this.link({href: item.value}, item.label));
        }

        if (activeIndex == i) {
            li.appendClass('active');
        }

        ul.appendContent(li);
    }

    switch (type) {
        case 'tabs':
            ul.insertClass('nav nav-tabs');
            break;

        case 'pills':
            ul.insertClass('nav nav-pills');
            break;

        case 'justified':
            ul.insertClass('nav nav-justified');
            break;

        case 'dropdown':
            ul.insertClass('dropdown-menu');
            break;

        default:
            ul.insertClass('nav');
            break;
    }

    return ul;
};

/**
 *
 * @param items
 * @param attrs
 * @returns {HTMLElement}
 */
Helpers.prototype.breadcrumb = function(items, attrs) {
    var l = items.length,
        ol = new Element('ol', {class: 'breadcrumb'}), li;

    l--;

    for (var i = 0; i <= l; i++) {
        var item = items[i];
        li = new Element('li');

        if (i == l) {
            li.appendContent(item.label)
                .appendClass('active');
        } else {
            li.appendContent(this.link({href:item.value}, item.label));
        }

        ol.appendContent(li);
    }

    return ol;
};

/**
 *
 * @param current
 * @param total
 * @param radius
 * @returns {HTMLElement}
 */
Helpers.prototype.pagination = function(current, total, radius) {
    total = total || 1;
    radius = radius || 5;

    var ul = new Element('ul', {class: 'pagination'}),
        li, min = current - radius, max;

    if (min < 1) {
        max = radius*2;
        min = 1;
    } else {
        max = current + radius;
    }

    if (max > total) {
        min = total - radius*2;
        if (min < 1) min = 1;
        max = total;
    }

    li = new Element('li', null, this.link({'data-page':1}, '&laquo;'));
    if (min == 1) {
        li.appendClass('disabled');
    }
    ul.appendContent(li);

    for (var i = min; i <= max; i++) {
        li = new Element('li');

        if (i == current) {
            li.appendClass('active');
        }

        li.appendContent(this.link({'data-page':i}, i));
        ul.appendContent(li);
    }

    li = new Element('li', null, this.link({'data-page':total}, '&raquo;'));
    if (max == total) {
        li.appendClass('disabled');
    }
    ul.appendContent(li);

    return ul;
};

module.exports = Helpers;