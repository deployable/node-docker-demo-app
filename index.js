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
  console.error('SIGTERM, exiting')
  process.exit(0)
})
process.on('SIGINT',  () => {
  console.error('SIGINT, exiting')
  process.exit(0)
})
// nodemon signal
process.once('SIGUSR2', () => {
  console.error('SIGUSR2, restarting')
  process.kill(process.pid, 'SIGUSR2')
})
