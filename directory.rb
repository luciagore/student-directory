require 'csv'
@students = []

def input_students
  puts "Please enter the names of the students, followed by their favourite
   hobby, and cohort".center(50)
  puts "To finish, just hit return twice".center(50)

  puts "Name: ".center(50)
  name = STDIN.gets.delete("\n")
  puts "Hobby: ".center(50)
  hobby = STDIN.gets.delete("\n")
  puts "Cohort: ".center(50)
  cohort = STDIN.gets.delete("\n")

  while !name.empty? do
    cohort = 'n/a' if cohort.empty?
    hobby = 'n/a' if hobby.empty?
    add_students(name, hobby, cohort)
    puts "Now we have #{@students.count} student".center(50) if @students.count == 1
    puts "Now we have #{@students.count} students".center(50) if @students.count > 1
    puts "Name: ".center(50)
    name = STDIN.gets.delete("\n")
    if !name.empty?
      puts "Hobby: ".center(50)
      hobby = STDIN.gets.delete("\n")
      puts "Cohort: ".center(50)
      cohort = STDIN.gets.delete("\n")
    end
  end
end

def add_students(name, hobby, cohort)
  @students << {name: name, hobby: hobby, cohort: cohort.to_sym}
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.delete("\n"))
  end
end

def print_menu
  puts "1. Input the students".center(50)
  puts "2. Show the students".center(50)
  puts "3. Save the list to file".center(50)
  puts "4. Load the list from students.csv".center(50)
  puts "9. Exit".center(50) # 9 because we'll be adding more items
end

def show_students
  print_header
  print_student_list
  print_footer
end

def process(selection)
  case selection
  when "1"
    puts "You've selected to input new students".center(50)
    input_students
  when "2"
    puts "You've selected to show the current students".center(50)
    show_students
  when "3"
    puts "whats the file name?".center(50)
    filename = STDIN.gets.chomp
    save_students(filename)
  when "4"
    puts "You've selected to load the current students in 'students.csv'".center(50)
    load_students
  when "9"
    puts "You've selected to exit the program.".center(50)
    exit # this will cause the program to terminate
  else
    puts "I don't know what you meant, try again".center(50)
  end
end

def print_header
  puts "The students of Villains Academy".center(50)
  puts "-------------".center(50)
end

def print_student_list
  if @students.length > 0
     @students.group_by{|student| student[:cohort]}.map do |month, students|
       puts "#{month}".center(50)
       students.map{|student| puts "#{student[:name]}, hobby is #{student[:hobby]}".center(50)}
     end
  else
    puts "There are no students"
  end
end

def print_footer
  puts "Now we have #{@students.count} student".center(50) if @students.count == 1
  puts "Now we have #{@students.count} students".center(50) if @students.count > 1
end

def save_students(filename = 'students.csv')
  CSV.open(filename, "w") do |file|
      @students.each do |student|
        file << [student[:name], student[:cohort], student[:hobby]]
      end
    end
end

def load_students(filename = 'students.csv')
  CSV.foreach(filename, headers: false) do |row|
    add_students(row[0], row[1], row[2])
  end
end

def try_load_students
  filename = ARGV.first # first argument from the command line
  return if filename.nil? # get out of the method if it isn't given
  if File.exists?(filename) # if it exists
    load_students(filename)
     puts "Loaded #{@students.count} from #{filename}".center(50)
  else # if it doesn't exist
    puts "Sorry, #{filename} doesn't exist.".center(50)
    exit # quit the program
  end
end

try_load_students
interactive_menu
