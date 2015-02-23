#------------------------------------------------------------------------------------------------------------------
#-- PROGRAM: Multi-Threaded Echo Server
#--
#-- Authors: Elton Sia (A00800541) & Thilina Ratnayake (A00802338) 
#--
#-- Description:
#-- This program is an echo server that spawns multiple threads to handle connecting clients and then echos data back.
#
#-- Command Line Arguments: NONE
#----------------------------------------------------------------------------------------------------------------------
require 'socket'
require 'logger'

$PORT=6000
#File to use for logfile
$file = File.open('./logfiles/Threaded.log','w')
#Initialize logger
$logger = Logger.new($file)

#Create a server socket on port.
server = TCPServer.new($PORT)

#counter for number of clients connected
$counter = 0

#Contact server to determine host IP Address (purely to print out)
 ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
port = server.addr[1].to_s

puts "Ready to receive on "+ ip +":" + port


while (connection = server.accept)
#When we accept a connection, spawn a new thread.
  Thread.new(connection) do |conn|
   #Grab the ip and port that the client has connected on.
    port, host = conn.peeraddr[1,2]
    client = "#{host}:#{port}"
    puts "#{client} is connected"
    #Increment the counter
    $counter=$counter + 1
    puts $counter.to_s+" clients connected"
    #Log pertinent information
    $logger.info "#{client} has connected"
    $logger.info $counter.to_s+" clients connected"

  #While the client is connected...
    begin
      loop do
       #Read from buffer of size 2048
        data = conn.read(2048)
              #Write what's in socket to client 
              conn.write(data)
              #Flush it
              conn.flush
      end
      #If client terminates (CTRL+C)
    rescue EOFError
     #Close the connection
      conn.close
      #Decrement counter
      $counter=$counter - 1
        puts "#{client} has disconnected"
        puts $counter.to_s+" clients connected"
        $logger.info "#{client} has disconnected"
        $logger.info $counter.to_s+" clients connected"
    end
  end
end
