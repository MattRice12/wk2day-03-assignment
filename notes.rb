# TOOD App

# create program where users can add tasks
# allow user to "mark" complete tasks
# have incomplete tasks still be visible on the command line
  # e.g.,:
    # Complete Tasks:
    # Task 1
    # Task 2
    # Task 3
    # ______________
    # Incomplete Tasks:
    # Task 4
    # Task 5
    # Task 6

  # or:
    # [COMPLETE] Task #1
    # [INCOMPLETE] Task #2
    # [INCOMPLETE] Task #3
    # [COMPLETE] Task #4

# use CSVs? --> Yes

# require 'csv'

#1 Array of todos:
  # todo = [
    # { task: "a", complete?: "C" },
    # { task: "b", complete?: "I" },
  # ]

#1 Creation:
  # File.open("todo.txt", "w") do |file|
    # file << ["Task", "Complete/Incomplete"]
    # todo.each do |todo|
      # file << [todo[:task], todo[:complete?]]
    # end
  # end

#2 Iterate:
  # CSV.foreach("todo.csv") do |row|
    # puts row.inspect
  # end

#3 List:
  # CSV.foreach("accounts.csv", headers:true, header_converters: :symbol) do |row|
    # puts "#{row[:task]} [#{row[:complete?]}]"
  # end

#4 Task:
  # Input for Task

#3 Complete/Incomplete
  # Input (C/I) for whether task is complete or incomplete.


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
      print "Is this task (c)omplete or (i)complete? > "
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

      todo << { :task => "#{@task_response}", :complete? => "#{@compl_response}"}

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
