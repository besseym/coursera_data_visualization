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
public class PageNode {
	
	private String url;
	private List<String> linkedurls;

	/**
	 * 
	 */
	public PageNode() {
		
		this.linkedurls = new ArrayList<String>();
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
	 * @return the linkedurls
	 */
	public List<String> getLinkedurls() {
		return linkedurls;
	}

	/**
	 * @param linkedurls the linkedurls to set
	 */
	public void setLinkedurls(List<String> linkedurls) {
		this.linkedurls = linkedurls;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "Page [url=" + url + ", linkedurls size=" + linkedurls.size() + "]";
	}

}
