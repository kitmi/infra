var Auth = module.exports = {};

var namespaceDefaults = {};

Auth.setNamespaceOptions = function (namespace, defaults) {
    namespaceDefaults[namespace] = _.extend({}, defaults);
};

Auth.getNamespaceOptions = function (namespace) {
    return namespaceDefaults[namespace];
};

Auth.getNamespaceOption = function (namespace, key) {
    return namespaceDefaults[namespace] ? namespaceDefaults[namespace][key] : null;
};

Auth.require = function(req, res, info, onRequireFailed) {

    var session = req.session,
        authData = session && session.auth,
        requirement = _.extend({namespace: ''}, info),
        namespace = requirement.namespace,
        type = requirement.type;

    function _onRequireFailed(error) {

        onRequireFailed = onRequireFailed || Auth.getNamespaceOption(namespace, 'onRequireFailed');

        if (onRequireFailed) {
            return onRequireFailed(req, res, error);
        }

        throw new Error(error);
    }

    if (!authData) {
        return _onRequireFailed('auth_not_init');
    }

    if (!authData[namespace]) {
        return _onRequireFailed('auth_not_found');
    }

    authData = authData[namespace];

    if (requirement.role) {
        var roleData = session.role;

        if (!roleData) {
            return _onRequireFailed('role_not_init');
        }

        var roles = requirement.role.split(',');
        if (_.isEmpty(_.intersection(roleData, roles))) {
            return _onRequireFailed('role_unauthorized');
        }
    }

    if (requirement.handler) {//handler specified
        return requirement.handler(authData, roleData);
    }

    return true;
};

Auth.requireSignedIn = function(req, res, namespace, onRequireFailed) {
    return Auth.require(req, res, { namespace: namespace }, onRequireFailed);
};

Auth.requireRole = function(req, res, namespace, role, onRequireFailed) {
    return Auth.require(req, res, { namespace: namespace, role: role }, onRequireFailed);
};

Auth.authenticate = function(req, res, namespace, type, onAuthenticated, onAuthFailed) {

    function _onAuthenticated(data) {
        var session = req.session,
            oldData = session && session.auth,
            setExtraData = Auth.getNamespaceOption('setExtraData');

        if (setExtraData) {
            setExtraData(req, data);
        }

        data['_nfa_type'] = type;

        if (!oldData) {
            oldData = {};
            oldData[namespace] = data;
            session.auth = oldData;
        } else {
            oldData[namespace] = data;
        }

        onAuthenticated = onAuthenticated || Auth.getNamespaceOption(namespace, 'onAuthenticated');

        return onAuthenticated(req, res, data);
    }

    function _onAuthFailed(error) {
        var session = req.session,
            authData = session && session.auth;

        if (authData && authData[namespace]) {
            delete authData[namespace][type];
        }

        onAuthFailed = onAuthFailed || Auth.getNamespaceOption(namespace, 'onAuthFailed');

        return onAuthFailed(req, res, error);
    }

    try {
        var specifiedAuth = require('./auth_modules/' + type + '.js');
        specifiedAuth.authenticate(req, res, namespace, _onAuthenticated, _onAuthFailed);
    } catch (error) {
        console.log(error.message);
        throw new Error('Auth module not found!', 500);
    }

};

Auth.clearIdentity = function (req, namespace) {
    var session = req.session,
        authData = session && session.auth,
        onClearIdentity = Auth.getNamespaceOption('onClearIdentity');

    if (authData && authData[namespace]) {
        if (onClearIdentity) {
            onClearIdentity(req, authData[namespace]);
        }
        delete authData[namespace];
    }
};
