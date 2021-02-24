class Norminette::Validate
  def initialize(callback : Proc(JSON::Any, Nil), error : Proc(String, Nil))
    @sender = Norminette::Sender.new callback
    @error = error
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
      if File.directory?(file) && !File.symlink?(file)
        check_recursive Dir["#{file}/*"]
      else
        if is_valid_file? file
          send_file file
          next
        end

        @error.call file
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
