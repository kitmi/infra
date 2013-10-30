{% extends 'common.swig' %}
{% import 'bootstrap/breadcrumb' as breadcrumb %}
{% block banner %}
<div class="current-location">
    <div class="container">
        <div class="row">
            <div class="offset1 span10">
                <div class="current-location-links">
                    <div class="pull-left">
                        <div><h3>{{ title }}</h3></div>
                        {{ breadcrumb.component(parentNodes, title) }}
                    </div>
                    <div class="pull-right">
                        <br>
                        <a href="http://www.kitmi.com.au"><img src="/images/home-icon.png"></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
{% endblock %}