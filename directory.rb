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
    push_students(name, hobby, cohort)
    puts "Now we have #{@students.count} student".center(50) if @students.count == 1
    puts "Now we have #{@students.count} students".center(50) if @students.count > 1
   name = STDIN.gets.chomp
  end
end

def push_students(name, hobby, cohort)
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
  puts "3. Save the list to students.csv".center(50)
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
    input_students
  when "2"
    show_students
  when "3"
    save_students
  when "4"
    load_students
  when "9"
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
  i = 0
  while i < @students.length
    puts "#{i.next}. #{@students[i][:name]} (hobby is #{@students[i][:hobby]})(#{@students[i][:cohort]} cohort)".center(50)
    i +=1
  end
 end

def print_footer
  puts "Now we have #{@students.count} student".center(50) if @students.count == 1
  puts "Now we have #{@students.count} students".center(50) if @students.count > 1
end

def save_students
  file = File.open("students.csv", "w")
  # iterate over the array of students
  @students.each do |student|
    student_data = [student[:name], student[:cohort]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  file.close
  puts "saved!"
end

def load_students(filename = "students.csv")
  file = File.open(filename, "r")
  file.readlines.each do |line|
  name, cohort, hobby = line.chomp.split(',')
  push_students(name, hobby, cohort)
  end
  file.close
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
