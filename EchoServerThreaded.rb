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
    client = "#{host}:#{port}"
    puts "#{connection.length} is connected"
    $counter=$counter + 1
    puts $counter.to_s+" clients connected"
    $logger.info "#{connection.length} has connected"
    $logger.info $counter.to_s+" clients connected"

    begin
      loop do
        line = client.readline
        #puts "#{client} says: #{line}"
	#puts line.chomp.size
        client.puts(line)
      end
    rescue EOFError
      client.close
      $counter=$counter - 1
    
      puts "#{connection.length} has disconnected"
        puts $counter.to_s+" clients connected"
        $logger.info "#{connection.length} has disconnected"
        $logger.info $counter.to_s+" clients connected"
    end
  end
end
