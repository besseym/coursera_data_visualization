/**
 * 
 */
package com.msb.web.graph;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.codehaus.jackson.map.DeserializationConfig;
import org.codehaus.jackson.map.ObjectMapper;

/**
 * @author besseym
 *
 */
public class GraphParser {
	
	private String inputPath;
	private String outputPath;
	
	private ObjectMapper objectMapper;

	/**
	 * 
	 */
	public GraphParser() {
		
		this.inputPath = "/Users/besseym/Personal/Education/Coursera/DataMining/DataVisualization/projects/sitegraph_sc.json";
		this.outputPath = "/Users/besseym/Personal/Education/Coursera/DataMining/DataVisualization/projects/assignment2/data/graph_sc.json";
		
		this.objectMapper = new ObjectMapper();
		this.objectMapper.configure(DeserializationConfig.Feature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}
	
	/**
	 * 
	 * @throws Exception
	 */
	public void parseGraph() throws Exception{
		
		BufferedReader reader = null;
		List<PageNode> pageNodeList = new ArrayList<PageNode>();
		
		try{
			
			reader = new BufferedReader(new FileReader(this.inputPath));
			
			PageNode pageNode = null;
			
			String url = null;
			String line = reader.readLine();
		    while (line != null) {
		        
		        pageNode = this.objectMapper.readValue(line, PageNode.class);
		        if(doIgnore(pageNode)){
		        	line = reader.readLine();
		        	continue;
		        }
		        
		        pageNodeList.add(pageNode);
		        
		        line = reader.readLine();
		    }
		}
		finally {
			
			if(reader != null){
				reader.close();
			}
		}
		
		PrintWriter writer = null;
		
		 try{
			 
			 writer = new PrintWriter(this.outputPath);
			 
			 Graph graph = extractGraph(pageNodeList);
			 
			 System.out.println(graph);
			 
			 this.objectMapper.writeValue(writer, graph);
		 }
		 finally {
			
			if(writer != null){
				writer.close();
			}
		}
	}
	
	/**
	 * 
	 * @param url
	 * @return
	 */
	private boolean doIgnore(PageNode pageNode){
		
		boolean ignore = true;
		
		String url = pageNode.getUrl().trim();
		
		if(url != null){
			ignore = !url.startsWith("http://www.smithsonianchannel.com/shows/aerial-america/701") || url.contains("?");
		}
		
		return ignore;
	}
	
	public Graph extractGraph(List<PageNode> pageNodeList){
		
		Graph graph = new Graph();
		
		Map<String, GraphNode> graphNodeMap = new HashMap<String, GraphNode>();
		
		String name = null;
		String link = null;
		
		GraphNode graphNode = null;
		GraphLink graphLink = null;
		
		for(PageNode pageNode : pageNodeList){
			
			name = pageNode.getUrl().trim();
			
			if(!graphNodeMap.containsKey(name)){
				
				graphNode = new GraphNode(Integer.valueOf(graphNodeMap.size()));
				graphNode.setUrl(name);
				
				graphNodeMap.put(name, graphNode);
			}
		}
		
		String graphLinkKey = null;
		
		Integer sourceIndex = null;
		Integer targetIndex = null;
		
		GraphNode graphNodeSource = null;
		GraphNode graphNodeTarget = null;
		
		Map<String, GraphLink> graphLinkMap = new HashMap<String, GraphLink>();
		
		for(PageNode pageNode : pageNodeList){
			
			sourceIndex = null;
			targetIndex = null;
			
			name = pageNode.getUrl().trim();
			
			graphNodeSource = graphNodeMap.get(name);
			sourceIndex = graphNodeSource.getIndex();
			for(String l : pageNode.getLinkedurls()){
				
				link = l.trim();
				
				graphNodeTarget = graphNodeMap.get(link);
				if(graphNodeTarget == null){
					graphNodeTarget = new GraphNode(Integer.valueOf(graphNodeMap.size()));
					graphNodeTarget.setUrl(link);
					graphNodeMap.put(link, graphNodeTarget);
				}
				
				targetIndex = graphNodeTarget.getIndex();
				
				graphLinkKey = sourceIndex + "_" + targetIndex;
				graphLink = graphLinkMap.get(graphLinkKey);
				if(graphLink == null){
					graphLink = new GraphLink(sourceIndex, targetIndex);
					graphLink.setSourceUrl(graphNodeSource.getUrl());
					graphLink.setTargetUrl(graphNodeTarget.getUrl());
				}
				else {
					graphLink.setValue(graphLink.getValue() + 1);
				}
				
				graphLinkMap.put(graphLinkKey, graphLink);
				graphNodeSource.setWeight(graphNodeSource.getWeight() + 1);
				
			}
		}
		
		for(String k : graphLinkMap.keySet()){
			
			graphLink = graphLinkMap.get(k);
			
			graphNode = graphNodeMap.get(graphLink.getSourceUrl());
			if(graphNode != null){
				graphNode.getSourceLinkList().add(graphLink);
			}
			
			graphNode = graphNodeMap.get(graphLink.getTargetUrl());
			if(graphNode != null){
				graphNode.getTargetLinkList().add(graphLink);
			}
		}
		
		List<GraphNode> graphNodeList = new ArrayList<GraphNode>(graphNodeMap.values());
		Collections.sort(graphNodeList);
		
		for(GraphNode n : graphNodeList){
			n.sortLinks();
		}
		
//		for(GraphNode node : graphNodeMap.values() ){
//			System.out.println(node.getUrl());
//		}
		
		graph.setNodes(graphNodeList);
		
		List<GraphLink> graphLinkList = new ArrayList<GraphLink>(graphLinkMap.values());
		graph.setLinks(graphLinkList);
		
		return graph;
	}

	/**
	 * @param args
	 * @throws Exception 
	 */
	public static void main(String[] args) throws Exception {
		
		GraphParser p = new GraphParser();
		p.parseGraph();

	}

}
