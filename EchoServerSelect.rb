require 'socket'

$counter = 0
$maxConnections = 0


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
   port, host = socketVar.peeraddr[1,2]
   client = "#{host}:#{port}"
   puts "#{client} has disconnected"
   $counter=$counter -1
   puts $counter.to_s+" clients connected"

end 



##############################MAIN AREA#########################


server = TCPServer.new(8000)

#Call google to find out what the local IP is
ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
port = server.addr[1].to_s


puts "Ready to receive on "+ ip +":" + port

while (connection = server.accept)
  #When the server accepts a connection, spawn a new thread to handle it
  Thread.new(connection) do |conn|

    #Declare who connected, and increment counters
    connectionStart(conn)
 
    #While the client is connected, do this
   while true do
      #Add this socket to select to be monitored by kernel 
      connections = IO.select([conn])
      #ready will contain any connections that are ready to be read
      ready = connections[0]
      #for each connection in ready
      ready.each do |socketVar| 
        #have a buffer that reads 80 bytes in a non blocking manner (??)
        buf = socketVar.recv_nonblock(80)
        #If a socket becomes active but the length is 0, that means client has Disconnected 
        if (buf.length)==0
         #declare client disconnect and decrement counters
         connectionEnd(conn)
         #Kill the current thread as it is no longer to handle the client it started with
         Thread.kill(conn)
        #Anything else that has a length greater than 0 means a message, so echo it back 
        else
          socketVar.puts(buf)
        end
      end
    end
  end

end



 

