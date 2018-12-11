<div class="card">
    <div class="card-header">
        <h1 class="card-title">Stats</h1>
    </div>
    <div class="card-body">
        <ul class="list-group">
            <li class="list-group-item"><b>CPU use by this app:</b>${page.data['pid_cpu']}</li>
            <li class="list-group-item"><b>System CPU usages:</b>${page.data['tot_cpu']}</li>
            <li class="list-group-item"><b>Memory use by this app:</b>${page.data['pid_mem']}</li>
            <li class="list-group-item"><b>Full stats CPU:</b>${page.data['cpu']}</li>
            <li class="list-group-item"><b>Full stats virt:</b>${page.data['virt']}</li>
            <li class="list-group-item"><b>Full stats swap:</b>${page.data['swap']}</li>
        </ul>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <h1 class="card-title">Links and buttons</h1>
    </div>
    <div class="card-body">
        <div class="row">
            <% options=[
                ('/log',                    'success',  'fa-server',            'Server log'),
                ('/static/bash_log.txt',    'info',     'fa-server',            'Bash log'),
                ('/upcoming',               'success',  'fa-sticky-note',       'To Do list'),
                ('/set?status=normal',      'warning',  'fa-flag-checkered',    'Remove warning'),
                ('/set?status=construction','warning',  'fa-briefcase',         'Under-construction warning'),
                ('/set?status=beta',        'warning',  'fa-exclamation-triangle','Beta warning'),
                ('/set?status=xmas',        'info',     'fa-tree-christmas',    'Merry Christmas!'),
                ('/set?status=red',         'warning',  'fa-fire-extinguisher', 'Don\'t press this')
                ]
            %>
            % for URL, button_type, icon, text in options:
                <div class="col-md-4 col-lg-3 mb-3 d-flex flex-column"><a href="${URL}" class="btn btn-${button_type}" target="_blank"><i class="fas ${icon}" aria-hidden="true"></i> ${text}</a></div>
            % endfor

            <div clas="col-md-4 col-lg-3 mb-3"><a href="" class="btn btn-" target="_blank">
                <i class="fas " aria-hidden="true"></i>
                </a></div>
            <div class="col-md-8  col-lg-6 mb-3">
                <div class="input-group" role="group" aria-label="Basic example">
                    <input type="text" class="form-control" placeholder="Custom message!" id="custom_status">
                    <div class="input-group-append">
                        <button type="button" class="btn btn-warning" onclick="window.open('/set?status='+encodeURI($('#custom_status').val()))"><i
                                class="fas fa-alicorn"></i>&nbsp;Set
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="input-group" role="group" aria-label="Basic example">
            <div class="input-group-prepend">
                <div class="input-group-text"><a href="/set?reset=go" class="btn btn-danger" target="_blank">
            <i class="fas fa-bomb" aria-hidden="true"></i>
            Git-pull &amp; reset</a></div>
            </div>
            <div class="input-group-append"><span class="input-group-text">NB. The server will not respond with a success. It will go down temporarily.</span></div>
        </div>
    </div>
</div>
