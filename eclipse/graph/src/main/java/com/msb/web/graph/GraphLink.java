/**
 * 
 */
package com.msb.web.graph;

/**
 * @author besseym
 *
 */
public class GraphLink {
	
	private String id;
	
	private Integer source;
	private Integer target;
	private Integer value;
	
	private String sourceUrl;
	private String targetUrl;

	/**
	 * 
	 */
	public GraphLink() {
		
		this.value = Integer.valueOf(1);
	}
	
	/**
	 * 
	 * @param source
	 * @param target
	 */
	public GraphLink(Integer source, Integer target) {
		
		this();
		
		this.id = source + "_" + target;
		
		this.source = source;
		this.target = target;
	}

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the source
	 */
	public Integer getSource() {
		return source;
	}

	/**
	 * @param source the source to set
	 */
	public void setSource(Integer source) {
		this.source = source;
	}

	/**
	 * @return the target
	 */
	public Integer getTarget() {
		return target;
	}

	/**
	 * @param target the target to set
	 */
	public void setTarget(Integer target) {
		this.target = target;
	}

	/**
	 * @return the value
	 */
	public Integer getValue() {
		return value;
	}

	/**
	 * @param value the value to set
	 */
	public void setValue(Integer value) {
		this.value = value;
	}

	/**
	 * @return the sourceUrl
	 */
	public String getSourceUrl() {
		return sourceUrl;
	}

	/**
	 * @param sourceUrl the sourceUrl to set
	 */
	public void setSourceUrl(String sourceUrl) {
		this.sourceUrl = sourceUrl;
	}

	/**
	 * @return the targetUrl
	 */
	public String getTargetUrl() {
		return targetUrl;
	}

	/**
	 * @param targetUrl the targetUrl to set
	 */
	public void setTargetUrl(String targetUrl) {
		this.targetUrl = targetUrl;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
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
		GraphLink other = (GraphLink) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}

}
