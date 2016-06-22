require 'csv'

print "What task would you like to add to your list? > "
task_response = gets.chomp
puts

print "Have you completed this task? >"
compl_response = gets.chomp

todo = [
  { task: "a", complete?: "C" },
  { task: "b", complete?: "I" },
]

todo << { :task => "#{task_response}", :complete? => "#{compl_response}"}

CSV.open("todo.csv", "w") do |csv|
  csv << ["Task", "Complete/Incomplete"]
  todo.each do |todo|
    csv << [todo[:task], todo[:complete?]]
  end
end

puts

todo = CSV.read("todo.csv") #not working at all

puts

CSV.foreach("todo.csv") do |row| # working
  puts row.inspect
end

puts

CSV.foreach("todo.csv", headers: true, header_converters: :symbol) do |row| #only :task is working
  puts "Task: #{row[:task]} [#{row[:complete?]}]."
end
