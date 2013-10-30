/*
 * GET home page.
 */

exports.home =

exports.menu = function(req, res){
    try {
        var menu = req.params.menu;
        if (menu.indexOf('..') != -1) throw new Error('invalid menu');

        var model = require('../models/' + menu);
        res.render(model.view, model.data);
    } catch (error) {
        console.log(error.message);
        res.render('404', { title: '404' });
    }
};

