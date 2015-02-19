require 'socket'
require 'logger'
$file = File.open('./logfiles/Threaded.log','w')
$logger = Logger.new($file)

server = TCPServer.new(9003)

connection = []

ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
port = server.addr[1].to_s


puts "Ready to receive on "+ ip +":" + port

$counter = 0


while 1
    Thread.fork(server.accept) do |client|
    connection.push(client)
    puts connection.length
    client = "#{host}:#{port}"
    puts "#{connection} is connected"
    $counter=$counter + 1
    puts $counter.to_s+" clients connected"
    $logger.info "#{client} has connected"
    $logger.info $counter.to_s+" clients connected"

    begin
      loop do
        line = client.readline
        client.puts(line)
      end
    rescue EOFError
      client.close
      $counter=$counter - 1
    
      puts "#{client} has disconnected"
        puts $counter.to_s+" clients connected"
        $logger.info "#{client} has disconnected"
        $logger.info $counter.to_s+" clients connected"
    end
  end
end
