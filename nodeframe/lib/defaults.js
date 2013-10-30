var path = require('path'),
    root = path.dirname(process.argv[1]);

module.exports = {
    staticContentPath: path.join(root, 'public'),
    appPath: path.join(root, 'app'),
    viewPath: path.join(root, 'views'),

    accessLogFile: path.join(root, 'log/access.log'),

    uiLibrary: 'bootstrap',

    sessionStore: 'mongodb',
    sessionSecret: 'Golf-R',

    adminRoute: '/admin',
    adminAuthNamespace: 'admin',

    port: 3000,
    portSsl: 3001
};