package neu;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;





public class EchoClient {

	public static void main(String[] args) {
		
		// proj1.3700.network
		  final String serverAddress = "localhost";
	     
		  // 27993 27994/s
		  final int serverPort = 8080;

	        try (Socket socket = new Socket(serverAddress, serverPort);
	        		
	             BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
	             PrintWriter writer = new PrintWriter(socket.getOutputStream(), true);
	             BufferedReader consoleReader = new BufferedReader(new InputStreamReader(System.in))) {

	            System.out.println("Connected to the server on " + serverAddress + ":" + serverPort);
	            
 
    		    String[] candidates = new String[5] ;
    		    
    		  	String[] spool = new String[] {"abcde", "fghij", "klmno", "pqrst", "uvwxy", "zzzzz"};
    	 
    		    ObjectMapper objectMapper = new ObjectMapper();
    		    
    		    objectMapper.setSerializationInclusion(Include.NON_NULL);
    			
    			
            	// first time only
                System.out.print("Enter a JSON message (or 'exit' to quit): ");
                
                String userInput = consoleReader.readLine();
                // Send JSON message to the server
                writer.println(userInput);
                String serverResponse = reader.readLine();
                
                Message message = objectMapper.readValue(serverResponse, Message.class);
	            System.out.println("Server response: " + serverResponse);
     
    		  	
	            while  (true) {
	 
	                
                   // {"type": "hello", "northeastern_username": "alex"}
	    		    
	    		    // {"id":"389f23db-42e6-4261-8f35-2a5de0a5b277","type":"guess", "word": "treat"}
	    		    // {"id":"389f23db-42e6-4261-8f35-2a5de0a5b277","type":"guess","word":"sweat","guesses":[{"word":"treat","marks":[1,0,2,2,1]}]}
	    		    // {"id":"389f23db-42e6-4261-8f35-2a5de0a5b277","type":"guess","word":"steam","guesses":[{"word":"treat","marks":[1,0,2,2,1]},{"word":"sweat","marks":[2,0,2,2,1]}]}

	    		     // steam {"id":"389f23db-42e6-4261-8f35-2a5de0a5b277","type":"guess", "word": "steam"}
	    		     // treat 
	      
	                
	            	// a-z
	            	// try all, remove 0, keep 2, shuffle 1
	            	// abcde fghij klmno pqrst uvwxy zzzzz: get all chars 1/2, try all same -> 2
	                // max 6 + 6: 12 times 
	    		    // dup:  get 2+ 2
	    		    
	    		    // loop 1s
	    		    
	    		    // guess n mark - replace non-2 with next char
	    		    
 
	                
	                if ("start".equalsIgnoreCase(message.type)) {
	                	// save flag
	                    //System.out.println("Guess it right: " + message.flag);
	                	// System.out.println("Secret: " + message.flag);
	                	// {"type": "start", "id": "foo"}\n
	                	
	                	
	                	StringBuilder sb = new StringBuilder();
	                	
	                	for (int i = 0; i < 6; i++) {
		                	message.word = spool[i];
		                	message.type = "guess";
		                    writer.println(objectMapper.writeValueAsString(message));
		                    serverResponse = reader.readLine();
		                    
		                    System.out.println("Server response: " + serverResponse);
		                    
		                    // get 2/1
		                    message = objectMapper.readValue(serverResponse, Message.class);
		                    Guess last =  message.guesses.get( message.guesses.size() - 1 ); 
		                    List<Integer> marks = last.marks;
		                    
		                    //parse marks
		                    for (int j = 0; j < 5; j++) {
		                    	if (marks.get(j) != 0) {
		                    		sb.append(spool[i].charAt(j));
		                    	}
		                    	
		                    }
		                   
		                    // max 5
		                    if (sb.length() == 5 ) {
		                    	break;
		                    }
	                		
	                	}
	                	
	                	// now we have all chars
	                	for (int i = 0; i < 5; i++) {
	                		candidates[i] = sb.toString();
	                	}
	                	
	 
	                	
                
	                } else if ("guess".equalsIgnoreCase(message.type)) {
	                	// aemst: get first char from candidates
	                	// 2 - remove rest
                 	
	                	message.type = "guess";
	                	
	                	
	                	// at most 5 times
	                	for (int i = 0; i < 5; i++) {
	                		
 	
	                      	StringBuilder sb = new StringBuilder();	                	
		                	for (int j = 0; j < 5; j++) {
		                		sb.append( candidates[j].charAt(0));
		                	}
		                	
		                	message.word = sb.toString();
		                    writer.println(objectMapper.writeValueAsString(message));
		                    serverResponse = reader.readLine();
		                    System.out.println("Server response: " + serverResponse);
	 
		                    message = objectMapper.readValue(serverResponse, Message.class);
		                    
		                    if ("bye".equalsIgnoreCase(message.type)) {
					                	// save flag
					                    System.out.println("Guess it right: " + message.flag);
					                    break;
					       }
				                    
		                    
		                    // get 2/1
		                    Guess last =  message.guesses.get( message.guesses.size() - 1 ); 
		                    List<Integer> marks = last.marks;
		                	
		                    //parse marks: 2 or 1
		                    for (int z = 0; z < 5; z++) {
		                       // 2 remove rest, 1 more head
		                    	if (marks.get(z) == 2) {
		                    		candidates[z] = candidates[z].substring(0,1);
		                    	} else {
		                    		candidates[z] = candidates[z].substring(1);
		                    	}
		                    	
		                    }
	                		
	                	}
 
	                	
	                }
	                
	                
	                
	 

	                // keep 2, discard 0, retry 1
	                
	                // spoofing first
	                
	                

	            
	            }
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	    }

	}

 
