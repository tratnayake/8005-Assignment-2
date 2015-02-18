require 'socket'
require 'thread'
require 'thwait'
require 'logger'

$file = File.open('./logfiles/client.log','w')
$logger = Logger.new($file)

puts "How many clients would you like to connect?"
$client = gets.chomp.to_i

puts "What is the maximum number of messages you want the client to send?"
puts "Note: the number of messages will always be a random number between 0 and the number you chose"
msgcounter = gets.chomp.to_i

puts "What port are you going to be using"
port = gets.chomp.to_i

$i = 0
counter = 0
serveraddress = "192.168.38.146"

threads = []

while $i < $client
	puts $i += 1
	#New threads are created
	threads = Thread.fork() do
		socket = TCPSocket.open(serveraddress, port)
		#Start timer
		timestart = Time.now.to_f
		#	
		(1..msgcounter).each do |i|
			counter = counter + 1
			#Send a string to the server
			msg = "helloworld"
			puts msg
			socket.puts msg
			line = socket.gets
			puts line
			sleep(0.3)
		end
		#End timer
		timeend = Time.now.to_f
		#Calculate the time it took to send and receive the message
		seconds = timeend - timestart
		$logger.info "Finished #{$i}: #{seconds}"
		#Put the thread to sleep so that it does not close the connection
		sleep
	end
	sleep(0.005)
end
STDIN.gets
threads.join
