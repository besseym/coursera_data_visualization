
(function() {

    function init() {

        var chart = d3.select(".chart"),
            svg = chart.select("svg"),
            width = parseInt(svg.style("width"), 10),
            height = parseInt(svg.style("height"), 10),
            force = d3.layout.force()
                .charge(-220)
                .linkDistance(300)
                .size([width, height]),
            tooltip = chart.select(".chart-info-panel"),
            currentStartNode;

        d3.json("data/graph.json", function(error, graph) {
            if (error) throw error;

            var link = svg.selectAll(".link")
                    .data(graph.links)
                    .enter().append("line")
                    .attr("class", "link")
                    .attr("id", function(d, i){
                        return "link_" + d.id;
                    })
                    .style("stroke-width", function(d) { return Math.sqrt(d.value); }),
                node = svg.selectAll(".node")
                    .data(graph.nodes)
                    .enter().append("circle")
                    .attr("id", function(d, i){
                        return "node_" + d.index;
                    })
                    .attr("class", "node")
                    .attr("r", function(d, i){

                        return Math.log(parseInt(d.weight)* 100);
                    })
                    //.style("fill", function(d) { return color(d.group); })
                    //.call(force.drag);
                    .on("mouseover", function(d, i){

                        var i = 0,
                            currentEndNode,
                            currentLink,
                            node = d3.select(this),
                            x = node.attr('cx'),
                            y = node.attr('cy'),
                            urlTooltip = tooltip.select("#url"),
                            weightTooltip = tooltip.select("#weight"),
                            linkListTooltip = tooltip.select("#link-list"),
                            newTooltipStyleLocation = getNewStyleLocation(x, y, tooltip.node().getBoundingClientRect(), chart.node().getBoundingClientRect());

                        if(currentStartNode !== undefined){
                            currentStartNode.style({'fill': null});
                        }
                        currentStartNode = d3.select("#node_" + d.index);
                        currentStartNode.style({'fill': "#00ff00"});

                        urlTooltip.select("a").text(d.url).attr("href", d.url);
                        weightTooltip.text(d.weight);

                        linkListTooltip.selectAll("li").remove();
                        linkListTooltip
                            .selectAll("li")
                            .data(d.linkList)
                            .enter()
                            .append("li")
                            .append("a")
                            .attr("href", function(d, i){
                                return d.targetUrl;
                            })
                            .text(function(d, i){
                                return d.targetUrl;
                            })
                            .on("mouseover", function(d, i){
                                currentEndNode = d3.select("#node_" + d.target);
                                currentEndNode.style({'fill': "#ff0000"});
                                currentLink = d3.select("#link_" + d.id);
                                currentLink.style({'stroke': "#ff0000", 'stroke-opacity': 1.0});
                            })
                            .on("mouseout", function(d, i){
                                currentEndNode.style({'fill': null});
                                currentLink.style({'stroke': null, 'stroke-opacity': null});
                            });
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

    function getNewStyleLocation (x, y, innerRect, outerRect){

        var styleLocation = {left: x + "px", top: y + "px", right: undefined, bottom: undefined};

        if((x + innerRect.width) > outerRect.width){
            styleLocation.left = undefined;
            styleLocation.right = (outerRect.width - x) + "px";
        }

        if((y + innerRect.height) > outerRect.height){
            styleLocation.top = undefined;
            styleLocation.bottom = (outerRect.height - y) + "px";
        }

        return styleLocation;
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