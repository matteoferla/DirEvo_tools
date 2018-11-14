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
            <div class="col-md-4 col-lg-3 mb-3"><a href="/log" class="btn btn-success"><i class="fas fa-server" aria-hidden="true"></i> Server log</a></div>
            <div class="col-md-4 col-lg-3 mb-3"><a href="/static/bash_log.txt" class="btn btn-info">
                <i class="fas fa-server" aria-hidden="true"></i> Bash log</a></div>
            <div class="col-md-4 col-lg-3 mb-3"><a class="btn btn-success" href="/upcoming">
                <i class="fas fa-sticky-note-o" aria-hidden="true"></i>
                To Do list</a></div>
            <div class="col-md-4 col-lg-3 mb-3"><a href="/set?status=normal" class="btn btn-warning" target="_blank"><i class="fas fa-flag-checkered"
                                                                                                       aria-hidden="true"></i> Remove warning</a></div>
            <div class="col-md-4 col-lg-3 mb-3"><a href="/set?status=construction" class="btn btn-warning" target="_blank">
                <i class="fas fa-briefcase" aria-hidden="true"></i>
                under construction warning</a></div>
            <div class="col-md-4 col-lg-3 mb-3"><a href="/set?status=beta" class="btn btn-warning" target="_blank">
                <i class="fas fa-exclamation-triangle" aria-hidden="true"></i>
                Beta warning</a></div>
            <div clas="col-md-4 col-lg-3 mb-3"><a href="/set?status=red" class="btn btn-warning" target="_blank">
                <i class="fas fa-fire-extinguisher" aria-hidden="true"></i>
                Don&apos;t press this</a></div>
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
