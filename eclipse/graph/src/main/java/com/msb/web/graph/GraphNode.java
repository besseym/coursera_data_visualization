package com.msb.web.graph;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 
 * @author besseym
 *
 */
public class GraphNode implements Comparable<GraphNode> {

	private Integer index;
	private Boolean fixed;
	private Integer weight;
	
	private String url;
	
	private List<GraphLink> sourceLinkList;
	private List<GraphLink> targetLinkList;
	
	/**
	 * 
	 */
	public GraphNode() {
		
		this.index = Integer.valueOf(0);
		this.fixed = Boolean.FALSE;
		this.weight = Integer.valueOf(1);
		
		this.sourceLinkList = new ArrayList<GraphLink>();
		this.targetLinkList = new ArrayList<GraphLink>();
	}
	
	public GraphNode(Integer index) {
		
		this();
		
		this.index = index;
	}
	
	/**
	 * 
	 */
	public void sortLinks(){
		
		Comparator c = new Comparator<GraphLink>(){

			@Override
			public int compare(GraphLink g1, GraphLink g2) {
				return g1.getTargetUrl().toLowerCase().compareTo(g2.getTargetUrl().toLowerCase());
			}
		};
		
		Collections.sort(this.sourceLinkList, c);
		Collections.sort(this.targetLinkList, c);
	}

	/**
	 * @return the index
	 */
	public Integer getIndex() {
		return index;
	}

	/**
	 * @param index the index to set
	 */
	public void setIndex(Integer index) {
		this.index = index;
	}

	/**
	 * @return the fixed
	 */
	public Boolean getFixed() {
		return fixed;
	}

	/**
	 * @param fixed the fixed to set
	 */
	public void setFixed(Boolean fixed) {
		this.fixed = fixed;
	}

	/**
	 * @return the weight
	 */
	public Integer getWeight() {
		return weight;
	}

	/**
	 * @param weight the weight to set
	 */
	public void setWeight(Integer weight) {
		this.weight = weight;
	}

	/**
	 * @return the url
	 */
	public String getUrl() {
		return url;
	}

	/**
	 * @param url the url to set
	 */
	public void setUrl(String url) {
		this.url = url;
	}

	/**
	 * @return the sourceLinkList
	 */
	public List<GraphLink> getSourceLinkList() {
		return sourceLinkList;
	}

	/**
	 * @param sourceLinkList the sourceLinkList to set
	 */
	public void setSourceLinkList(List<GraphLink> sourceLinkList) {
		this.sourceLinkList = sourceLinkList;
	}

	/**
	 * @return the targetLinkList
	 */
	public List<GraphLink> getTargetLinkList() {
		return targetLinkList;
	}

	/**
	 * @param targetLinkList the targetLinkList to set
	 */
	public void setTargetLinkList(List<GraphLink> targetLinkList) {
		this.targetLinkList = targetLinkList;
	}

	/*
	 * 
	 */
	@Override
	public int compareTo(GraphNode o) {
		return this.index.compareTo(o.index);
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((index == null) ? 0 : index.hashCode());
		return result;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		GraphNode other = (GraphNode) obj;
		if (index == null) {
			if (other.index != null)
				return false;
		} else if (!index.equals(other.index))
			return false;
		return true;
	}
	
	public static void main(String[] args) throws Exception {
		
		GraphNode n1 = new GraphNode();
		n1.setIndex(1);
		
		GraphNode n2 = new GraphNode();
		n2.setIndex(2);
		
		Map<String, GraphNode> graphNodeMap = new HashMap<String, GraphNode>();
		graphNodeMap.put("key", n1);
		graphNodeMap.put("key", n2);
		
		System.out.println(graphNodeMap.size());

	}

}
