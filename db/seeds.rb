# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


doc = SimpleXlsxReader.open('book1.xlsx')
doc.sheets[0].rows.each do |row|
	next if row[0] == 'Date'
	Report.create(date: row[0], time: row[1], record_action_number: row[2], client_number: row[3], nis_amount: row[4])
	t = Report.last.time
  Report.last.update(date: Report.last.date.change(hour: t.hour, min: t.min, sec: t.sec)) unless !t
end

