require "json"
require "option_parser"
require "./norminette"

OptionParser.parse do |parser|
  parser.on "-h", "--help", "Show help" do
    temp = Norminette::Sender.new ->(result : JSON::Any) do
      puts "Norminette usage:"
      puts result["display"]
    end

    temp.publish({action: "help"}.to_json)
    temp.sync
    exit
  end

  parser.on "-v", "--version", "Show version" do
    temp = Norminette::Sender.new ->(result : JSON::Any) do
      puts result
      puts "Norminette.cr version #{Norminette::VERSION}:"
      puts "Norminette server version: #{result["display"]}"
    end

    temp.publish({action: "version"}.to_json)
    temp.sync
    exit
  end
end

def print_norme(result : JSON::Any)
  puts "Norme: #{result["filename"]}"
  puts result["display"] if result["display"].as_s?
end

def print_error(file : String)
  puts "#{File.basename(file)} is not a valid file."
end

Norminette::Validate.new(->print_norme(JSON::Any), ->print_error(String)).check ARGV
