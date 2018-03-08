class Report < ApplicationRecord
	def self.flag
		flagged = []
		return false if Report.count == 0 

		self.client_numbers.each do |client_number|
			actions = where("client_number = ?", client_number)
			flags = self.inspect_actions(actions)
			flagged.concat([flags]) unless flags.count == 0
		end
		
		flagged
	end

	def self.inspect_actions(actions)
		date_bubbles = []

		dates = actions.order('date asc').pluck(:client_number, :date, :nis_amount, :record_action_number)

		while (dates.count > 0) do 
			prev = nil
			bubble = []

			dates.each do |date|	
				if !prev 
					prev = date 
					next
				end

				if (date[1] - prev[1]).abs <= 259200
					bubble.push(prev) if bubble.count == 0
					bubble.push(date)
				end
			end

			if bubble.count == 0 && dates[0][2] >= 50000
				bubble.push(dates[0])
			end

			date_bubbles.push(bubble) if bubble.count > 0
			dates.shift
		end

		flags = []
		date_bubbles.each do |bubble|
			total_nis_amount = bubble.reduce(0){|r, n| r += n[2]; n.push(r); r}
			if total_nis_amount >= 50000 && !date_bubbles.any?{|b| bubble != b && bubble - b == []}
				flags.concat( [bubble] )
			end
		end

		flags
	end

	def self.client_numbers
		distinct.pluck(:client_number)
	end

	def self.upload(file)
		return "No file selected" if !file
		doc = SimpleXlsxReader.open(file.tempfile)
		doc.sheets[0].rows.each do |row|
			next if row[0] == 'Date'
			Report.create(date: row[0], time: row[1], record_action_number: row[2], client_number: row[3], nis_amount: row[4])
			t = Report.last.time
		  Report.last.update(date: Report.last.date.change(hour: t.hour, min: t.min, sec: t.sec)) unless !t
		end
		"File uploaded successfully"
	end

end
