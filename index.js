const http = require('http')

const server = http.createServer((request, response)=> {
  response.writeHead(200)
  console.log('%s request!', Date.now())
  response.write("hello!")
  response.end()
}).listen(8080, ()=> console.log('Listening on %s', server.address().port))

// A process needs to handle any signals if it's running
// as PID 1 in Docker
process.on('SIGTERM', () => {
  console.log('sigterm')
  process.exit(0)
})

process.on('SIGINT', () => {
  console.log('sigint')
  process.exit(0)
})
