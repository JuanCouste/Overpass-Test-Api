const express = require("express")
const send = require("send")
const path = require('path')

const app = express();

app.use((req, res, next) => {
	const stream = send(req, "uruguay-2023-11.osm.bz2", {
		maxage: 0,
  		root: path.resolve("static")
	})
	
	stream.pipe(res);

	stream.on("end", () => setTimeout(() => {
		console.log("File sent, closing server")
		server.close()
	}), 1000);
})

const server = app.listen(17267, "127.0.0.1", () => {
	const address = server.address();
	console.log(`Listenting on ${typeof address == "string" ? address : address?.port}`)
})