var authImpl = module.exports = {};

authImpl.authenticate = function (req, res, namespace, onAuthenticated, _onAuthFailed) {

    var username = req.body.username,
        password = req.body.password,
        vcode = req.body.v_code;




};