var _ = require("underscore"),
    S = require("string"),
    path = require("path"),
    root = path.dirname(process.argv[1]),
    assert = require('better-assert');

function Mvc(app, route) {
    this.app = app;
    this.baseRoute = route;
}

/**
 * Constructs a URL path based on the route base
 * @param relativeUrl
 * @returns {*}
 */
Mvc.prototype.route = function(relativeUrl) {
    return path ? path.join(this.baseRoute, relativeUrl) : this.baseRoute;
};

Mvc.prototype.render = function(req, res, model) {
    var data = _.isFunction(model) ? model(req) : model;
    res.render(this.actionPath, data);
};

/**
 * Mount for mvc routing
 * @param app
 * @param route
 * @param opt {view, model, controllerPath, viewPath}
 */
exports.mount = function(app, route, opt) {
    var mvc = new Mvc(app, route);

    opt = _.extend({
        hasModule: false,
        controllerPath: 'controllers',
        viewPath: 'views',
        defaultModule: 'index',
        defaultController: 'index',
        defaultAction: 'index',
        splitPostAction: false
    }, opt);

    var setViewPath = function(req, res, next) {
        app.set('views', opt.viewPath);
        next();
    };

    var action = function(req, res) {
        var nodes = [], modName, ctrlName;
        if (opt.hasModule) {
            assert(req.params.mod);
            modName = S(req.params.mod).camelize();
            nodes.push(modName);
            mvc.moduleName = modName;
        }

        ctrlName = S(req.params.ctrl ? req.params.ctrl : opt.defaultController).camelize();
        nodes.push(ctrlName);
        mvc.controllerName = ctrlName;

        var ctrlRelPath = nodes.join('/');
        if (ctrlRelPath.indexOf('..') != -1) throw new Error('Request URI ['+ req.path +'] contains disallowed symbol "..".', 400);

        mvc.controllerPath = ctrlRelPath;

        var ctrlPath = path.join(root, opt.controllerPath, ctrlRelPath),
            innerAction, actName;

        try {
            var controller = require(ctrlPath);
            actName = S(req.params.act ? req.params.act : opt.defaultAction).camelize();
        } catch (error) {
            console.log(error.message);
            console.log(req.originalUrl);
            throw new Error('Page not found!', 404);
        }

        innerAction = controller[opt.splitPostAction && req.route.method == 'post' ? actName + 'Postback' : actName];
        if (typeof innerAction != 'function') {
            throw new Error('Page not found!', 404);
        }

        mvc.actionName = actName;
        mvc.actionPath = ctrlRelPath + '/' + actName;
        req['mvc'] = mvc;

        return innerAction(req, res);
    };

    var r;

    if (opt.hasModule) {
        r = path.join(route, '/:mod/:ctrl/:act');
        app.get(r, setViewPath, action);
        app.post(r, setViewPath, action);

        r = path.join(route, '/:mod/:ctrl');
        app.get(r, setViewPath, action);
        app.post(r, setViewPath, action);

        r = path.join(route, '/:mod');
        app.get(r, setViewPath, action);
        app.post(r, setViewPath, action);
    } else {
        r = path.join(route, '/:ctrl/:act');
        app.get(r, setViewPath, action);
        app.post(r, setViewPath, action);

        r = path.join(route, '/:act');
        app.get(r, setViewPath, action);
        app.post(r, setViewPath, action);

        r = route;
        app.get(r, setViewPath, action);
        app.post(r, setViewPath, action);
    }
};