/**
 * 
 */
package com.msb.web.graph;

/**
 * @author besseym
 *
 */
public class GraphWrapper {
	
	private Graph graph;

	/**
	 * 
	 */
	public GraphWrapper(Graph graph) {
		
		this.graph = graph;
	}

	/**
	 * @return the graph
	 */
	public Graph getGraph() {
		return graph;
	}

	/**
	 * @param graph the graph to set
	 */
	public void setGraph(Graph graph) {
		this.graph = graph;
	}

}
