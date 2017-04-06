const http = require('http')

const server = http.createServer((req, res)=> {
  res.writeHead(200)
  console.log('%s request!', Date.now(), req.headers)
  res.write("hello!")
  res.end()
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
