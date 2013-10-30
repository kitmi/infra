{% extends 'layout.swig' %}
{% block content %}
    <header>
        <div class="navbar-fixed-top">
            <div class="navbar">
              <div class="navbar-inner navbar-height">
                  <div class="container">
                    <div class="row">
                        <div class="offset1 span10">
                            <div class="pull-left">
                                <a target="_blank" class="facebook top" href="http://www.facebook.com/kitmobin" title="Facebook"></a>
                                <a target="_blank" class="linkedin top" href="http://www.linkedin.com/company/kit-mobile-internet-pty-ltd" title="LinkedIn"></a>
                                <a target="_blank" class="twitter top" href="http://twitter.com/kitmobin" title="Twitter"></a>
                            </div>
                        </div>
                    </div>
                  </div>
                </div>
            </div>
            <div class="menu-container">
             <div class="container">
                <div class="row">
                    <div class="offset1 span10">
                        <div id="topMenu">
                           <div class="logo-position">
                               <h1 class="logo-text-hidden">KIT Mobile Internet Pry LTd</h1>
                               <a href="http://www.kitmi.com.au">
                                   <img src="/images/logo_259x100.png">
                               </a>
                           </div>
                           <div class="menu">
                             <ul class="nav nav-pills">
                                 <li id="menu_home"><a href="/">Home</a></li>
                                 <li id="menu_products"><a href="/page/products">Products</a></li>
                                 <li id="menu_solutions"><a href="/page/solutions">Solutions</a></li>
                                 <li id="menu_consulting"><a href="/page/consulting">Consulting</a></li>
                                 <li id="menu_about"><a href="/page/about">About</a></li>
                                 <li id="menu_contact_us"><a href="/page/contact-us">Contact Us</a></li>
                             </ul>
                           </div>
                        </div>
                    </div>
                </div>
             </div>
            </div>
        </div>
    </header>

    {% block banner %}{% endblock %}

    <div class="container-fluid bottom-section">
        <div class="row-fluid">
            <div class="offset2 span8">
                <div class="row-fluid">
                    <div class="span4">
                      <h2>Welcome</h2>
                      <p>Welcome to our website. We’re a busy, independent, Australian-owned mobile software development company and social media marketing services provider called KIT Mobile Internet. We’re based in Sydney, Australia’s largest city, (population 4.7 million). We get up every day excited about solving client problems and doing great work. And we’re good at what we do.</p>
                    </div>
                    <div class="span4">
                      <h2>Recent News</h2>
                      <div class="widgett">
                        <div class="imgholder"><a href="#"><img src="/images/mobile-app.jpg" alt="Offshore mobile apps development"></a></div>
                        <div class="wttitle"><h4><a href="#">Offshore mobile apps development.</a></h4></div>
                      </div>
                      <div class="widgett">
                        <div class="imgholder"><a href="#"><img src="/images/socialcrm-train.jpg" alt="Social CRM"></a></div>
                        <div class="wttitle"><h4><a href="#">Social CRM product will be launched soon.</a></h4></div>
                      </div>
                      <div class="widgett">
                        <div class="imgholder"><a href="#"><img src="/images/office-park.jpg" alt="KIT Mobile Internet Pty Ltd"></a></div>
                        <div class="wttitle"><h4><a href="#">Moved into new office in Hurstville.</a></h4></div>
                      </div>
                   </div>
                    <div class="span4">
                      <h2>Subscription</h2>
                      <p>Get the latest news from us.</p>
                      <div class="input-append">
                        <input type="text" placeholder="Email">
                        <button class="btn" type="button">Submit</button>
                      </div>
                      <p>Thanks for your appreciation!</p>
                      <br>
                      <p><strong>Contact us:</strong><br>
                      <i class="icon-envelope"></i> contactus<script type="text/javascript">document.write('@');</script>kitmi.com.au
                      </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <div class="navbar navbar-inverse navbar-fixed-bottom ">
            <div class="navbar-inner">
                <div class="container">
                    <div class="row">
                        <div class="offset1 span10">
                            <ul class="nav">
                              <li><a href="/page/privacy">Privacy</a></li>
                              <li><a href="/page/terms">Terms</a></li>
                              <li><a href="/page/contact-us">Contact Us</a></li>
                            </ul>
                            <div class="pull-right copyright-text">
                                <span>Copyright &copy; 2013 KIT Mobile Internet Pty Ltd. All rights reserved</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>
{% endblock %}

{% block docReadyScript %}
            $('#menu_{{page}}').addClass('active').find('a').attr('href', '#');
{% endblock %}