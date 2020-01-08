<!DOCTYPE html>
    <%page args="request, page, scheme='http', port=8080"/>
## change to  scheme='http', port=8080
<html lang="${request.locale_name}">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Mutagenesis tools">
    <meta name="author" content="Matteo Ferla et al.">
    <link rel="icon" type="image/png" sizes="16x16"
          href="/static/favicon-16x16.png">
    <link rel="icon" type="image/png" sizes="96x96"
          href="/static/favicon-96x96.png">
    <title>Pedel revamp</title>
    <!-- Bootstrap core CSS-->
    <link rel="stylesheet" href="/static/bootswatch/dist/darkly/bootstrap.min.css" id="theme_CSS">
    <!--Fontawesome-->
    <link rel="stylesheet"
          href="/static/Font-Awesome-Pro/css/all.min.css">
    <!-- was bootstrap-theme-->
    <link href="/static/bs-callout.css"
          rel="stylesheet">
    <!--slider-->
    <link href="/static/bootstrap-slider/dist/css/bootstrap-slider.min.css"
          rel="stylesheet">
    <!--switch-->
    <link href="/static/bootstrap-switch/dist/css/bootstrap3/bootstrap-switch.min.css"
          rel="stylesheet">
    <link href="/static/bootstrap-select.min.css"
          rel="stylesheet">
    <!--pyspinner-->
    <link href="/static/pyspinner.css"
          rel="stylesheet">
    <!--main CSS-->
    <link rel="stylesheet" href="/static/sitewide.css">
    <!--tour-->
    % if 'tour' in page.requirements:
        <link rel="stylesheet" href="/static/bootstrap-tour/build/css/bootstrap-tour.min.css"/>
    % endif
    <!--
        <style>
            div {border:1px solid black;}
        </style> -->
</head>
<body style="padding-top: 60px;">
<%def name='collapse_section(name,title, text=None, file=None)'>
    <div id="${name}">
                <h4>${title|n} (
                <a data-toggle="collapse" href="#${name} .collapse">
                    <span class="collapse show"><i class="fa fa-caret-down" aria-hidden="true"></i> show</span>
                    <span class="collapse"><i class="fa fa-caret-up" aria-hidden="true"></i> hide</span>
                </a>
                )

            </h4>
            <div class="collapse">
                % if file:
                    <%include file="${file}" args="page=page"/>
                % elif text:
                    ${text|n}
                % else:
                    ERROR
                % endif
            </div>
    </div>
</%def>
<!-- Fixed navbar -->
<nav class="navbar navbar-light bg-light fixed-top navbar-expand-md">
    <div class="container">
        <button type="button" class="navbar-toggler collapsed" data-toggle="collapse"
                data-target="#navbar" aria-expanded="false" aria-controls="navbar"><span class="sr-only">Toggle navigation</span>
            &#x2630;
        </button>
        <a class="navbar-brand"
           href="#">Pedel Redux</a>
        <div id="navbar" class="navbar-collapse collapse">
            <ul class="nav navbar-nav">
                <li class="${page.m_home} nav-item"><a href="/" class="nav-link">Home</a>
                </li>
                <!--
                <li class="dropdown nav-item">
                    <a href="#" class="dropdown-toggle nav-link" data-toggle="dropdown"
                       role="button"
                       aria-haspopup="true" aria-expanded="false">
                        Primers <span
                            class="caret"></span></a>
                    <div
                            class="dropdown-menu">
                        <a class="${page.m_mutantprimers} dropdown-item"
                                href="/main/mutantprimers">
                            Mutantprimers
                        </a>
                        <a class="${page.m_deepscan} dropdown-item" href="/main/deepscan">
                            Deepscan
                        </a>
                    </div>
                </li>-->
                <li class="dropdown nav-item"><a href="#" class="dropdown-toggle nav-link" data-toggle="dropdown"
                                                 role="button"
                                                 aria-haspopup="true" aria-expanded="false">epPCR <span
                        class="caret"></span></a>
                    <div
                            class="dropdown-menu">
                        <a class="${page.m_planner} dropdown-item" href="/main/planner">Planner
                        </a>
                        <a class="${page.m_mutantcaller} dropdown-item" href="/main/mutantcaller">MutantCaller
                        </a>
                        <a class="${page.m_mutanalyst} dropdown-item" href="/main/mutanalyst">Mutanalyst
                        </a>
                        <a class="${page.m_pedelclassic} dropdown-item" href="/main/pedel-classic">Pedel classic
                        </a>
                        <a class="${page.m_pedelAA} dropdown-item" href="/main/pedelAA">Pedel AA
                        </a>
                        <!--
                        <a class="${page.m_probably} dropdown-item" href="/main/probably">Chances
                        </a>
                        <a role="separator" class="divider dropdown-item"></a>
                        <a class="${page.m_silico} dropdown-item" href="/main/silico">Generator
                        </a>-->
                    </div>
                </li>
                <li class="${page.m_glue} nav-item"><a href="/main/glue" class="nav-link">Glue</a>
                </li>
                <li class="${page.m_driver} nav-item"><a href="/main/driver" class="nav-link">Driver</a>
                </li>
                <li class="${page.m_QQC} nav-item"><a href="/main/QQC" class="nav-link">QQC</a>
                </li>
                <!--<li class="${page.m_landscape} nav-item"><a href="/main/landscape" class="nav-link">Landscape</a>
                </li>-->
                <!--<li class="${page.m_misc} nav-item"><a href="/main/misc" class="nav-link">Miscellaneous</a>-->
                </li>
            </ul>
            <ul class="nav navbar-nav ml-auto">





                    % if page.admin:
                        <li class="nav-item dropdown">
                            <a href="#" class="dropdown-toggle nav-link" data-toggle="dropdown"
                                                 role="button"
                                                 aria-haspopup="true" aria-expanded="false">
                        Change theme <span class="caret"></span></a>
                    <div class="dropdown-menu" id="themeSelector"></div>
                </li>
                    % endif
                <li class="nav-item dropdown">
                    <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown"
                                                 role="button"
                                                 aria-haspopup="true" aria-expanded="false">About <span
                        class="caret"></span></a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item ${page.m_about}" href="/main/about">About
                        </a>
                        <a class="dropdown-item ${page.m_glossary}" href="/main/glossary">FAQ
                        </a>
                        <a class="dropdown-item ${page.m_admin}" href="/admin">Admin
                        </a>
                        <a class="dropdown-item ${page.m_upcoming}" href="/upcoming">Upcoming
                        </a>
                    </div>
                </li>
            </ul>
        </div>
        <!--/.nav-collapse -->
    </div>
</nav>
<br>

<!--MODAL for scheme. not activated on all pages!-->
    % if page.codon_flag:
        <%include file="codon_modal.mako" args="page=page, collapse_section=collapse_section"/>
    % endif
<!--Main -->
<div class="container-fluid" id="fullpage">
    <!--welcome box-->
    <div class="section">
        <div class="row" id="${page.page_name}">
            <div class="col-lg-8 offset-lg-1">
                %if page.status:
                    <div class="alert alert-${page.status_class} alert-dismissible fade show" role="alert">
                        <h4 class="alert-heading">${page.status_class.capitalize()}</h4>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        ${page.status_msg |n}

                    </div>
                %endif

                %if page.error:
                    <div class="card">
                        <div class="card-body">
                            <h2 class="card-title">Holy cow, Batman!</h2>
                            <h3 class="card-subtitle">We got a server-side error preparing your page!</h3>
                            <p class="card-text">If you are a user (and did not type a made up address), I am sorry. <br/>
                                This really should not have happened.<br/>
                            </p>
                            <pre>
                          <code>
                              ${page.error}
                          </code>
                      </pre>
                        </div>
                    </div>
                %endif
                %if page.body:
                    <%include file="${page.body}" args="page=page, collapse_section=collapse_section "/>
                %endif
            </div>
            <div class="col-lg-2">
                <div class="position-fixed vertical-center">
                    <div class="card" style="min-height: 70vh" id="navigation">
                        <div class="card-header">Navigation</div>
                        <div class="card-body">
                        <div class="d-flex flex-column">
                            %if 'tour' in page.requirements:
                                <a href='#' class="btn btn-success my-1" id="tour"><i class="far fa-compass"></i> Tutorial</a>
                            %endif
                            %if page.overview:
                                <a data-toggle="modal" data-target="#overview_modal" style="cursor:pointer" class="btn btn-success my-1" id="overview"><i class="far fa-map"></i> Background</a>
                            %endif
                            %if page.notes:
                                %for note_file,note_title in page.notes:
                                    <a href='#' class="btn btn-success my-1" id="background"><i class="far fa-sticky-note"></i> Notes</a>
                                %endfor
                            %endif
                            %if page.avanti:
                                <a data-toggle="modal" data-target="#avanti_modal" style="cursor:pointer"  class="btn btn-success my-1" id="feedback"><i class="far fa-forward"></i> Next</a>
                            %endif
                            <hr/>
                            <a data-toggle="modal" data-target="#comment_modal" style="cursor:pointer"  class="btn btn-warning my-1" id="feedback"><i class="far fa-comment"></i> Feedback</a>
                            <hr/>
                            <a href='#' class="btn btn-info my-1" id="twitter"><i class="fab fa-twitter"></i> Twitter</a>
                            <a href='#' class="btn btn-info my-1" id="blogger"><i class="fab fa-blogger-b"></i> Blog</a>
                            <a href='https://github.com/matteoferla/pedel2' class="btn btn-info my-1" id="github" target="_blank"><i class="fab fa-github"></i> Github</a>
                </li>
                        </div>




                      </div>
                    </div>
                </div>
            </div>
        </div>
        % if full_width_text:
            ${page.full_width_text |n}
        % endif
    </div>
</div>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<!--footer-->
<div class="navbar navbar-light bg-light navbar-fixed-bottom" id="footer">
    <div class="nav navbar-nav navbar-center">
        <p class="text-muted"><b>GDPR statement</b>: No marketing. No 3rd party. Data you submit is
            kept for debugging purposes.</p>
    </div>
    <div class="nav navbar-nav navbar-right">
        <button type="button" class="close" aria-label="Close"><span aria-hidden="true">&#xD7;</span>
        </button>
    </div>
</div>
<!-- Modal for comment /feedback -->
<div class="modal" id="comment_modal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="comment_title">Send Comment</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" id="comment_body">
                <div class="input-group"><span class="input-group-addon" id="basic-addon1">Name (optional)</span>
                    <input
                            id="comment_name" type="text" class="form-control" placeholder="Name"
                            aria-describedby="name">
                </div>
                <br>
                <textarea id="comment_msg" rows="5" style="width:100%;" placeholder="Message"></textarea>
                <br>
                <div id="comment_status"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="comment_send">Send</button>
                </div>
            </div>
        </div>
    </div>
</div>

% if page.overview:
    <!-- Modal for overview -->
<div class="modal" id="overview_modal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="overview_title">Overview</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" id="overview_body">
                <%include file="${page.overview}" args="page=page"/>
            </div>
        </div>
    </div>
</div>
% endif

% if page.avanti:
    <!-- Modal for next/avanti -->
<div class="modal" id="avanti_modal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="avanti_title">Where to from here?</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" id="overview_body">
                <%include file="${page.avanti}" args="page=page"/>
            </div>
        </div>
    </div>
</div>
% endif


<js_code>
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="//oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->

    <script
            src="https://code.jquery.com/jquery-3.2.1.min.js"
            integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
            crossorigin="anonymous"></script>

    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.bundle.min.js"
            integrity="sha384-pjaaA8dDz/5BgdFUPX6M/9SUZv4d12SUPF0axWc+VRZkx5xU3daN+lYb49+Ax+Tl"
            crossorigin="anonymous"></script>
    <!--<script type='text/javascript' src="/static/bootstrap/dist/js/bootstrap.min.js"></script> -->
    <script type='text/javascript'
            src="/static/bootstrap-slider/dist/bootstrap-slider.min.js"></script>
    <script type='text/javascript'
            src="/static/bootstrap-switch/dist/js/bootstrap-switch.min.js"></script>
    <script type='text/javascript' src="/static/FileSaver.min.js"></script>
    <script type='text/javascript'
            src="/static/bootstrap-select.min.js"></script>
    <script type='text/javascript'
            src="/static/sitewide.js"></script>
    <!--copied from https://stackoverflow.com/questions/19192747/how-to-dynamically-change-themes-after-clicking-a-drop-down-menu-of-themes-->
    % if 'plotly' in page.requirements:
        <script type='text/javascript' src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    % endif
    % if 'math' in page.requirements:
        <script src='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML' async></script>
    % endif
    % if 'tour' in page.requirements:
        <script src="/static/bootstrap-tour/build/js/bootstrap-tour.min.js"></script>
    % endif

    <script>


        (function (i, s, o, g, r, a, m) {
            i['GoogleAnalyticsObject'] = r;
            i[r] = i[r] || function () {
                (i[r].q = i[r].q || []).push(arguments)
            }, i[r].l = 1 * new Date();
            a = s.createElement(o),
                    m = s.getElementsByTagName(o)[0];
            a.async = 1;
            a.src = g;
            m.parentNode.insertBefore(a, m)
        })(window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga');

        ga('create', 'UA-66652240-4', 'auto');
        ga('send', 'pageview');

        $(document).ready(function () {
            if (window.localStorage.getItem('GDPR') == 1) {
                $("#footer").hide();
            }
            $("#footer").click(function () {
                $("#footer").hide();
                window.localStorage.setItem('GDPR', 1)
            });

            %if page.code:
                <%include file="${page.code}" args="page=page"/>
            %endif
            % if page.tour:
                <%include file="${page.tour}" args="page=page"/>
            % endif
        });

    </script>
</js_code>
</body>
</html>