require 'socket'
require 'thread'
require 'thwait'
require 'logger'

$file = File.open('./logfiles/client.log','w')
$logger = Logger.new($file)

puts "How many clients would you like to connect?"
$client = gets.chomp.to_i

puts "What is the maximum number of messages you want the client to send?"
msgcounter = gets.chomp.to_i

puts "What port are you going to be using"
port = gets.chomp.to_i

$i = 0
counter = 0
serveraddress = "192.168.0.14"

threads = []

STDOUT.sync = true

while $i < $client
	$i = $i + 1
	puts $i
	#New threads are created
	threads = Thread.fork() do
		socket = TCPSocket.open(serveraddress, port)
		counter = counter + 1
		#Start timer
		timestart = Time.now.to_f
			msgcounter.times do
				#Send a string to the server
				msg = "helloworld"
				puts msg
				socket.puts msg
				line = socket.gets
				puts line + "\n"
			end
		#End timer
		timeend = Time.now.to_f
		#Calculate the time it took to send and receive the message
		seconds = timeend - timestart
		puts "Time is #{seconds}, Couner is #{counter},I is #{$i}"
		$logger.info "Finished #{counter}, #{seconds}"
		#Put the thread to sleep so that it does not close the connection
		sleep
	end
end
STDIN.gets
threads.join
