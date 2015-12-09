module Commands
  class Mv
    def initialize(from_path = nil, to_path = nil)
      @from_path = from_path 
      @to_path = to_path
    end

    def perform
      if @to_path.nil?
        puts "mv: missing destination file operand after #{@from_path}"
      elsif @from_path.nil?
        puts "mv: missing file operand"
      elsif !File.directory?(@from_path) && !File.file?(from_path)
        puts "mv: cannot move #{@from_path}: No such file or directory"
      elsif File.directory?(@from_path) && File.file?(@to_path)
        puts "mv: cannot move #{@from_path}: #{@to_path} is a file"
      elsif File.file?(@from_path) && File.directory?(@to_path)
        FileUtils::mv(@from_path, @to_path)
      elsif File.file?(@from_path) && File.file?(@to_path)
        File.rename(@from_path, @to_path)
      elsif File.directory?(@from_path) && !Dir.exist?(@to_path)
        FileUtils::mkdir_p(@to_path + '/')
        files = Dir[@from_path + '/*']
        FileUtils::mv(files, @to_path)
      elsif File.directory?(@from_path) && File.directory?(@to_path)
        files = Dir[@from_path + '/*']
        FileUtils::mv(files, @to_path + '/')
      end
    end
  end
end

