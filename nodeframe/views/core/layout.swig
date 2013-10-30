<!DOCTYPE html>
<html lang="{{ locale }}">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="keywords" content="">
    <meta name="description" content="">
    <title>{{ title }}</title>

    <!-- styles -->
    <link href="/lib/bootstrap/css/bootstrap.css" rel="stylesheet">
    <link href="/lib/bootstrap/css/bootstrap-responsive.css" rel="stylesheet">
    <link href="/nodeframe/core/theme/default/style.css" rel="stylesheet">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
    <script src="/lib/html5.min.js"></script>
    <![endif]-->
    <!-- Respond, for IE6-8 support of viewport width -->
    <!--[if lt IE 9]>
    <script src="/lib/respond.min.js"></script>
    <![endif]-->

    <!-- Fav and touch icons -->
    <link rel="shortcut icon" href="/images/favicon.ico">
    <link rel="apple-touch-icon" href="/images/apple-touch-icon.png">
    <link rel="apple-touch-icon" sizes="72x72" href="/images/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="114x114" href="/images/apple-touch-icon-114x114.png">
  </head>

  <body>
    {% block content %}{% endblock %}

    <script src="/lib/jquery/jquery-1.10.1.min.js"></script>
    <script src="/lib/bootstrap/js/bootstrap.min.js"></script>
    <script src="/lib/require.js"></script>
    <script src="/lib/underscore-min.js"></script>
{% block extraFooterScript %}{% endblock %}
    <script type="text/javascript">
        $(function (){
{% block docReadyScript %}{% endblock %}
        });
    </script>
  </body>
</html>