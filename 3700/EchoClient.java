package neu;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

import com.fasterxml.jackson.databind.ObjectMapper;


public class EchoClient {

	public static void main(String[] args) {
		  final String serverAddress = "localhost";
	        final int serverPort = 8080;

	        try (Socket socket = new Socket(serverAddress, serverPort);
	             BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
	             PrintWriter writer = new PrintWriter(socket.getOutputStream(), true);
	             BufferedReader consoleReader = new BufferedReader(new InputStreamReader(System.in))) {

	            System.out.println("Connected to the server on " + serverAddress + ":" + serverPort);

	            while (true) {
	                System.out.print("Enter a JSON message (or 'exit' to quit): ");
	                
	                String userInput = consoleReader.readLine();
	                
	    		//	ObjectMapper objectMapper = new ObjectMapper();
	    			
//	    			Message msgToSend = new Message( );
//	    			
//	    			msgToSend.id = "123";
	    			
	    		//	String userInput = objectMapper.writeValueAsString(msgToSend);
	                
 // {"type": "hello", "northeastern_username": "alex"}

	                if ("exit".equalsIgnoreCase(userInput)) {
	                    break;
	                }

	                // Send JSON message to the server
	                writer.println(userInput);

	                // Receive and parse JSON response from the server
	                String serverResponse = reader.readLine();
	          

	                System.out.println("Server response: " + serverResponse);
	            }
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	    }

	}

 
