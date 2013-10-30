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
    <link href="/css/style.css" rel="stylesheet">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
    <script src="/js/html5.min.js"></script>
    <![endif]-->
    <!-- Respond, for IE6-8 support of viewport width -->
    <!--[if lt IE 9]>
    <script src="/js/respond.min.js"></script>
    <![endif]-->

    <!-- Fav and touch icons -->
    <link rel="shortcut icon" href="/images/favicon.ico">
    <link rel="apple-touch-icon" href="/images/apple-touch-icon.png">
    <link rel="apple-touch-icon" sizes="72x72" href="/images/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="114x114" href="/images/apple-touch-icon-114x114.png">
  </head>

  <body>
    {% block content %}{% endblock %}

    <script src="/js/jquery-1.10.1.min.js"></script>
    <script src="/lib/bootstrap/js/bootstrap.min.js"></script>

{% block extraFooterScript %}{% endblock %}
    <script type="text/javascript">
        $(function (){
{% block docReadyScript %}{% endblock %}
        });
    </script>
    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

      ga('create', 'UA-42463086-1', 'kitmi.com.au');
      ga('send', 'pageview');

    </script>
  </body>
</html>