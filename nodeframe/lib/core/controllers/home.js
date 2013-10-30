/*
 * GET home page.
 */

exports.index = function(req, res) {
   auth.requireSignedIn(req, res, config.adminAuthNamespace);

   config.dir(res.locals);

   res.send('ok.');
};

exports.signIn = function(req, res) {
    var mvc = req.mvc;

    if (req.cookies.username) {
        res.render(mvc.actionPath, {formData: {remember_me: 1, username: req.signedCookies.username}});
    } else {
        res.render(mvc.actionPath, {});
    }
};

exports.signInPostback = function(req, res) {
    if (req.body.remember_me) {
        res.cookie('username', req.body.username);
    } else {
        res.clearCookie('username');
    }

    auth.authenticate(req, res, 'admin', 'mongo-password', function(req, res, data){ //已登录

        Auth.setIdentity(req, config.adminAuthNamespace, data);

        var returnUrl = req.query.from || req.mvc.route();

        res.redirect(returnUrl);

    }, function(req, res, error){ //登录失败

        res.send(error);

    });
};

exports.signOut = function(req, res){
    auth.clearIdentity(req, config.adminAuthNamespace);

    res.redirect(req.mvc.route('sign-in'));
};

