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
   port, host = conn.peeraddr[1,2]
   client = "#{host}:#{port}"
   puts "#{client} has disconnected"
   $counter=$counter -1
   puts $counter.to_s+" clients connected"

end 



##############################MAIN AREA#########################

#1. Create first socket
server = TCPServer.new(8000)
connSockets = Array.new

#Call google to find out what the local IP is
ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
port = server.addr[1].to_s


puts "Ready to receive on "+ ip +":" + port
connSockets.push(server);


#2. Call listen on that socket
server.listen(1000000);


#3. block on that socket
while true
  selectVars = IO.select(connSockets)
  #IMPORTANT POINT , connSockets is a dynamic array that can be changing. 
  #so when a new connection happens, it can be added to elsewhere

  #4. Inside select, check if it was triggered for data packets or a new connection
  #puts selectVars[0].size
  #puts selectVars[0]
  selectVars[0].each do |socketVar|
    if socketVar == connSockets[0]
      #puts "Triggered by server"
      #2A: The server socket only becomes active if its a new connection
      #so add the dude to the array
      newSocket = server.accept;
      connSockets.push(newSocket)
      connectionStart(newSocket);
     else
        #puts "Triggered by new connection so probably a message"
        buf = socketVar.recv_nonblock(80)
        #If a socket becomes active but the length is 0, that means client has Disconnected 
        if (buf.length)==0
        #declare client disconnect and decrement counters
          #connectionEnd(socketVar)

          #puts "Client disconnected"
          connectionEnd(socketVar)
          connSockets.delete_if{|socket| socket == socketVar}
          #puts "Deleted from array"
          break
        #Anything else that has a length greater than 0 means a message, so echo it back 
        else
        socketVar.puts(buf)
        end
     end 
  end
end













 

