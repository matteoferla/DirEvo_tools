<%page args="page"/>
<div class="card">
  <div class="card-body">
    <h1 class="card-title">Glossary</h1>
    <h3 class="card-subtitle mb-2 text-muted">Commonly used technical words within this site</h3>
    <div class="row">
            <ul class="list-group">
                % for enboldened, text in page.terms.values():
                    <il class="list-group-item"><b>${enboldened}</b> ${text|n}</il>
                % endfor
            </ul>
        </div>
  </div>
</div>
<div class="card">
  <div class="card-body">
    <h1 class="card-title">FAQ</h1>
    <h3 class="card-subtitle mb-2 text-muted">Answers to question you might have.</h3>
    <p class="card-text">If still troubled why not leave <a onclick="$('#comment_modal').modal('show');" style="cursor:pointer"
                                        class="nav-link">a comment</a>?</p>
    <div class="row">
            <ul class="list-group">
                <il class="list-group-item">
                    <h3>What about Sun&apos;s PCR distribution?</h3> Due to the fact that the PCR efficiency is not a
                    straightforward parameter
                    to obtain and can be strongly misleading it was not ported to this project to avoid beguiling the user with false data.
                    For more see: <a href="http://blog.matteoferla.com/2018/08/pcr-distribution.html">Matteo&apos;s
                    blogpost on PCR distribution <i class="fas fa-external-link" aria-hidden="true"></i></a>
                </il>
                <il class="list-group-item">
                    <h3>Is ${page.term_helper('bias','mutational bias')|n} a big deal?</h3> Unfortunately, yes.
                    Some methods of introducing random mutations favour certain mutations so much
                    that certain desired amino acid changes, such as a glutamaine to glutamate, becomes very unlikely.
                    For more see: <a href="https://blog.matteoferla.com/2018/01/gc-transversions-aka-english-scrabble.html">Matteo&apos;s
                    blogpost on mutational biases <i class="fas fa-external-link" aria-hidden="true"></i></a>
                </il>
            </ul>
        </div>
  </div>
</div>


