var authImpl = module.exports = {};

authImpl.authenticate = function (req, res, namespace, onAuthenticated, onAuthFailed) {

    var options = auth.getNamespaceOptions(namespace),
        username = req.body.username,
        password = req.body.password,
        vcode = req.body.v_code;

    var Db = require('mongodb').Db;
    var MongoClient = require('mongodb').MongoClient;
    var Server = require('mongodb').Server;
    var BSON = require('mongodb').BSON;
    var ObjectID = require('mongodb').ObjectID;

    MongoClient.connect("mongodb://kitmidbo:passwd4kmimg@172.16.250.131:7000/kitmi", function(err, db) {
        if (err) { console.dir(err); return; }

        console.log("Connected to mongodb.");

        db.collection("users").findOne({username: username}, function(err, result) {
            if (err) { console.dir(err); return; }

            var error, data;

            if (result) {
                if (result.password == password) {
                    var fields = auth.getNamespaceOption(namespace, 'fieldsInSession') || ['username'];
                    data = _.pick(result, fields);
                } else {
                    error = 'invalid_credential';
                }
            } else {
                error = 'identity_not_found';
            }

            db.close();

            if (error) {
                onAuthFailed(error);
            } else {
                onAuthenticated(data);
            }
        });
    });
};