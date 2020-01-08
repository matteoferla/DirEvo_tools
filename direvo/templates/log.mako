<%page args="page"/>
<div class="card">
    <div class="card-header">
        <h1 class="card-title">Log</h1>
        <h4 class="card-subtitle mb-2 text-muted">The captain's log</h4>
    </div>
    <div class="card-body">
        <div class="alert alert-success" role="alert"><a href="static/bash_log.txt">download terminal log</a></div>
        <br/>
        <table class="table table-condensed">
            <thead><tr><th>Time</th><th>Code</th><th>IP Address</th><th>Physical address</th><th>Task</th><th>AJAX JSON</th><th>Status</th></tr></thead>
            <tbody><tr>
                % for line in page.log.split('\n'):
                    <tr>
                     % for cell in line.split('\t'):
                        <td>${cell}</td>
                     % endfor
                    </tr>
                % endfor
            </tbody></table>
    </div>
</div>