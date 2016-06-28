require 'csv'

class Todo
  attr_accessor :todo
  def initialize
    @todo = []
  end

  def run
    system("clear")

    loop do
      puts Messages::WELCOME
      todo_list
      read_todo_list
      prompt_add_del_end
      system("clear")
    end
  end

  private

  def task_num
    0
  end

  def todo_list
    if File.exists?('todo.csv')
      @todo = CSV.read('todo.csv', headers: true, header_converters: :symbol)
    end
    if @todo.empty? then puts Messages::EMPTY
    else
      @todo
    end
  end

  def prompt_add_del_end #Need to add a modify option
    loop do
      print Messages::TASK_OPTIONS
      response = gets.chomp
      case response.downcase
      when /(a|add)/ then return add_task
      when /(d|delete)/
        if @todo.empty? #problem <---- If the todo list is empty, cannot choose delete.
          system("clear")
          puts Messages::WELCOME
          puts Messages::EMPTY_DEL
        else
          return del_task
        end
      when /(m|modify)/
        if @todo.empty?
          system("clear")
          todo_list
          puts Messages::EMPTY_MOD
        else
          return mod_task
        end
      when /(q|quit)/
        send_to_csv ####-----------------< This one. Trying to save list b/w sessions
        exit
      else
        puts Messages::INVALID
      end
    end
  end

  def ask_task
    print Messages::ASK_ADD
    gets.chomp
  end

  def ask_complete
    loop do
    print Messages::ASK_COMPLETE
    response = gets.chomp
      case response.downcase
      when "c" then return "Complete"
      when "complete" then return "Complete"
      when "i" then return "Incomplete"
      when "incomplete" then return "Incomplete"  

      else
        puts Messages::REINPUT
      end
    end
  end

  def add_task
    @todo << { task: "#{ask_task}", complete: "#{ask_complete}" }
    send_to_csv
  end

  def send_to_csv
    CSV.open("todo.csv", "w") do |csv|
      csv << ["Task", "Complete"]
      @todo.each do |todo|
        csv << [todo[:task], todo[:complete]]
      end
    end
  end

  def mod_task # need to mod these... ".replace" is defined for hashes, not for CSVs... need to find the method for CSVs
    print Messages::SELECT_MOD
    response = gets.chomp.to_i - 1
    if todo_list[response][:complete] == "Incomplete"
      todo_list[response][:complete] = "Complete"
    else
      todo_list[response][:complete] = "Incomplete"
    end
    send_to_csv
  end

  def del_task # need to mod these... ".delete_at" is defined for hashes, not for CSVs... need to find the method for CSVs
    print Messages::SELECT_DEL
    response = gets.chomp.to_i - 1
    todo_list.delete(response)
    send_to_csv
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



# require 'pry'; binding.pry
