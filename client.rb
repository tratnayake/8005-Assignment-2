require 'socket'
require 'thread'
require 'thwait'
require 'logger'

puts "How many clients would you like to connect?"
client = gets.chomp.to_i

puts "What is the maximum number of messages you want the client to send?"
puts "Note: the number of messages will always be a random number between 0 and the number you chose"
maxcounter = gets.chomp.to_i

i = 0
counter = 0
serveraddress = "192.168.38.146"
port = 9000

threads = []

while i < client
	i += 1
	#New threads are created
	threads = Thread.fork() do
		#Sets the random number generator between 0 and the number the user chose
		msgcounter = rand(1..maxcounter)
		socket = TCPSocket.open(serveraddress, port)
		#Start timer
		timestart = Time.now.to_f
		#Allow each clients to send different amounts of messages	
		(1..msgcounter).each do |i|
			counter = counter + 1
			#Send a string to the server
			msg = "Hello #{counter}"
			puts msg
			puts counter
			counter.puts msg
			line = socket.gets
			puts line
			sleep(0.3)
		end
		#End timer
		timeend = Time.now.to_f
		#Calculate the time it took to send and receive the message
		seconds = timeend - timestart
		puts seconds
		#Put the thread to sleep so that it does not close the connection
		sleep
	end
end
ThreadsWait.all_waits(*threads)
