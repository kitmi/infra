
/**
 * Module dependencies.
 */

var express = require('express'),
    https = require('https'),
    http = require('http'),
    swig = require('swig'),
    fs = require('fs'),
    path = require('path'),
    def = require('./lib/defaults'),
    env = require('./etc/env'),
    conf = fs.existsSync(path.join(__dirname, 'etc/config.js')) ? require('./etc/config') : {},
    common = require('./lib/common');

//to be replaced by i18n
global.__ = function(text, values) {
    return text;
};
global._ = require('underscore');
global.config = _.defaults((conf._environment && env in conf._environment) ?
    _.extend(conf, conf._environment[env]) : conf,
    def);
global.auth = require('./lib/auth');

auth.setNamespaceOptions(config.adminAuthNamespace, {
    onRequireFailed: function(req, res, error) {

        console.log(req.originalUrl);
        res.redirect(307, path.join(config.adminRoute, 'sign-in?redirect=' + encodeURIComponent(req.originalUrl)));
    }
});

/**
 * Runtime configuration
 */
console.log("Current working directory: " + process.cwd());
console.log(JSON.stringify(config));

/**
 * Locate Session Store
 * @type {{mongodb: string, redis: string}}
 */
var sessionStoreMap = {mongodb: 'connect-mongo', redis: 'connect-mongo'};
if (!(config.sessionStore in sessionStoreMap)) {
    throw new Error('Invalid session store type ['+ config.sessionStore +']!');
}

var SessionStore = require(sessionStoreMap[config.sessionStore])(express);

var app = express();
app.engine('.swig', swig.renderFile);

// all environments
app.set('env', env);
app.set('views', config.viewPath);
app.set('view engine', 'swig');

// Swig will cache templates for you, but you can disable
// that and use Express's caching instead, if you like:
app.set('view cache', false);
// To disable Swig's cache, do the following:
swig.setDefaults({ cache: false });


//common.initOnce(app, config);
app.use(express.favicon());
app.use(express.logger({stream: fs.createWriteStream(config.accessLogFile, {flags: 'a'}) }));
app.use(express.compress());
app.use(express.static(config.staticContentPath));
app.use(express.methodOverride());
app.use(express.bodyParser());
app.use(express.cookieParser());
app.use(express.session({
    store: new SessionStore(config.sessionStoreOptions),
    secret: config.sessionSecret
}));

// development only
if ('development' == env) {
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
}

app.use(app.router);

var UI;

try {
    var uiLib = './public/lib/nodeframe/ui-' + config.uiLibrary + '.js';
    UI = require(uiLib);
} catch (error) {
    console.log(error.message);
    throw new Error('UI library [' + config.uiLibrary + '] is not found!', 500);
}


// core route settings
var adminRouteSettings = {
    controllerPath: 'lib/core/controllers',
    viewPath: 'views/core',
    defaultController: 'home',
    defaultAction: 'index',
    splitPostAction: true
};

var mvc = require('./lib/mvc');
mvc.mount(app, config.adminRoute, adminRouteSettings);
mvc.mount(app, '/ui-samples', {controllerPath: 'lib/ui-samples', viewPath: 'views/ui-samples'});
//mvc.mount(app, '/');

app.locals({
    locale: 'en-AU',
    const: config.const,
    ui: new UI(),
    __: __,
    mvc: mvc
});

app.all('*', function(req, res){
    console.log(req.originalUrl);
    throw new Error('Page not found!', 404);
});

console.log(app.routes);

http.createServer(app).listen(config.port, function(){
    console.log('Server listening on port [' + config.port + ']');
});

/*
https.createServer(app).listen(config.portSsl, function(){
    console.log('Server listening on SSL port [' + config.portSsl + ']');
});
*/

module.exports = app;