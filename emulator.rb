require 'fileutils'

class Emulator
  attr_accessor :home

  def initialize(home)
    @home = home
  end

  def run
    loop do
      puts @home + ' >'
      line = gets.chomp
      command, *args = line.split(' ')
      case  command 
      when 'cd'
        cd(*args)
      when 'ls'
        ls(*args)
      when /mv .+/
        arr = command.split
        if arr[2] == nil
          puts "mv: missing destination file operand after #{arr[1]}"
        elsif !File.directory?(arr[1]) && !File.file?(arr[1])  
          puts "mv: cannot move #{arr[1]}: No such file or directory"
        elsif File.directory?(arr[1]) && File.file?(arr[2])   
          puts "mv: cannot move #{arr[1]}: {arr[2]} is a file" 
        elsif File.file?(arr[1]) && File.directory?(arr[2])
          FileUtils::mv(arr[1], arr[2])
        elsif File.file?(arr[1]) && File.file?(arr[2])
          File.rename(arr[1], arr[2])
        elsif File.file?(arr[1]) && !File.directory?(arr[2])
          new_arr = arr[1].split('/')
          new_arr2 = arr[2].split('/')
          file = new_arr2.pop
          from_path = new_arr.join('/')+'/'
          FileUtils::mkdir_p(from_path)
          if File.directory?(from_path)
            FileUtils::mv(file, from_path)
            next
          end
        elsif File.directory?(arr[1]) && !File.directory?(arr[2])
          files = Dir[arr[1] + '/*']
          FileUtils::mkdir_p(arr[2])
          FileUtils::mv(files, arr[2])
        elsif File.directory?(arr[1]) && File.directory?(arr[2])
          FileUtils::mv(arr[1], arr[2]) 
        end
      when 'exit'
        exit
      end
    end
  end

  def cd(path)
    if File.directory?(path)
      Dir.chdir(path)
      puts @home = Dir.pwd
    else
      puts "No such directory"
    end
  end

  def ls(path = nil)
    if path.nil?
      str = Dir[@home + '/*'].join('  ')
      puts str.gsub(@home + '/', '')
    else
      if File.directory?(path)
        Dir.chdir(path)
        path_to_dir = Dir.pwd
        str = Dir[path_to_dir + '/*'].join('  ')
        puts str.gsub(path_to_dir + '/', '')
      elsif File.file?(path)
        puts File.basename(path)
      else
        puts "No such file or directory" 
      end
    end
    
  end
end

Emulator.new(ENV['HOME']).run

