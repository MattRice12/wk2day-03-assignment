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
    #
    # if File.exists?('todo.csv')
    #   @todo = CSV.read('todo.csv', headers: true, header_converters: :symbol)
    # end

    CSV.open("todo.csv", "w") do |csv|
      csv << ["Task", "Complete"]
      @todo.each do |todo|
        csv << [todo[:task], todo[:complete]]
      end
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
      case response
      when /([aA]|[aA]dd)/ then return add_task
      when /([dD]|[dD]el|[dD]elete)/
        if @todo.empty? #problem <---- If the todo list is empty, cannot choose delete.
          system("clear")
          puts Messages::WELCOME
          puts Messages::EMPTY_DEL
        else
          return del_task
        end
      when /(m|M|modify|Modify)/
        if @todo.empty?
          system("clear")
          todo_list
          puts Messages::EMPTY_MOD
        else
          return mod_task
        end
      when /(q|Q|quit|Quit)/
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
      case response
      when /(c|C|complete|Complete)/ then return "Complete"
      when /(i|I|incomplete|Incomplete)/ then return "Incomplete"
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

  def mod_task
    print Messages::SELECT_MOD
    response = gets.chomp.to_i - 1
    if todo_list[response][:complete] == "Incomplete"
      todo_list[response].replace({:task => todo_list[response].fetch(:task), :complete => "Complete"})
    else
      todo_list[response].replace({:task => todo_list[response].fetch(:task), :complete => "Incomplete"})
    end
    send_to_csv
  end

  def del_task #prompts users to delete a task; deletes that task
    print Messages::SELECT_DEL
    response = gets.chomp.to_i - 1
    todo_list.delete_at(response)
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
