require 'readline'
require 'time'

class Query 
	def initialize data_file
		puts "initialinzing ..."
		@hash_table = {}
		data_file.each_line.with_index do |line, index|
			data = line.split(/ /)
			@hash_table[data[1]] = [] if !@hash_table.has_key?(data[1])
			@hash_table[data[1]] << { time: data[0], cpu: data[2], usage: data[3].gsub!("\n",'')}
		end
		puts "done"
	end

	def query ip_address, cpu_id, start_time, end_time
		start_timestamp = Time.parse("#{start_time} +0000").to_i
		end_timestamp = Time.parse("#{end_time} +0000").to_i
		data = @hash_table["#{ip_address}"]
		rtn = []
		@hash_table["#{ip_address}"].each do |item|
			if item[:cpu] == cpu_id && item[:time].to_i >= start_timestamp && item[:time].to_i <= end_timestamp
				rtn << "(#{DateTime.strptime(item[:time],'%s').strftime("%F %H:%M")}, #{item[:usage]}%)"
			end
		end
		rtn.join(',')
	end
end

path = ARGV[0] || "./"
filename = "logs.txt"
data_file = File.open "#{path}/#{filename}", "r"

# make an object  
# Objects are created on the heap  
query = Query.new(data_file)  

query_pattern = /^QUERY ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) (0|1) ([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) ((2[0-3]|[01][0-9]):[0-5][0-9])) ([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) ((2[0-3]|[01][0-9]):[0-5][0-9]))/i
while input = Readline.readline("> ", true)
	case input
	when "exit" 
		break
	when query_pattern
		regex_item = input.scan(query_pattern).first
		ip_address 	= regex_item[0]
		cpu_id 			= regex_item[1]
		start_time 	= regex_item[2]
		end_time 		= regex_item[7]
		puts "CPU#{cpu_id} usage on #{ip_address}:"
		puts query.query ip_address, cpu_id, start_time, end_time
	else
		puts "Usage: QUERY IP cpu_id time_start time_end"
		puts "  example: QUERY 192.168.10.100 1 2019-01-09 13:00 2019-01-09 13:05"
	end
end
