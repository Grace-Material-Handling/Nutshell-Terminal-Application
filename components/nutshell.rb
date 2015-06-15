class Nutshell
	def search(string)
		results = []
		search = $nutshell.search_universal(string)
		search.each do |key, arr|
			arr.each { |obj| results.push(obj) }
		end
		results
	end

	def search_email(email)
		results = []
		search = $nutshell.search_by_email(email)
		search.each do |key, arr|
			arr.each { |obj| results.push(obj) }
		end
		results
	end

	def search_person(query)
		query = parse(query)
		if query.class == String
			results = $nutshell.search_contacts(query)
			results.collect! { |person| self.get_contact(person['id']) }
		else
			results = $nutshell.find_contacts(query, nil,nil,nil,nil, false)
		end
		results
	end

	def search_company(name, limit)
		results = $nutshell.search_accounts(name, limit)
		results.collect! { |company| self.get_account(company['id']) }
		results
	end

	def search_lead(string, limit)
		results = $nutshell.search_leads(string, limit)
		results.collect! { |lead| self.get_lead(lead['id']) }
		results
	end


	# the following functions return extra 
	# info not returned by the functions above
	def get_account(id)
		$nutshell.get_account(id)
	end

	def get_contact(id)
		$nutshell.get_contact(id)
	end

	def get_lead(id)
		$nutshell.get_lead(id)
	end

	def all_teams
		$nutshell.find_teams()
	end
end

def parse(data)
	begin
		JSON.parse(data)
	rescue
		data
	end
end