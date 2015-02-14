require 'rubygems'
require 'eventmachine'

$counter = 0
$maxConections = 0
host = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
port = 8005

#------------------------------------------------------------------------------------------------------------------
#-- FUNCTION: connectionStart
#--
#-- INTERFACE: connectionStart(conn)
#--            conn: The socket that has handled the connection of the client
#--
#-- NOTES:
#-- This function notifies that a client has connected (along with its IP and port) and then adds to the total clients connected counter
#----------------------------------------------------------------------------------------------------------------------

def connectionStart(conn)
 port, host = conn.peeraddr[1,2]

 client = "#{host}:#{port}"
 puts "#{client} is connected"
 $counter=$counter + 1
 $maxConnections = $maxConnections + 1
 puts $counter.to_s+" clients connected"

end

#------------------------------------------------------------------------------------------------------------------
#-- FUNCTION: connectionEnd
#--
#-- INTERFACE: connectionEnd(conn)
#--            conn: The socket that is facilitating the connection to the client
#-- NOTES:
#-- This function is executed at the end of a connection (when a client disconnects) and subtracts from the clients connected counter
#----------------------------------------------------------------------------------------------------------------------

def connectionEnd(conn)
   port, host = conn.peeraddr[1,2]
   client = "#{host}:#{port}"
   puts "#{client} has disconnected"
   $counter=$counter -1
   puts $counter.to_s+" clients connected"

end 


module EchoServer

   def post_init
     port, ip = Socket.unpack_sockaddr_in(get_peername)
    puts "new connection to server from #{ip}:#{port}"
   end

  

   def receive_data data
     send_data ">>>you sent: #{data}"
     close_connection if data =~ /quit/i
   end

   def unbind
     #port, ip = Socket.unpack_sockaddr_in(get_peername)
    #puts "client disconnected from #{ip}:#{port}"
    puts "Someone disconnected, haven't figured out how to get the IP addr tho"
   end
end

# Note that this will block current thread.

EventMachine.run {
  EventMachine.start_server host, port, EchoServer
  puts "Listening for clients on #{host}:#{port}"
}