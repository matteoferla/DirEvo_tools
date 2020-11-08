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
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootswatch/4.5.0/darkly/bootstrap.min.css" integrity="sha384-Bo21yfmmZuXwcN/9vKrA5jPUMhr7znVBBeLxT9MA4r2BchhusfJ6+n8TLGUcRAtL" crossorigin="anonymous" id="theme_CSS">

    <!--Fontawesome-->
    <link rel="stylesheet"
          href="/static/Font-Awesome-Pro/css/all.min.css">
    <!-- was bootstrap-theme-->
    <link href="/static/bs-callout.css"
          rel="stylesheet">
    <!--slider-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/11.0.2/css/bootstrap-slider.min.css"
          rel="stylesheet">
    <!--switch-->
    ##<link href="/static/bootstrap-switch/dist/css/bootstrap3/bootstrap-switch.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-switch/3.3.4/js/bootstrap-switch.min.js" integrity="sha512-J+763o/bd3r9iW+gFEqTaeyi+uAphmzkE/zU8FxY6iAvD3nQKXa+ZAWkBI9QS9QkYEKddQoiy0I5GDxKf/ORBA==" crossorigin="anonymous"></script>
    <link href="/static/bootstrap-select.min.css"
          rel="stylesheet">
    <!--pyspinner-->
    <link href="/static/pyspinner.css"
          rel="stylesheet">
    <!--main CSS-->
    <link rel="stylesheet" href="/static/sitewide.css">
    <!--tour-->
    % if 'tour' in page.requirements:
        ## <link rel="stylesheet" href="/static/bootstrap-tour/build/css/bootstrap-tour.min.css"/>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-tour/0.12.0/js/bootstrap-tour.min.js" integrity="sha512-kcDHM4gaMoZGaCaJ56XjGiknuwMeQFxssvIDnuuCp22PJYO8XvOeMibWtkdZTZtbPXfvLE9WweEVToVtM/wlMw==" crossorigin="anonymous"></script>
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
           href="#">DirEvo Tools</a>
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
                                <a data-toggle="modal" data-target="#overview_modal" style="cursor:pointer" class="btn btn-success my-1" id="overview"><i class="far fa-map"></i> Information</a>
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
                            <a href='#social_modal' class="btn btn-info my-1" id="twitter"
                            data-toggle="modal" data-target="#social_modal" style="cursor:pointer"
                            ><i class="fab fa-blogger-b"></i> Various links</a>
                            <a href='#cite_modal' class="btn btn-info my-1" id="cite"
                            data-toggle="modal" data-target="#cite_modal" style="cursor:pointer"
                            ><i class="far fa-scroll-old"></i> Citation</a>
                            <a href='https://github.com/matteoferla/DirEvo_tools' class="btn btn-info my-1" id="github" target="_blank"><i class="fab fa-github"></i> Github</a>
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

<div class="modal" id="cite_modal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="comment_title">Citations</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" id="comment_body">
                <p>This site contains several tools with different citations.</p>
                <ul class="fa-ul">
                    <li><span class="fa-li"><i class="far fa-magic"></i></span><b>Various tools</b> to be published</li>
                    <li><span class="fa-li"><i class="far fa-scanner"></i></span><b>Deepscan and Mutant primers</b> Acevedo-Rocha CG, Ferla M, Reetz MT. Directed Evolution of Proteins Based on Mutational Scanning. Methods Mol Biol. 2018;1685:87-128. doi:<a href="https://dx.doi.org/10.1007/978-1-4939-7366-8_6" target="_blank">10.1007/978-1-4939-7366-8_6 <i class="far fa-external-link"></i></a></li>
                  <li><span class="fa-li"><i class="far fa-money-bill-wave"></i></span><b>Quick quality control</b> Acevedo-Rocha CG, Reetz MT, Nov Y. Economical analysis of saturation mutagenesis experiments. Sci Rep. 2015;5:10654. Published 2015 Jul 20. doi:<a href="https://dx.doi.org/10.1038/srep10654" target="_blank">10.1038/srep10654 <i class="far fa-external-link"></i></a></li>
                  <li><span class="fa-li"><i class="far fa-dna"></i></span><b>Mutanalyst</b> Ferla MP. Mutanalyst, an online tool for assessing the mutational spectrum of epPCR libraries with poor sampling. BMC Bioinformatics. 2016;17:152. Published 2016 Apr 4. doi:<a href="https://dx.doi.org/10.1186/s12859-016-0996-7"  target="_blank">10.1186/s12859-016-0996-7 <i class="far fa-external-link"></i></a></li>
                <li><span class="fa-li"><i class="far fa-bicycle"></i></span><b>Pedel</b> Patrick WM, Firth AE, Blackburn JM. User-friendly algorithms for estimating completeness and diversity in randomized protein-encoding libraries. Protein Eng. 2003;16(6):451-457. doi:<a href="https://dx.doi.org/10.1093/protein/gzg057" target="_blank">10.1093/protein/gzg057 <i class="far fa-external-link"></i></a></li>
                  <li><span class="fa-li"><i class="far fa-biking-mountain"></i></span><b>PedelAA and Glue-it</b> Firth AE, Patrick WM. GLUE-IT and PEDEL-AA: new programmes for analyzing protein diversity in randomized libraries. Nucleic Acids Res. 2008;36(Web Server issue):W281-W285. doi:<a href="https://dx.doi.org/10.1093/nar/gkn226" target="_blank">10.1093/nar/gkn226 <i class="far fa-external-link"></i></a></li>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="modal" id="social_modal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="overview_title">Overview</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" id="overview_body">
                <p>Links to academic resources and academic social media presence of the authors</p>
                <div class="list-group list-group-flush">
  <a href="https://blog.matteoferla.com/" class="list-group-item list-group-item-action" target="_blank">
    Matteo Ferla's Blog
  </a>
  <a href="https://twitter.com/CaGuAcRo1" class="list-group-item list-group-item-action" target="_blank">
    Carlos Acevedo-Rocha's Twitter
  </a>
  <a href="https://www.matteoferla.com" class="list-group-item list-group-item-action" target="_blank">
    Matteo Ferla's homepage
  </a>
  <a href="https://michelanglo.sgc.ox.ac.uk" class="list-group-item list-group-item-action" target="_blank">
    Michelanglo (create, edit and share interactive protein views)
  </a>
  <a href="https://twitter.com/matteoferla" class="list-group-item list-group-item-action" target="_blank">
    Matteo Ferla's Twitter (inactive)
  </a>



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
          src="https://code.jquery.com/jquery-3.5.1.min.js"
          integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
          crossorigin="anonymous"></script>

    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.bundle.min.js" integrity="sha384-1CmrxMRARb6aLqgBO7yyAxTOQE2AKb9GfXnEo760AUcUmFx3ibVJJAzGytlQcNXd" crossorigin="anonymous"></script>
    <!--<script type='text/javascript' src="/static/bootstrap/dist/js/bootstrap.min.js"></script> -->
    <script type='text/javascript'
            src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/11.0.2/bootstrap-slider.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap-switch@3.4.0/dist/js/bootstrap-switch.min.js"></script>
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
        ## <script src="/static/bootstrap-tour/build/js/bootstrap-tour.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-tour/0.12.0/js/bootstrap-tour.min.js" integrity="sha512-kcDHM4gaMoZGaCaJ56XjGiknuwMeQFxssvIDnuuCp22PJYO8XvOeMibWtkdZTZtbPXfvLE9WweEVToVtM/wlMw==" crossorigin="anonymous"></script>
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