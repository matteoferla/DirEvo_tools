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


// Let's mod string python-style alla StackOverflow (.formatUnicorn)
String.prototype.format = String.prototype.format ||
    function() {
        "use strict";
        var str = this.toString();
        if (arguments.length) {
            var t = typeof arguments[0];
            var key;
            var args = ("string" === t || "number" === t) ?
                Array.prototype.slice.call(arguments) :
                arguments[0];

            for (key in args) {
                str = str.replace(new RegExp("\\{" + key + "\\}", "gi"), args[key]);
            }
        }

        return str;
    };


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

    function make_graphs(reply, mutation_number) {
        powersetplot("theo", reply['raw'],mutation_number);
        powersetplot("emp", reply['raw'],mutation_number);
        $('#theo-down').click(function () {saveSvgAsPng(document.getElementById("theo-svg"), "theoretical.png")});
        $('#emp-down').click(function () {saveSvgAsPng(document.getElementById("emp-svg"), "empirical.png")});
    }

    $('#submit').click(function() {
        $("#results").html('RUNNING!');
        var data = new FormData();
        data.append("file", document.getElementById('file_upload').files[0]);
        data.append("your_study", $('input[name=your_study2]:checked').val());
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
                    make_graphs(reply,mutation_number);
                    $('#res').collapse('show');
                },
                error: function(xhr, s) {
                    $("#results").html(s);
                }
            });
        } catch (err) {
            $("#results").html(err);
        }
    });

    function add_datapoint(svg,tooltip,datapoint, layout) {
    // datapoint is a dict with x y v(alue) color text and info
        var group=svg.append("g");
        group.append("text")
            .attr("x", datapoint["x"])
            .attr("y", datapoint["y"]+20)
            .attr("text-anchor", "middle")
            .style("fill", "black")
            .text(datapoint["text"]); //.attr("dy", ".35em")
        group.append("circle")
            .attr("cx", datapoint["x"])
            .attr("cy", datapoint["y"])
            .attr("r", datapoint["v_sd"])
            .style("fill", datapoint["color_sd"])
        group.append("circle")
            .attr("cx", datapoint["x"])
            .attr("cy", datapoint["y"])
            .attr("r", datapoint["v"])
            .style("fill", datapoint["color"])
        if (layout["where"]=='theo') {
            group.append("circle")
                .attr("cx", datapoint["x"])
                .attr("cy", datapoint["y"])
                .attr("r", datapoint["v_e"])
                .style("stroke","black")
                .style("stroke-width","1")
                .style("fill","none")
        }
        group.on("mouseover", function(d) {
                tooltip.transition()
                    .duration(200)
                    .style("opacity", .9);
                tooltip.html(datapoint["info"])
                    .style("left", (d3.event.pageX) + "px")
                    .style("top", (d3.event.pageY - 28) + "px");
            })
            .on("mouseout", function(d) {
                tooltip.transition()
                    .duration(500)
                    .style("opacity", 0);
            });
        }

    function powersetplot(where, alldata,mutation_number) {
        var data=alldata['empirical'];
        var chosen_index=mutation_number;
        if (where == 'theo') {
            chosen_index=mutation_number+3;
            data=alldata['theoretical'];
        }
        //quicker than a combinatorial..
        var binomials = [
            [1],
            [1,1],
            [1,2,1],
            [1,3,3,1],
            [1,4,6,4,1],
            [1,5,10,10,5,1],
            [1,6,15,20,15,6,1],
            [1,7,21,35,35,21,7,1],
            [1,8,28,56,70,56,28,8,1]
          ];
        if (where == 'emp') {
            places=binomials[mutation_number];
        }
        else {
            places=Array(mutation_number+1).fill(0);
            for (var i=0; i<data['data'].length; i++) {
                var tier=data['data'][i].slice(0,mutation_number).join('').split("+").length - 1;
                places[tier]++;
            }
            //add-ins for the emp data...
            places[0]=1;
            places[1]=mutation_number;
        }
        var x_step=50;
        var layout={mutation_number: mutation_number,
                    x_step: x_step,
                    y_step: 50,
                    x_mid: Math.max(...places)/2*x_step,
                    x_offset: Array(mutation_number+1).fill(0).map((v,index) => -(places[index]-1)/2*x_step),
                    x_index: Array(mutation_number+1).fill(0),
                    y_offset:50,
                    chosen_index: chosen_index,
                    where: where
            };


        // start canvas
        var tooltip = d3.select("body").append("div").attr("class", "tooltip").style("opacity", 0);
        var svg = d3.select("#"+where+"-graph-plot").append("svg:svg").attr("width", "100%").attr("height",(mutation_number+1)*layout["y_step"]+50).attr("id",where+"-svg");

        // scale
        layout["scale"]=(x_step/4)/Math.max(...data['data'].map(x =>parseFloat(x[layout["chosen_index"]])));

        // make datapoints weirdly (see below for normal).
        if (where=="theo") {
            places=binomials[mutation_number];
            var empdata=alldata['empirical'];
            for (var i=0; i<empdata['data'].length; i++) {
                var item=empdata['data'][i];
                var id=item.slice(0,mutation_number).join('');
                var tier=id.split("+").length - 1;
                if (tier < 2) {
                    var datapoint={x: layout["x_mid"]+layout["x_offset"][tier]+layout["x_index"][tier]*layout["x_step"],
                         y: layout["y_offset"]+(layout["mutation_number"]-tier)*layout["y_step"],
                         v: 0,
                         v_sd: 0,
                         v_e: layout["scale"]*parseFloat(item[mutation_number]),
                         color: "none",
                         color_sd: "none",
                         text:id,
                         info:'Value: '+roundToSD(parseFloat(item[mutation_number]),parseFloat(item[mutation_number+1]))
                  };
                  add_datapoint(svg,tooltip,datapoint, layout);
                  layout["x_index"][tier]++;
                  if (tier==1) {
                    // log what they are so I can add arrows!!! TODO.
                  }
                }
            }
        }

        // make normally
        for (var i=0; i<data['data'].length; i++) {
            var item=data['data'][i];
            var id=item.slice(0,mutation_number).join('');
            var tier=id.split("+").length - 1;
            var datapoint={x: layout["x_mid"]+layout["x_offset"][tier]+layout["x_index"][tier]*layout["x_step"],
                         y: layout["y_offset"]+(layout["mutation_number"]-tier)*layout["y_step"],
                         v: layout["scale"]*parseFloat(item[layout["chosen_index"]]),
                         v_sd: layout["scale"]*(parseFloat(item[layout["chosen_index"]])+parseFloat(item[layout["chosen_index"]+1])),
                         color: "gray",
                         color_sd: "lightGray",
                         text:id,
                         info:'Value: '+roundToSD(parseFloat(item[layout["chosen_index"]]),parseFloat(item[layout["chosen_index"]+1]))
                  };
            layout["x_index"][tier]++;
            if (where=="theo") {
                datapoint['info']=item[mutation_number]+' '+datapoint['info'];
                datapoint['v_e']=layout["scale"]*parseFloat(item[mutation_number+1]);
            }
            add_datapoint(svg,tooltip,datapoint, layout);
        }
    }

    function roundToSD(mean,sd) {
        var d=Math.round(Math.pow(10,Math.log10(sd)));
        return '{0}±{1}'.format(Math.round(mean/d)*d, Math.round(sd/d)*d);
    }


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
                    make_graphs(reply,mutation_number);
                    $('#res').collapse('show');
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
        demo = [
            [40.408327, 37.176372, 35.776619],
            [37.383186, 35.019421, 42.932996],
            [34.551186, 34.033348, 30.844536],
            [43.913044, 47.390555, 42.959925],
            [31.102138, 28.735591, 29.401488],
            [29.78191, 24.641165, 25.13452],
            [79.956978, 84.28502, 74.090488],
            [76.937329, 69.938071, 58.361839]
        ];
        for (var m = 0; m < 8; m++) {
            for (var r = 0; r < 3; r++) {
                $(`#M${m}R${r}`).val(demo[m][r]);
            }
        }
    });




});