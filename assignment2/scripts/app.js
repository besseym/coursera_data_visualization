
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
            infoPanel = chart.select(".chart-info-panel"),
            sourceEdgeListElement = infoPanel.select("#edge-list-source"),
            headerSource = infoPanel.select("#header-source"),
            targetEdgeListElement = infoPanel.select("#edge-list-target"),
            headerTarget = infoPanel.select("#header-target"),
            edgeSourceLinksVisible = true,
            edgeTargetLinksVisible = true,
            selectedNode,
            selectedColor = "#377eb8",
            sourceColor = "#4daf4a",
            targetColor = "#e41a1c";

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
                    .on("click", function(d, i){
                        setCurrentStartNode(d.index);
                    });

            headerSource.on("click", function() {

                console.log("source click");

                if(edgeSourceLinksVisible){
                    sourceEdgeListElement.selectAll("li").style({"display": "none"});
                    headerSource.select("i").attr("class", "fa fa-plus-square-o");
                }
                else {
                    sourceEdgeListElement.selectAll("li").style({"display": null});
                    headerSource.select("i").attr("class", "fa fa-minus-square-o");
                }

                edgeSourceLinksVisible = !edgeSourceLinksVisible;
            });

            headerTarget.on("click", function() {

                console.log("target click");

                if(edgeTargetLinksVisible){
                    targetEdgeListElement.selectAll("li").style({"display": "none"});
                    headerTarget.select("i").attr("class", "fa fa-plus-square-o");
                }
                else {
                    targetEdgeListElement.selectAll("li").style({"display": null});
                    headerTarget.select("i").attr("class", "fa fa-minus-square-o");
                }

                edgeTargetLinksVisible = !edgeTargetLinksVisible;
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


            function setCurrentStartNode(index){

                var i = 0,
                    d = graph.nodes[index],
                    urlInfoPanel = infoPanel.select("#url"),
                    externalLink = infoPanel.select("#external-link"),
                    weightInfoPanel = infoPanel.select("#weight");

                headerSource.select("i").attr("class", "fa fa-minus-square-o");
                edgeSourceLinksVisible = true;
                headerTarget.select("i").attr("class", "fa fa-minus-square-o");
                edgeTargetLinksVisible = true;

                if(selectedNode !== undefined){
                    selectedNode.style({'fill': null});
                }

                selectedNode = d3.select("#node_" + d.index);
                selectedNode.style({'fill': selectedColor});

                infoPanel.style({"visibility": "visible"});

                urlInfoPanel.text(d.url);
                externalLink.attr("href", d.url);
                weightInfoPanel.text(d.weight);

                buildLinkListUi(sourceEdgeListElement, d.sourceLinkList, true);
                buildLinkListUi(targetEdgeListElement, d.targetLinkList, false);
            }

            function buildLinkListUi(edgeListElement, linkList, isSource){

                var node,
                    link,
                    color;

                if(isSource){
                    color = targetColor;
                }
                else {
                    color = sourceColor;
                }

                edgeListElement.selectAll("li").remove();
                edgeListElement
                    .selectAll("li")
                    .data(linkList)
                    .enter()
                    .append("li")
                    .text(function(d, i){

                        var url = d.sourceUrl;
                        if(isSource){
                            url = d.targetUrl;
                        }

                        return url + " ";
                    })
                    .on("mouseover", function(d, i){

                        if(isSource){
                            node = d3.select("#node_" + d.target);
                        }
                        else {
                            node = d3.select("#node_" + d.source);
                        }

                        node.style({'fill': color});
                        link = d3.select("#link_" + d.id);
                        link.style({'stroke': color, 'stroke-opacity': 1.0});
                    })
                    .on("mouseout", function(d, i){

                        node.style({'fill': null});
                        if(link.index == selectedNode.index) {
                            selectedNode.style({'fill': selectedColor});
                        }
                        link.style({'stroke': null, 'stroke-opacity': null});
                    })
                    .on("click", function(d, i){
                        link.style({'stroke': null, 'stroke-opacity': null});

                        if(isSource) {
                            setCurrentStartNode(d.target);
                        }
                        else {
                            setCurrentStartNode(d.source);
                        }
                    })
                    .append("a")
                    .attr("target", "_blank")
                    .attr("href", function(d, i){

                        var url = d.sourceUrl;
                        if(isSource){
                            url = d.targetUrl;
                        }

                        return url + " ";
                    })
                    .append("i")
                    .attr("class", "fa fa-external-link");
            }
        });



        //console.log(width + " : " + height);
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