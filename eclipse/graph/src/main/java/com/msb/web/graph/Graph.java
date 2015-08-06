/**
 * 
 */
package com.msb.web.graph;

import java.util.ArrayList;
import java.util.List;

/**
 * @author besseym
 *
 */
public class Graph {
	
	private List<GraphNode> nodes;
	private List<GraphLink> links;

	/**
	 * 
	 */
	public Graph() {
		
		this.nodes = new ArrayList<GraphNode>();
		this.links = new ArrayList<GraphLink>();
	}

	/**
	 * @return the nodes
	 */
	public List<GraphNode> getNodes() {
		return nodes;
	}

	/**
	 * @param nodes the nodes to set
	 */
	public void setNodes(List<GraphNode> nodes) {
		this.nodes = nodes;
	}

	/**
	 * @return the links
	 */
	public List<GraphLink> getLinks() {
		return links;
	}

	/**
	 * @param links the links to set
	 */
	public void setLinks(List<GraphLink> links) {
		this.links = links;
	}

}
