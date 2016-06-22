require 'csv'

class Todo
  attr_accessor :ask_task, :ask_complete
  def initialize
    @task_response = ask_task
    @compl_response = ask_complete
  end

  def run
    add_task
    read_todo_list
  end

  def todo_list

  end

  def ask_task
    print "What task would you like to add to your list? > "
    gets.chomp
  end

  def ask_complete
    loop do
    print "Is this task (c)omplete or (i)ncomplete? > "
    response = gets.chomp
      case response
      when /(c|C|complete|Complete)/
        return "Complete"
        break
      when /(i|I|incomplete|Incomplete)/
        return "Incomplete"
        break
      else
        puts "Sorry, I didn't get that...\n\n"
      end
    end
  end

  def add_task
    todo = [
      { task: "a", complete?: "C" },
      { task: "b", complete?: "I" },
    ]

    todo << { :task => "#{@task_response}", :complete? => "[#{@compl_response}]" }

    CSV.open("todo.csv", "w") do |csv|
      csv << ["Task", "Complete/Incomplete"]
      todo.each do |todo|
        csv << [todo[:task], todo[:complete?]]
      end
    end
  end

  def read_todo_list
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
  end
end

Todo.new.run
