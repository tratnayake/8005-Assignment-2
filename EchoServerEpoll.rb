#------------------------------------------------------------------------------------------------------------------
#-- PROGRAM: Multi-Threaded Echo Server (Using EPOLL)
#--
#-- Authors: Elton Sia (A00800541) & Thilina Ratnayake (A00802338) 
#--
#-- Description:
#-- This program is a single threaded echo server that utilizes the eventmachine library to use the EPOLL system call to handle
# sockets then echos data back.
#
#-- Command Line Arguments: NONE
#----------------------------------------------------------------------------------------------------------------------

require 'rubygems'

require 'eventmachine'

require 'logger'

puts "What port do you want to listen on?"
$PORT = gets.to_i


#File to use for logfile
$file = File.open('./logfiles/Epoll.log','w')
#Initialize logger
$logger = Logger.new($file)

#Contact an external server to determine local IP address (purely just to print out)
host = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
port = $PORT

module EchoServer
  #Coutner for number of clients connected
  $counter = 0
  #Define what to do when a client connects (When there is activity on socket)
  def post_init
    port, ip = Socket.unpack_sockaddr_in(get_peername)
    client = "#{ip}:#{port}"
    puts "#{client} has connected"
    $logger.info "#{client} has connected"
    #Increment counter
    $counter += 1
    puts $counter.to_s + " clients connected"
    $logger.info $counter.to_s + "clients connected"
  end

  #Define what to do when a socket receives data (Echo it back)
  def receive_data data
    send_data "#{data}"
  end

  #Define what to do when a client sends a termination signal (CTRL+C)
  def unbind 
    puts "client disconnected"
    $logger.info "client disconnected"
    $counter -= 1
    puts $counter.to_s + " clients connected"
    $logger.info $counter.to_s + " clients connected"
  
  end

end #End module EchoServer

#Execute epoll library using eventmachine
EM.epoll

#Forever loop
begin
#Raise ULIMIT
new_size = EM.set_descriptor_table_size( 100000 )
rescue Exception => e
puts "Exception:: " + e.message + "\n"
puts "> Unable to set total file descriptors"
end

EM.run {
  #Start server and block with EPOLL
  EM.start_server host, $PORT, EchoServer
  puts "Listening for clients on #{host}:#{port}"
  $logger.info "Server started"
}
