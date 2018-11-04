<!DOCTYPE html>
<html lang="en">
    
    <head>
        <meta charset="UTF-8">
        <title>Epistasis</title>
        <!-- Bootstrap 4 core CSS-->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css"
        integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB"
        crossorigin="anonymous">
        <!--Fontawesome <link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.2.0/css/all.css"
        integrity="sha384-TXfwrfuHVznxCssTxWoPZjhcss/hp38gEOH8UPZG/JcXonvBQ6SlsIF49wUzsGno"
        crossorigin="anonymous">



    solid not working-->
        <link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.2.0/css/solid.css"
        integrity="sha384-B/E/KxBX31kY/5sew+X4c8e6ErosbqOOsA3t4k6VVmx8Hrz//v0tEUtXmUVx9X6Q"
        crossorigin="anonymous">
        <link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.2.0/css/fontawesome.css"
        integrity="sha384-4eP+1rYQmuI3hxrmyE+GT/EIiNbF4R85ciN3jMpmIh+bU5Hz2IU7AdcVe+JS+AJz"
        crossorigin="anonymous">
        <!--pyspinner-->
        <link href="${request.static_url('pyramidstarter:static/pyspinner.css')}"
        rel="stylesheet">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media
        queries -->
        <!--[if lt IE 9]>
        <![endif]-->
        <!---->
        <style>
            .table input {
                display:block;
                width:80%;
                margin-left:auto;
                margin-right:auto;
            }
            div.tooltip {
                position: absolute;
                text-align: center;
                width: 60px;
                height: 28px;
                padding: 2px;
                font: 12px sans-serif;
                background: lightsteelblue;
                border: 0px;
                border-radius: 8px;
                pointer-events: none;
            }
        </style>
    </head>
    
    <body class="bg-light">
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top navbar-expand-md"> <a class="navbar-brand" href="#">Epistasis calculator</a>
            <button class="navbar-toggler"
            type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown"
            aria-expanded="false" aria-label="Toggle navigation"> <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNavDropdown">
                <ul class="navbar-nav">
                    <li class="nav-item"> <a class="nav-link" href="#" target="_blank"><i class="fas fa-book"></i> Underlying paper</a>
                    </li>
                    <li class="nav-item"> <a class="nav-link" href="#" id="mail"><i class="fas fa-envelope"></i> Contact us</a>
                        <!--
                        filled dynamically-->
                    </li>
                    <li class="nav-item dropdown"> <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink"
                        data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">



                    <i class="fas fa-feather-alt"></i> Authors Homepage



                </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink"> <a class="dropdown-item" href="#" target="_blank">Carlos</a>
 <a class="dropdown-item"
                            href="#" target="_blank">Paul</a>
 <a class="dropdown-item" href="#" target="_blank">Prof. Reetz</a>
                        </div>
                    </li>
                </ul>
            </div>
        </nav>
        <br>
        <div class="container">
            <div class="row">
                <div class="col-xl-10 offset-md-1">
                    <!---Intro-->
                    <div class="card p-2">
                         <h3 class="card-header bg-dark">



                    <a class="card-link text-light" data-toggle="collapse" href="#intro"><i class="fas fa-angle-down"></i>&#xA0;&#xA0;&#xA0;Introduction</a>



                </h3>
                        <div class="card-body" id="intro">
                            <p>Lorem Ipsum</p>
                            <p>This site accepts two ways of inputting the data. The default is by generating
                                and filling out a table online, the second is by generating and filling
                                out an excel sheet and uploading it.</p>
                        </div>
                    </div>
                    <br>
                    <!--Form-->
                    <div class="card p-2">
                         <h3 class="card-header bg-dark">



                    <a class="card-link text-light" data-toggle="collapse" href="#directly"><i class="fas fa-angle-down"></i>&#xA0;&#xA0;&#xA0;Fill directly</a>



                </h3>
                        <div class="card-body" id="directly">
                            <div class="row">
                                <div class="col-xl-4 col-xl-3 col-lg-12">
                                    <input type="radio" name="your_study" value="S">Selectivity &#xA0;
                                    <input type="radio" name="your_study" value="C" checked>Conversion</div>
                                <div class="col-xl-3 col-xl-3">
                                    <div class="input-group">
                                        <div class="input-group-prepend"> <span class="input-group-text" id="mutation_number2-addon">mutation N</span>
                                        </div>
                                        <input type="number" class="form-control" placeholder="N" aria-label="mutation_number"
                                        aria-describedby="mutation_number2-addon" id="mutation_number2">
                                    </div>
                                </div>
                                <div class="col-xl-4 col-xl-5">
                                    <div class="input-group">
                                        <div class="input-group-prepend"> <span class="input-group-text" id="replicate_number2-addon">replicate N</span>
                                        </div>
                                        <input type="number" class="form-control" placeholder="N" aria-label="replicate_number2"
                                        aria-describedby="replicate_number2-addon" id="replicate_number2">
                                        <div class="input-group-append">
                                            <button class="btn btn-success" type="button" id="make_table">Go</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <br>
                            <div clas="row" id="mut_input_table">
                                <div class="col-xl-7 col-xl-12 col-lg-12">
                                    <div class="alert alert-warning" role="alert">Set numbers first. The table will be dynamically generated.</div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xl-6 offset-md-2">
                                    <br>
                                    <div class="btn-group" role="group">
                                        <button type="button" class="btn btn-secondary" id="clear_table">Clear</button>
                                        <button type="button" class="btn btn-primary" id="demo_table">Demo</button>
                                        <button type="button" class="btn btn-success" id="submit_table">Submit</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <br>
                    <div class="card p-2">
                         <h3 class="card-header bg-dark">



                    <a class="collapsed card-link text-light" data-toggle="collapse" href="#alt1"><i class="fas fa-angle-down"></i>&#xA0;&#xA0;&#xA0;Alt (part 1): Create template</a>



                </h3>
                        <div class="card-body collapse" id="alt1">
                            <div class="row">
                                <div class="col-xl-4">
                                    <div class="input-group">
                                        <div class="input-group-prepend"> <span class="input-group-text" id="mutation_number-addon">mutation number</span>
                                        </div>
                                        <input type="number" class="form-control" placeholder="N" aria-label="mutation_number"
                                        aria-describedby="mutation_number-addon" id="mutation_number">
                                    </div>
                                </div>
                                <div class="col-xl-4">
                                    <div class="input-group">
                                        <div class="input-group-prepend"> <span class="input-group-text" id="replicate_number-addon">replicate number</span>
                                        </div>
                                        <input type="number" class="form-control" placeholder="N" aria-label="replicate_number"
                                        aria-describedby="replicate_number-addon" id="replicate_number">
                                    </div>
                                </div>
                                <div class="col-xl-4"> <a class="btn btn-primary" id="create" href="/create_epistasis" download="epistasis_template.xlsx">Create</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <br>
                    <div class="card p-2">
                         <h3 class="card-header bg-dark">



                    <a class="collapsed card-link text-light" data-toggle="collapse" href="#alt2"><i class="fas fa-angle-down"></i>&#xA0;&#xA0;&#xA0;Alt (part 2): Upload filled</a>



                </h3>
                        <div class="card-body collapse" id="alt2">
                            <div class="row">
                                <div class="col-xl-5 col-xl-12 col-lg-12">
                                    <input type="radio" name="your_study2" value="S">Selectivity &#xA0;
                                    <input type="radio" name="your_study2" value="C" checked>Conversion</div>
                                <div class="col-xl-7 col-xl-12 col-lg-12">
                                    <input type="file" id="file_upload" accept=".csv, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel">
                                </div>
                                <div class="col-xl-6 offset-md-2">
                                    <br>
                                    <div class="btn-group" role="group">
                                        <button type="button" class="btn btn-secondary" id="clear">Clear</button>
                                        <button type="button" class="btn btn-primary" id="demo">Demo</button>
                                        <button type="button" class="btn btn-success" id="submit">Submit</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <br>
                    <!--Results-->
                    <div class="card p-2">
                         <h3 class="card-header bg-dark">



                    <a class="collapsed card-link text-light" data-toggle="collapse" href="#res"><i class="fas fa-angle-down"></i>&#xA0;&#xA0;&#xA0;Result</a>



                </h3>
                        <div class="card-body collapse" id="res">
                            <div id="results"></div>
                            <br>
                            <div id="heatmap"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>

</html>