const http = require('http')

http.createServer(function(request, response) {
  response.writeHead(200)
  response.write("hello!")
  response.end()
}).listen(8080);


process.on('SIGTERM', () => {
  console.log('sigterm')
  process.exit(0)
})
process.on('SIGINT', () => {
  console.log('sigint')
  process.exit(0)
})
