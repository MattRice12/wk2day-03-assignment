require 'csv'

class Todo
  attr_accessor :todo
  def initialize
    @todo = []
  end

  def task_num
    0
  end

  def welcome
    puts "Welcome to the task manager! You currently have the following tasks: "
  end

  def todo_list
    CSV.open("todo.csv", "w") do |csv|
      csv << ["Task", "Complete"]
      @todo.each do |todo|
        csv << [todo[:task], todo[:complete]]
      end
    end
    
    if @todo == []
      puts "\nYour list is empty!"
    else
      @todo #problem <--- this resets the array when the program is opened again. Need to set it to where it just pulls from todo.csv
    end
  end

  def run
    system("clear")
    loop do
      welcome
      todo_list
      read_todo_list
      prompt_add_del_end
      system("clear")
    end
  end

  def prompt_add_del_end #Need to add a modify option
    loop do
      print "\nTask Options: (a)dd, (m)odify, (d)elete, (q)uit."
      response = gets.chomp
      case response
      when /(a|A|add|Add)/
        return add_task
      when /(d|D|del|Del|delete|Delete)/
        if @todo == [] #problem <---- If the todo list is empty, cannot choose delete.
          system("clear")
          welcome
          puts "\nYour list is empty! You have nothing here to delete."
        else
          return del_task
        end
      when /(m|M|modify|Modify)/
        if @todo == []
          system("clear")
          welcome
          puts "\nYour list is empty! You have nothing here to modify."
        else
          return mod_task
        end
      when /(q|Q|quit|Quit)/
        exit
      else
        puts "___________________________"
        puts "That is not a valid option."
      end
    end
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
    @todo << { :task => "#{ask_task}", :complete => "#{ask_complete}" }
    send_to_csv
  end

  def send_to_csv
    CSV.open("todo.csv", "w") do |csv|
      csv << ["Task", "Complete"]
      todo_list.each do |todo|
        csv << [todo[:task], todo[:complete]]
      end
    end
  end

  def mod_task
    puts
    print "Please select a task you would like to modify. > "
    response = gets.chomp
    if todo_list[response.to_i - 1][:complete] == "Incomplete"
      todo_list[response.to_i - 1].replace({:task => todo_list[response.to_i - 1].fetch(:task), :complete => "Complete"})
    else
      todo_list[response.to_i - 1].replace({:task => todo_list[response.to_i - 1].fetch(:task), :complete => "Incomplete"})
    end

    CSV.open("todo.csv", "w") do |csv|
      csv << ["Task", "Complete"]
      todo_list.each do |todo|
        csv << [todo[:task], todo[:complete]]
      end
    end
  end

  def del_task #prompts users to delete a task; deletes that task
    puts
    print "Please select a task you would like to delete. > "
    response = gets.chomp

    todo_list.delete_at(response.to_i - 1)

    CSV.open("todo.csv", "w") do |csv|
      csv << ["Task", "Complete"]
      @todo.each do |todo|
        csv << [todo[:task], todo[:complete]]
      end
    end
  end

  def read_todo_list
    puts
    task_num = 1
    CSV.foreach("todo.csv", headers: true, header_converters: :symbol) do |row|
      puts "Task #{task_num}: #{row[:task]} [#{row[:complete]}]."
    task_num += 1
    end
  end
end

Todo.new.run

# require 'pry'; binding.pry
