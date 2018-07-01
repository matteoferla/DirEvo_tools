// Google Analytics
(function(i, s, o, g, r, a, m) {
    i['GoogleAnalyticsObject'] = r;
    i[r] = i[r] || function() {
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

//Upload
$(document).ready(function() {

    function update_mut_names_div() {
        var mutation_number = $('#mutation_number2').val();
        var replicate_number = $('#replicate_number2').val();
        var header = '<tr><th>Mutant</th>';
        for (var i = 1; i <= mutation_number; i++) {
            header += `<th><input placeholder="M${i}" data-toggle="tooltip" data-placement="top" title="Mutation number ${i}. Feel free to rename it something meaningful like D10N" id="M${i}"></th>`;
        }
        for (var i = 1; i <= replicate_number; i++) {
            header += `<th data-toggle="tooltip" data-placement="top" title="Replicate number ${i}">R${i}</th>`;
        }
        var body = '';
        for (var i = 0; i < Math.pow(2, mutation_number); i++) {
            body += '<tr><td></td>';
            for (var j = 0; j < mutation_number; j++) {
                body += `<td>${(i).toString(2).padStart(mutation_number,'0').split("").map((v,i)=>v == "1" ? "+" : "-")[j]}</td>`;
            }
            for (var j = 0; j < replicate_number; j++) {
                body += `<td><input placeholder="xxx" type="number" data-toggle="tooltip" data-placement="top" title="Empirical value" id="M${i}R${j}"></td>`;
            }
            body += '</tr>';
        }

        var txt = `<table class='table table-striped'><thead>${header}</thead><tbody>${body}</tbody></table`;
        $("#mut_input_table").html(txt);
    }

    $("#make_table").click(function() {
        update_mut_names_div()
    });

    function update_create_url() {
        $('#create').attr("href", "/create_epistasis?replicate_number=" + $("#replicate_number").val() + "&mutation_number=" + $("#mutation_number").val());
    }
    $('#create').hover(function() {
        update_create_url()
    });
    $('#replicate_number').change(function() {
        update_create_url()
    });
    $('#mutation_number').change(function() {
        update_create_url()
    });
    $('#clear').click(function() {
        alert("This does nothing")
    });
    $('#demo').click(function() {
        alert("This does nothing")
    });

    $('#submit').click(function() {
        $("#results").html('RUNNING!');
        var data = new FormData();
        data.append("file", document.getElementById('file_upload').files[0]);
        data.append("your_study", $('input[name=your_study]:checked').val());
        try {
            $.ajax({
                url: "/ajax_epistasis",
                type: "POST",
                data: data,
                processData: false,
                cache: false,
                contentType: false,
                success: function(result) {
                    //reply = JSON.parse(result.message);
                    reply = result;
                    $("#results").html(reply['html']);
                    window.sessionStorage.setItem('data', reply);
                },
                error: function(xhr, s) {
                    $("#results").html(s);
                }
            });
        } catch (err) {
            $("#results").html(err);
        }
    });

    $('#submit_table').click(function() {
        $("#results").html('RUNNING!');
        var mutation_number = parseFloat($("#mutation_number2").val());
        var replicate_number = parseFloat($("#replicate_number2").val());
        var mutations_list = new Array(mutation_number).fill('xxx');
        for (var i = 0; i < mutation_number; i++) {
            if ($("#M" + (i + 1).toString()).val()) {
                mutations_list[i] = $("#M" + (i + 1).toString()).val();
            } else {
                mutations_list[i] = "#M" + (i + 1).toString();
            }
        }
        var mpower = Math.pow(2, mutation_number);
        //var foundment_values = Array.apply(null, Array(mpower)).map((v, i) => (i).toString(2).padStart(mutation_number, '0').split("").map((v, i) => v == "1" ? "+" : "-"));
        var foundment_values = Array.apply(null, Array(mpower)).map((v, i) => (i).toString(2).padStart(mutation_number, '0').split("").map((v, i) => parseFloat(v)));
        var replicate_matrix = Array(mpower);
        for (var i = 0; i < mpower; i++) {
            replicate_matrix[i] = Array.apply(null, Array(replicate_number)).map((v, j) => parseFloat($("#M" + i.toString() + "R" + j.toString()).val()));
        }
        var data_array = Array.apply(null, Array(mpower)).map((v, i) => foundment_values[i].concat(replicate_matrix[i]));
        //data_array=None,replicate_matrix=None

        var data = {
            mutation_number: mutation_number,
            replicate_number: replicate_number,
            your_study: $('input[name=your_study]:checked').val(),
            mutations_list: mutations_list,
            foundment_values: foundment_values,
            replicate_matrix: replicate_matrix,
            data_array: data_array
        };
        console.log(data);

        try {
            $.ajax({
                url: "/ajax_epistasis",
                type: "POST",
                dataType: 'json',
                data: JSON.stringify(data),
                processData: false,
                cache: false,
                contentType: false,
                success: function(result) {
                    //reply = JSON.parse(result.message);
                    reply = result;
                    $("#results").html(reply['html']);
                    window.sessionStorage.setItem('data', reply);
                },
                error: function(xhr, s) {
                    $("#results").html(s);
                }
            });
        } catch (err) {
            $("#results").html(err);
        }
    });

    $('#demo_table').click(function() {
        $('#mutation_number2').val(3);
        $('#replicate_number2').val(3);
        update_mut_names_div();
        demo=[[40.408327, 37.176372, 35.776619],
        [37.383186,35.019421,42.932996],
        [34.551186,34.033348,30.844536],
        [43.913044,47.390555, 42.959925],
        [31.102138,28.735591,29.401488],
        [29.78191,24.641165,25.13452],
        [79.956978,84.28502,74.090488],
        [76.937329,69.938071,58.361839]];
        for (var m=0; m<8; m++) {
            for (var r=0; r<3; r++) {
                $(`#M${m}R${r}`).val(demo[m][r]);
            }
        }
    });


});