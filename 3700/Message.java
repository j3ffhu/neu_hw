package neu;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.ObjectMapper;

public class Message {

	@JsonProperty("id")
	public String id;

	@JsonProperty("type")
	public String type;

	@JsonProperty("northeastern_username")
	public String username;

	@JsonProperty("word")
	public String word;

	@JsonProperty("guesses")
	public List<Guess> guesses;
}

class Guess {

	
	//  You will note that all words at exactly 5 characters long, and all words are lowercase
	@JsonProperty("word")
	public String word;

	@JsonProperty("marks")
	public List<Integer> marks;

}