{% extends 'common.swig' %}
{% import 'bootstrap/carousel' as carousel %}
{% block banner %}
<div class="banner">
    {{ carousel.component('slides', items) }}
</div>
{% endblock %}