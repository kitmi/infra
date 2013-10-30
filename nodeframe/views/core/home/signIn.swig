{% extends 'layout.swig' %}
{% block content %}
<div id="centerForm" class="hero-unit">
{%
set fields = [
        { type:'input', name:'username', icon: 'icon-user', required: true, attrs: {} },
        { type:'input', name:'password', icon: 'icon-asterisk', required: true, attrs: {type: 'password'} },
        { type:'checkbox', name:'remember_me', options:{ 1:__('Remember me') } },
        { type:'button', name:'Sign In', inline: true, attrs: {type: 'submit', class: 'btn btn-success'} },
        { type:'link', name:'forgot password?', attrs: {href: '#'} }
    ]
%}
{{ ui.form(fields, {}, {showRequired: false, title: 'Sign In'}, formData)|raw }}
</div>
{% endblock %}