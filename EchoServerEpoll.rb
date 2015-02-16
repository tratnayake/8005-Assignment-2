require 'rubygems'
require 'eventmachine'
require 'logger'

$file = File.open('./logfiles/Epoll.log','w')
$logger = Logger.new($file)

host = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
port = 9000

module EchoServer




  $counter = 0
  def post_init
    port, ip = Socket.unpack_sockaddr_in(get_peername)
    client = "#{ip}:#{port}"
    puts "#{client} has connected"
    $logger.info "#{client} has connected"

    $counter += 1
    puts $counter.to_s + " clients connected"
    $logger.info $counter.to_s + "clients connected"
  end

  def receive_data data
    send_data "#{data}"
    #puts "#{data.chomp}"
  end

  def unbind 
    puts "client disconnected"
    $logger.info "client disconnected"
    $counter -= 1
    puts $counter.to_s + " clients connected"
    $logger.info $counter.to_s + " clients connected"
  
  end

end #End module EchoServer

# Note that this will block current thread.
EM.epoll

begin
new_size = EM.set_descriptor_table_size( 100000 )
rescue Exception => e
puts "Exception:: " + e.message + "\n"
puts "> Unable to set total file descriptors"
end

EM.run {
  EM.start_server host, port, EchoServer
  puts "Listening for clients on #{host}:#{port}"
  $logger.info "Server started"
}
