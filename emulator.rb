require 'fileutils'

class Emulator
  attr_accessor :home

  def initialize(home)
    @home = home
  end

  def run
    loop do
      print @home + ' > '
      line = gets.chomp
      command, *args = line.split(' ')
      case  command 
      when 'cd'
        cd(*args)
      when 'ls'
        ls(*args)
      when 'mv'
        mv(*args)
      when 'cp'
        cp(*args)
      when 'rm'
        rm(*args)
      when 'exit'
        exit
      end
    end
  end

  def cd(path)
    if File.directory?(path)
      Dir.chdir(path)
      @home = Dir.pwd
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
 
  def mv(from_path = nil, to_path = nil)
    if to_path.nil?
      puts "mv: missing destination file operand after #{from_path}"
    elsif from_path.nil?
      puts "mv: missing file operand"
    elsif !File.directory?(from_path) && !File.file?(from_path)  
      puts "mv: cannot move #{from_path}: No such file or directory"
    elsif File.directory?(from_path) && File.file?(to_path)   
      puts "mv: cannot move #{from_path}: #{to_path} is a file" 
    elsif File.file?(from_path) && File.directory?(to_path)
      FileUtils::mv(from_path, to_path)
    elsif File.file?(from_path) && File.file?(to_path)
      File.rename(from_path, to_path)
    elsif File.directory?(from_path) && !Dir.exist?(to_path)
      FileUtils::mkdir_p(to_path + '/')
      files = Dir[from_path + '/*']
      FileUtils::mv(files, to_path)
    elsif File.directory?(from_path) && File.directory?(to_path)
      files = Dir[from_path + '/*']
      FileUtils::mv(files, to_path + '/') 
    end
  end

  def cp(from_path = nil, to_path = nil)
    if from_path.nil?
      puts "cp: missing file operand "
    elsif to_path.nil?
      puts "cp: missing destination file operand after #{from path}"
    elsif File.directory?(from_path) && File.file?(to_path)
      puts "cp: cannot copy #{from_path}: #{to_path} is a file"
    elsif !File.directory?(from_path) && !File.file(from_path)
      puts "cp: cannot copy #{from path}: No such file or directory"
    elsif File.file?(from_path) && File.directory?(to_path)
      file = Dir[from_path]
      FileUtils.cp(file, to_path)
    elsif File.file?(from_path) && File.file?(to_path)
      FileUtils.cp(from_path, to_path)
      name_from = File.basename(from_path)
      arr_of_pieces = to_path.split('/')
      arr_of_pieces.pop
      arr_of_pieces.push(name_from)
      new_file_name = arr_of_pieces.join('/') 
      File.rename(to_path, new_file_name )
    elsif File.directory?(from_path) && File.directory?(to_path)
      files = Dir[from_path + '/*']
      if files.size > 1
        files.each do |filename|
        FileUtils.cp(filename, to_path)
        end  
      else
        FileUtils.cp(from_path, to_path)
      end
    elsif File.directory?(from_path) && !Dir.exist?(to_path)
      FileUtils::mkdir_p(to_path + '/')
      files = Dir[from_path + '/*']
      if files.size > 1
        files.each do |filename| 
        FileUtils.cp(filename, to_path)
        end
      else
        FileUtils.cp(rom_path, to_path)
      end
    end 
  end

  def rm(path)
    if File.file?(path) || File.directory?(path)
      if File.file?(path)
        check = 'file' 
      else
        check = 'directory'
      end
      puts "Are you sure you want to remove #{check}: #{path} (Y/n))?"
      answer = gets.chomp
      if answer == 'Y' || answer = 'y' || answer == 'Yes' || answer == 'yes'
        if File.file?(path)
          FileUtils.rm(path)
        else
          FileUtils.rmdir(path)
        end
      end
    else 
      puts "rm: cannot remove #{path}: No such file or directory"
    end
  end
end

Emulator.new(ENV['HOME']).run
