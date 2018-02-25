class Report < ApplicationRecord

	def self.flag
		flagged = []

		self.client_numbers.each do |client_number|
			actions = where("reports.client_number = #{client_number}")
			prev = nil;
			actions.each do |action|
				if !prev
					prev = action 
					next
				end
				if (action.date - prev.date) <= 259200
					flagged << action.record_action_number
				end
				prev = action
			end
		end

		flagged
	end

	def self.client_numbers
		distinct.pluck(:client_number)
	end

	def self.upload(file)
		doc = SimpleXlsxReader.open(file.tempfile)
		doc.sheets[0].rows.each do |row|
			next if row[0] == 'Date'
			Report.create(date: row[0], time: row[1], record_action_number: row[2], client_number: row[3], nis_amount: row[4])
			t = Report.last.time
		  Report.last.update(date: Report.last.date.change(hour: t.hour, min: t.min, sec: t.sec)) unless !t
		end
	end


end
