var _ = require("underscore"),
    S = require("string"),
    path = require("path"),
    root = path.dirname(process.argv[1]),
    assert = require('better-assert');

function Rest(app, route) {
    this.app = app;
    this.baseRoute = route;
    this.id = Math.random();
}

/**
 * Constructs a URL path based on the route base
 * @param relativeUrl
 * @returns {*}
 */
Rest.prototype.route = function(relativeUrl) {
    return path ? path.join(this.baseRoute, relativeUrl) : this.baseRoute;
};

Rest.prototype.render = function(req, res, model) {
    var data = _.isFunction(model) ? model(req) : model;
    res.render(this.actionPath, data);
};

/**
 * Mount for rest routing
 * @param app
 * @param route
 * @param opt {view, model, controllerPath, viewPath}
 */
exports.mount = function(app, route, opt) {
    var rest = new Rest(app, route);

    opt = _.extend({
        hasModule: false,
        servicePath: 'services'
    }, opt);

    var method = function(req, res) {
        var nodes = [], modName, serviceName;
        if (opt.hasModule) {
            assert(req.params.mod);
            modName = S(req.params.mod).camelize();
            nodes.push(modName);
            rest.moduleName = modName;
        }

        assert(req.params.svc);
        serviceName = S(req.params.svc).camelize();
        nodes.push(serviceName);
        rest.serviceName = serviceName;

        var svcRelPath = nodes.join('/');
        if (svcRelPath.indexOf('..') != -1) throw new Error('Request URI ['+ req.path +'] contains disallowed symbol "..".', 400);

        rest.servicePath = svcRelPath;

        var ctrlPath = path.join(root, opt.servicePath, svcRelPath),
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

        rest.actionName = actName;
        rest.actionPath = svcRelPath + '/' + actName;
        req['rest'] = rest;

        return innerAction(req, res);
    };

    var r;

    if (opt.hasModule) {
        r = path.join(route, '/:mod/:ctrl/:act');
        app.get(r, setViewPath, method);
        app.post(r, setViewPath, method);

        r = path.join(route, '/:mod/:ctrl');
        app.get(r, setViewPath, method);
        app.post(r, setViewPath, method);

        r = path.join(route, '/:mod');
        app.get(r, setViewPath, method);
        app.post(r, setViewPath, method);
    } else {
        r = path.join(route, '/:ctrl/:act');
        app.get(r, setViewPath, method);
        app.post(r, setViewPath, method);

        r = path.join(route, '/:act');
        app.get(r, setViewPath, method);
        app.post(r, setViewPath, method);

        r = route;
        app.get(r, setViewPath, method);
        app.post(r, setViewPath, method);
    }
};