<%page args="tool"/>
<div class="row">
    <div class="col-6 offset-lg-3">
        <div class="btn-group" role="group" aria-label="...">
            <button type="button" class="btn btn-warning" id="${tool}_clear"><i class="fas fa-eraser"
                                                                                aria-hidden="true"></i>
                Clear
            </button>
            <button type="button"
                    class="btn btn-info" id="${tool}_demo"><i class="fas fa-gift"
                                                              aria-hidden="true"></i> Demo
            </button>
            <button type="button"
                    class="btn btn-success" id="${tool}_calculate"><i class="fas fa-exchange"
                                   aria-hidden="true"></i> Calculate
            </button>
        </div>
    </div>
    <br>
</div>