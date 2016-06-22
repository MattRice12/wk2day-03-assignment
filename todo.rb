require 'csv'

class Todo
  attr_accessor :ask_task, :ask_complete, :todo
  def initialize
    @task_response = ask_task
    @compl_response = ask_complete
  end

  def run
    add_task
    read_todo_list
  end

  def ask_task
    print "\nWhat task would you like to add to your list? > "
    gets.chomp
  end

  def ask_complete
    loop do
    print "\nIs this task (c)omplete or (i)ncomplete? > "
    response = gets.chomp
      case response
      when /(c|C|complete|Complete)/
        return "Complete"
      when /(i|I|incomplete|Incomplete)/
        return "Incomplete"
      else
        puts "Sorry, I didn't get that...\n\n"
      end
    end
  end

  def add_task
    @todo = [
      { task: "Go to the store", complete: "Complete" },
      { task: "Eat pizza", complete: "Incomplete" }
    ]

    @todo << { :task => "#{@task_response}", :complete => "#{@compl_response}" }

    CSV.open("todo.csv", "w") do |csv|
      csv << ["Task", "Complete"]
      @todo.each do |todo|
        csv << [todo[:task], todo[:complete]]
      end
    end
  end

  def read_todo_list
    puts

    CSV.foreach("todo.csv") do |row| # working
      puts row.inspect
    end

    puts

    CSV.foreach("todo.csv", headers: true, header_converters: :symbol) do |row|
      puts "Task: #{row[:task]} [#{row[:complete]}]."
    end
  end
end

Todo.new.run
