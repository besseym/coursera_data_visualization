
(function() {

    function init() {

        var svg = d3.select('svg'),
            width = svg.attr('width'),
            height = svg.attr('height'),
            force = d3.layout.force()
                .charge(-220)
                .linkDistance(300)
                .size([width, height]),
            color = d3.scale.category20();

        d3.json("data/graph.json", function(error, graph) {
            if (error) throw error;

            var link = svg.selectAll(".link")
                    .data(graph.links)
                    .enter().append("line")
                    .attr("class", "link")
                    .style("stroke-width", function(d) { return Math.sqrt(d.value); }),
                node = svg.selectAll(".node")
                    .data(graph.nodes)
                    .enter().append("circle")
                    .attr("class", "node")
                    .attr("r", function(d, i){

                        return Math.log(parseInt(d.weight)* 100);
                    })
                    //.style("fill", function(d) { return color(d.group); })
                    //.call(force.drag);
                    .on("mouseover", function(d, i){

                       console.log(d);
                    });

            node.append("title").text(function(d) { return d.url; });

            force.on("tick", function() {

                link.attr("x1", function(d) { return d.source.x; })
                    .attr("y1", function(d) { return d.source.y; })
                    .attr("x2", function(d) { return d.target.x; })
                    .attr("y2", function(d) { return d.target.y; });

                node.attr("cx", function(d) { return d.x; })
                    .attr("cy", function(d) { return d.y; });
            });

            force
                .nodes(graph.nodes)
                .links(graph.links)
                .start();

            //console.log(graph.nodes);
        });

        console.log(width + " : " + height);
    }


    window.onload = function () {

        try {

            init();


        }
        catch (e) {
            console.log(e);
        }
    };

})();