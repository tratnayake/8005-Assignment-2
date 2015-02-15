require 'socket'

threads = []

client = 2
serveraddress = "192.168.38.146"
port = 9000
msgcounter = rand(0..5)

#Sets the amount of times a thread will be created
client.times do |t|
	#New threads are created
	threads << Thread.new(t) do |th|
			socket = TCPSocket.new serveraddress, port
			
			#Allow each clients to send different amounts of messages (Not yet done)
			for i in 0..msgcounter
			socket.puts "test"

			line = socket.gets
			STDOUT.puts line
			end
			sleep
	end
end

threads.each { |th| th.join }
