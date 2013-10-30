#!/usr/bin/env coffee
drykup = require 'drykup'

Form = require '../lib/form'

builder = drykup()
form = Form builder

builder.form ->
    form.hidden 'id', 42
    form.text 'name', 'Clark Kent', 'Your Name'
    form.number 'age', 33, 'Your Age'
    professions =
        0: 'Superhero'
        1: 'Villain'
    form.select 'profession', professions, 0
    form.submitButton 'Update your profile'


console.log builder.htmlOut
