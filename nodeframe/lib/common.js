/**
 * Global initialization
 * @param app
 * @param config
 */
exports.initOnce = function(app, config) {

    var mongoose = require('mongoose');
    mongoose.connect(config.mongoConnection);

    var db = mongoose.connection;
    db.on('error', console.error.bind(console, 'MongoDB connection error:'));
    db.once('open', function callback () {
        console.log('Connected to MongoDB successfully.');
    });
};

