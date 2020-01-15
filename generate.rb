## generate IP address
def getIP server_idx
	a = 192
	b = 168
	c = server_idx / 100 + 1
	d = server_idx % 100 + 1

	"#{a}.#{b}.#{c}.#{d}"
end

## generate random CPU usage
def getCPUUsage
	Random.new.rand(0..100) 
end

## stdin DATA_PATH
path = ARGV[0] || "./"
## filename
filename = "logs.txt"
dir = File.dirname(path)
puts "file path : #{dir}/#{filename}"

## generate log data
log_data = Array.new
puts "generating..."

## every minute for 1 day (2019-01-09 00:00:00 to 2019-01-09 23:59:59)
1546992000.step(1547078400, 60) do |timestamp|
	## 1000 servers
	1000.times do |server|
		server_ip = getIP server
		## 2 CPU
		2.times do |cpu|
			log_data << "#{timestamp} #{server_ip} #{cpu} #{getCPUUsage()}"
		end
	end
end

save_file = File.join(dir, "logs.txt")
File.open(save_file, "w") do |file|
	file.write log_data.join("\n")
end
puts "sample log file is created."
