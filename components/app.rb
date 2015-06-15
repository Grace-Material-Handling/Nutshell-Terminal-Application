# components/app.rb
require "nutshell-crm"
require "./components/handler.rb"

# application
class App
	def initialize
		# login to nutshell
		$nutshell = NutshellCrm::Client.new($username, $apiKey)
		# handler
		@handler = Handler.new
		loop do
			# puts self.prompt == "q"
			break if self.prompt[:command] == "q"
		end
	end

	def prompt
		#get command and arguments
		cmd = Readline.readline('Nutshell > ', true).sub!(/^(\s+|)/, "")
		cmds = self.parse_command(cmd)

		# watch for exit commands
		if cmds[:command] == nil
			# prevent nil error
		elsif cmds[:command] == "q"
			puts "exit"
			# allow exit
		elsif @handler.respond_to?(cmds[:command])
			# begin
			    result = @handler.method(cmds[:command]).call(*cmds[:arguments])
			# rescue
			#     puts "Error: Possible wrong usage"
			# end
		# handle errors
		else
			puts "Error: Command not found"
		end

		# allow user to grep result to filter out useful
		# information and print to console
		if cmds[:grep].length > 0
			result = grep(result, cmds[:grep])
		end

		puts result || "nil"

		# return command to application
		cmds
	end

	def parse_command(cmd_string = "")
		# prevent error on nil command
		if cmd_string == ""
			return {command: nil}
		end

		# get grep
		cmds = cmd_string.split(/\s*\|\s*/)
		if cmds.length > 1
			grep = cmds.slice!(1, cmds.length)
		end

		# split command and arguments
		cmds = cmds[0].split(/(?<!\\)[=\s+]/)
		cmds.each do |cmd|
			cmd.sub!(/\\/, "")
		end

		return {
			command: cmds.slice!(0),
			arguments: cmds,
			grep: grep || []
		}
	end

	def grep(data, greps)
		grep = greps.slice!(0,1)[0].to_s
		newData = []

		# iterate through data and collect
		# grep result
		data.each do |row|
			row = row[grep] if !row.nil?

			if row.is_a?(Array)
				newData.concat(row)
			else
				newData.push(row)
			end
		end

		# recusivly call self or return data
		if greps.length > 0
			grep(newData, greps)
		else
			newData
		end
	end
end