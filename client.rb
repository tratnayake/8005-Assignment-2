require 'socket'

puts "How many clients would you like to connect?"
client = gets.chomp.to_i

puts "What is the maximum number of messages you want the client to send?"
puts "Note: the number of messages will always be a random number between 0 and the number you chose"
maxcounter = gets.chomp.to_i
counter = 0
serveraddress = "192.168.38.146"
port = 9000

threads = []
#Sets the amount of times a thread will be created
client.times do |t|
	#New threads are created
	threads << Thread.new(t) do |th|
		#Sets the random number generator between 0 and the number the user chose
		msgcounter = rand(1..maxcounter)
		socket = TCPSocket.new serveraddress, port
		#Start timer
		timestart = Time.now.to_f
		#Allow each clients to send different amounts of messages	
		(1..msgcounter).each do |i|
			counter = counter + 1
			#Send a string to the server
			socket.puts "Hello " + counter.to_s
			line = socket.gets
			puts line
		end
		#End timer
		timeend = Time.now.to_f
		seconds = timeend - timestart
		puts seconds
		sleep
	end
end

threads.each { |th| th.join }
