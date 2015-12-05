require 'fileutils'
home = ENV['HOME']
loop do
  puts home + ' >'
  command = gets.chomp
  case  command 
  when /cd .+/
    check = command.scan(/(?<=cd\s).+/).join
    if File.directory?(check)
      Dir.chdir(check)
      puts home = Dir.pwd
    else
      puts "No such directory"
    end
  when 'ls' 
    str = Dir[home + '/*'].join('  ')
    puts str.gsub(home + '/', '')
  when /ls .+/
    check = command.scan(/(?<=ls\s).+/).join
    if File.directory?(check)
      Dir.chdir(check)
      path_to_dir = Dir.pwd
      str = Dir[path_to_dir + '/*'].join('  ')
      puts str.gsub(path_to_dir + '/', '')
    elsif File.file?(check)
      puts File.basename(check)
    else
      puts "No such file or directory" 
    end
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

