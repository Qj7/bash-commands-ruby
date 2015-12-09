module Commands
  class Cp
    def initialize(from_path = nil, to_path = nil)
      @from_path = from_path
      @to_path = to_path
    end

    def perform
      if @from_path.nil?
        puts "cp: missing file operand "
      elsif @to_path.nil?
        puts "cp: missing destination file operand after #{from path}"
      elsif File.directory?(@from_path) && File.file?(@to_path)
        puts "cp: cannot copy #{@from_path}: #{@to_path} is a file"
      elsif !File.directory?(@from_path) && !File.file(from_path)
        puts "cp: cannot copy #{from path}: No such file or directory"
      elsif File.file?(@from_path) && File.directory?(@to_path)
        file = Dir[@from_path]
        FileUtils.cp(file, @to_path)
      elsif File.file?(@from_path) && File.file?(@to_path)
        FileUtils.cp(@from_path, @to_path)
        name_from = File.basename(@from_path)
        arr_of_pieces = @to_path.split('/')
        arr_of_pieces.pop
        arr_of_pieces.push(name_from)
        new_file_name = arr_of_pieces.join('/') 
        File.rename(@to_path, new_file_name )
      elsif File.directory?(@from_path) && File.directory?(@to_path)
        files = Dir[@from_path + '/*']
        if files.size > 1
          files.each do |filename|
          FileUtils.cp(filename, @to_path)
          end  
        else
        FileUtils.cp(@from_path, @to_path)
        end
      elsif File.directory?(@from_path) && !Dir.exist?(@to_path)
        FileUtils::mkdir_p(@to_path + '/')
        files = Dir[@from_path + '/*']
        if files.size > 1
          files.each do |filename| 
          FileUtils.cp(filename, @to_path)
          end
        else
          FileUtils.cp(rom_path, @to_path)
        end
      end 
    end
  end
end
