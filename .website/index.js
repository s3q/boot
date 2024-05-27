// fetch("http://localhost:8080/api/s/newKey", {
//   method: "POST",
//   body: JSON.stringify({
//     key: "9389583",
//   }),
//   headers: {
//     "Content-type": "application/json; charset=UTF-8"
//   }
// });

const ConnectedClient = document.getElementById("connected_clients")

fetch("http://localhost:8080/api/s/clients", {
  method: "GET",
 
  headers: {
    "Content-type": "application/json; charset=UTF-8"
  }
}).then( async (res) => {
    let data = await res.text()
    let dataJson =JSON.parse(data)
    // console.log(data)
    ConnectedClient.textContent = dataJson.length

})