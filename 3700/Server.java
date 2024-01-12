package neu;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.UUID;

public class Server {

	public static void main(String[] args) {

		final int portNumber = 8080;

		try (ServerSocket serverSocket = new ServerSocket(portNumber)) {
			System.out.println("Server is listening on port " + portNumber);

			while (true) {
				try (Socket clientSocket = serverSocket.accept();
						BufferedReader reader = new BufferedReader(
								new InputStreamReader(clientSocket.getInputStream()));
						PrintWriter writer = new PrintWriter(new OutputStreamWriter(clientSocket.getOutputStream()),
								true)) {

					System.out.println("Client connected from " + clientSocket.getInetAddress());
					
				//	String secret = "steam";
					String secret = "daddy";

					ObjectMapper objectMapper = new ObjectMapper();
					
					objectMapper.setSerializationInclusion(Include.NON_NULL);

					String inputLine;
					while ((inputLine = reader.readLine()) != null) {
						System.out.println("Received from client: " + inputLine);

						// Use ObjectMapper to bind JSON to MyData object

						Message message = objectMapper.readValue(inputLine, Message.class);

						// process n return
 
						if (message.type.equalsIgnoreCase("hello")) {
					        UUID uuid = UUID.randomUUID();
				 
					        
					        message.id = uuid.toString();
					        message.type = "start";
					        message.username = null;
							
						} else if (message.type.equalsIgnoreCase("guess")) {
							// compare to secret 	public List<Integer> marks; 	public String word;
							String word = message.word;
						 
							Guess guess = new Guess();
							guess.word = word;
							guess.marks = getMasks(word, secret);
							
							
							if (message.guesses == null) {
								message.guesses = new LinkedList<Guess>(); 
 	
							}  
								
	                       message.guesses.add(guess);
	                       // {"id":"389f23db-42e6-4261-8f35-2a5de0a5b277","type":"guess","word":"steam","guesses":[{"word":"treat","marks":[1,0,2,2,1]},{"word":"sweat","marks":[2,0,2,2,1]}]}
	                       
	                       // S -> C: {"type": "bye", "id": "foo", "flag": "sndk83nb5ks&*dk*SKDFHGk"}\n
	                       if (word.equals(secret)) {
	                    	   message.type = "bye";
	                    	   message.guesses  = null;
	                    	   message.flag = "sndk83nb5ks";
	                    	   writer.println(objectMapper.writeValueAsString(message));
	                    	   break;
	                    	   
	                       }
	 			 
							 
						}
						
						String jsonString = objectMapper.writeValueAsString(message);

						writer.println(jsonString);

					}

					System.out.println("Client disconnected");
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
	
	public static List<Integer> getMasks(String word, String secret) {
		
		List<Integer> marks = new LinkedList<Integer>(); ;
		
		for (int i = 0; i <5; i++) {
			if (word.charAt(i) == secret.charAt(i) )  {
				marks.add(2) ;
			} else if (secret.indexOf(word.charAt(i)) > -1)  {
				marks.add(1) ;
			} else {
				marks.add(0) ;
			}
		}
		
		
		return marks;
	}
}
