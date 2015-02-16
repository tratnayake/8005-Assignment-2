require 'socket'
require 'logger'
$file = File.open('./logfiles/Threaded.log','w')
$logger = Logger.new($file)

server = TCPServer.new(9003)


 ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
port = server.addr[1].to_s


puts "Ready to receive on "+ ip +":" + port

$counter = 0



while (connection = server.accept)
  Thread.new(connection) do |conn|
    port, host = conn.peeraddr[1,2]
    client = "#{host}:#{port}"
    puts "#{client} is connected"
    $counter=$counter + 1
    puts $counter.to_s+" clients connected"
    $logger.info "#{client} has connected"
    $logger.info $counter.to_s+" clients connected"

    begin
      loop do
        line = conn.readline
        #puts "#{client} says: #{line}"
	#puts line.chomp.size
        conn.puts(line)
      end
    rescue EOFError
      conn.close
      $counter=$counter - 1
    
      puts "#{client} has disconnected"
        puts $counter.to_s+" clients connected"
        $logger.info "#{client} has disconnected"
        $logger.info $counter.to_s+" clients connected"
    end
  end
end
