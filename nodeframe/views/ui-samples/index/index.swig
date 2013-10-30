<!DOCTYPE html>
<html lang="{{ locale }}">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="keywords" content="nodeframe, ui-samples">
    <meta name="description" content="nodeframe ui-samples">
    <title>nodeframe bootstrap ui-samples</title>

    <!-- styles -->
    <link href="/lib/bootstrap3/css/bootstrap.min.css" rel="stylesheet">
    <link href="/lib/bootstrap3/css/bootstrap-theme.min.css" rel="stylesheet">

    <!--[if lt IE 9]>
    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <script src="/js/html5.min.js"></script>
    <!-- Respond, for IE6-8 support of viewport width -->
    <script src="/js/respond.min.js"></script>
    <![endif]-->

    <!-- Fav icons -->
    <link rel="shortcut icon" href="/images/favicon.ico">
  </head>

  <body>
    <div class="container">
        <div class="row">
            <div class="col-md-2">ui.hello()</div>
            <div class="col-md-10">
                {{ ui.hello() }}
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">ui.link()</div>
            <div class="col-md-10">
                {{ ui.link(null, 'This is a link.') }}
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">ui.label()</div>
            <div class="col-md-10">
                <hr>
                {{ ui.label('lb_default', 'default') }}&nbsp;
                {{ ui.label('lb_primary', 'primary') }}&nbsp;
                {{ ui.label('lb_success', 'success') }}&nbsp;
                {{ ui.label('lb_info', 'info') }}&nbsp;
                {{ ui.label('lb_warning', 'warning') }}&nbsp;
                {{ ui.label('lb_danger', 'danger') }}&nbsp;
                <hr>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">ui.button()</div>
            <div class="col-md-10">
                {{ ui.button('Button') }} &nbsp;
                {{ ui.button('Primary', '/test', 'primary') }} &nbsp;
                {{ ui.button('Info', '/test', 'info') }} &nbsp;
                {{ ui.button('Success', '/test', 'success') }} &nbsp;
                {{ ui.button('Warning', '/test', 'warning') }} &nbsp;
                {{ ui.button('Danger', '/test', 'danger') }} &nbsp;
                {{ ui.button('Link', '/test', 'link') }} &nbsp;
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">ui.form()</div>
            <div class="col-md-10">
{%
set fields = [
        { type:'input', name:'username', icon: 'user', required: true, attrs: {} },
        { type:'input', name:'password', icon: 'asterisk', required: true, attrs: {type: 'password'} },
        { type:'checkbox', name:'remember_me', options:{ 1:__('Remember me') } },
        { type:'button', name:'sign_in', inline: true, attrs: {type: 'submit', class: 'btn btn-success'} },
        { type:'link', name:'forgot password?', attrs: {href: '#'} }
    ]
%}
                {{ ui.form(fields, {}, {showRequired: false, title: 'Sign In'}, {}) }}
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">ui.nav(..., 'tabs')</div>
            <div class="col-md-10">
{%
set navItems = [
        { label:'Menu1', value:'/menu1' },
        { label:'Menu2', value:'/menu2' },
        { label:'Menu3', value:'/menu3' },
        { label:'Menu4', value:'/menu4' },
        { label:'Menu5', value:'/menu5' }
    ]
%}
                {{ ui.nav(navItems, {}, 1, 'tabs') }}
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">ui.nav(..., 'pills')</div>
            <div class="col-md-10">
                {{ ui.nav(navItems, {}, 1, 'pills') }}
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">ui.nav(..., 'justified')</div>
            <div class="col-md-10">
                {{ ui.nav(navItems, {}, 1, 'justified') }}
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">ui.nav(...) with dropdown</div>
            <div class="col-md-10">
{%
set navItems2 = [
        { label:'Menu1', value:'/menu1' },
        { label:'Menu2', value:'/menu2' },
        { label:'Menu3', active:3, value:[
            { label:'Sub-Menu1', value:'/smenu1' },
            { label:'Sub-Menu2', value:'/smenu2' },
            { label:'Sub-Menu3', value:'/smenu3' },
            { label:'Sub-Menu4', value:'/smenu4' }
        ] },
        { label:'Menu4', value:'/menu4' },
        { label:'Menu5', value:'/menu5' }
    ]
%}
                {{ ui.nav(navItems2, {}, 1) }}
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">ui.breadcrumb(...)</div>
            <div class="col-md-10">
{%
set locations = [
        { label:'Home', value:'/' },
        { label:'User', value:'/user' },
        { label:'Profile', value:'/user/profile' }
    ]
%}
                {{ ui.breadcrumb(locations) }}
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">ui.pagination(...)</div>
            <div class="col-md-10">
                {{ ui.pagination(6, 20, 5) }}
            </div>
        </div>
    </div>

    <script src="/js/jquery-1.10.1.min.js"></script>
    <script src="/lib/bootstrap3/js/bootstrap.min.js"></script>

{% block extraFooterScript %}{% endblock %}
    <script type="text/javascript">
        $(function (){
{% block docReadyScript %}{% endblock %}
        });
    </script>
  </body>
</html>