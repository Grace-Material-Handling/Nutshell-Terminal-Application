# components/handler.rb

# require necesarry gems
require 'readline'
require "./components/nutshell.rb"
require "./components/console.rb"
require 'json'

# trap exit
trap('INT', 'SIG_IGN')

# commands
class Handler < Console

	def initialize
		@nutshell = Nutshell.new()
	end

 	# the command below allows you to search
 	# all data for a string
	def get_contact(id)
		@nutshell.get_contact(id)
	end

	def all_teams
		@nutshell.all_teams
	end

	def search(query = "")
		@nutshell.search(query)
	end

	def search_email(email = "")
		@nutshell.search_email(email)
	end

	def search_lead(query = "", limit = 50)
		@nutshell.search_lead(query, limit)
	end

	# the commands below allow you to search
	# for people by a single text quey and
	# return the refined results
	def search_person(name = "")
		@nutshell.search_person(name)
	end

	# the commands below allow you to search
	# for companies by a single text quey and
	# return the refined results
	def search_company(name = "", limit = 50)
		@nutshell.search_company(name, limit)
	end

	# def company_find_tag(tag)
	# 	NutshellCompany.new().find_tag(tag)
	# end

    # print list of commands
	def help
		Handler.instance_methods(false)
	end
end


# auto complete
LIST = Handler.instance_methods(false)
comp = proc { |s| LIST.grep( /^#{Regexp.escape(s)}/ ) }
Readline.completion_append_character = " "
Readline.completion_proc = comp