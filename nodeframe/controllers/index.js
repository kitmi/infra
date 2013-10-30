/*
 * GET home page.
 */

exports.index = function(req, res){
    var a = require('async'),
        fs = require('fs'),
        mvc = req.mvc;

    a.map(
        ['./views/slides/1.html', './views/slides/2.html'],
        fs.readFile, function (err, results) {
            if (err) throw err;

            res.render(mvc.actionPath, { title: 'Home', page: 'home', items: results });
        });
};

exports.products = function(req, res){
    var mvc = req.mvc;



};

