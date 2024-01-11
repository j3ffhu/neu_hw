package neu;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.ObjectMapper;

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

					ObjectMapper objectMapper = new ObjectMapper();

					String inputLine;
					while ((inputLine = reader.readLine()) != null) {
						System.out.println("Received from client: " + inputLine);

						// Use ObjectMapper to bind JSON to MyData object
 
						
						
						Message message = objectMapper.readValue(inputLine, Message.class);

						// process n return
						
						
						

			  
 
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
	}

}
