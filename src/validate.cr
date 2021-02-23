class Norminette::Validate
  def initialize(callback : Proc)
    @sender = Norminette::Sender.new callback
  end

  def check(files : Array(String))
    check_recursive files.any? ? files : [CURRENT_PATH]
    @sender.sync
  end

  private def is_valid_file?(file : String)
    ext = File.extname(file)
    File.file?(file) && File.exists?(file) && (ext == ".h" || ext == ".c")
  end

  private def check_recursive(files : Enumerable(String))
    files.each do |file|
      file = File.join(CURRENT_PATH, file) if !Path[file].absolute?

      if File.directory? file
        check_recursive Dir["#{file}/*"]
      else
        unless is_valid_file? file
          puts "#{File.basename(file)} is not a valid file."
          next
        end

        send_file file
      end
    end
  end

  def send_file(file : String)
    send ({filename: File.basename(file), content: File.read(file)}).to_json
  end

  def send(content : String)
    @sender.publish content
  end
end
