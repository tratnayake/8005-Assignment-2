require 'socket'
require 'logger'
$file = File.open('./logfiles/Threaded.log','w')
$logger = Logger.new($file)

server = TCPServer.new(9003)

connection = []
mutex = Mutex.new
ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
port = server.addr[1].to_s


puts "Ready to receive on "+ ip +":" + port

$counter = 0
$highestnumber

while 1
    Thread.fork(server.accept) do |client|
    connection.push(client)
    port, host = conn.peeraddr[1,2]
    client = "#{host}:#{port}"
    $counter += 1

      if $counter > $highestnumber then
         $highestnumber = $counter
         puts "#{highestnumber} clients connected"
      end

      loop do
        line = client.readline
        client.puts(line)

          if client.eof?
             mutex.synchronize do
              client.close
              connection.delete(client)
              puts "#{highestnumber} clients connected"
            end
            break
          end
      end
    end
end
