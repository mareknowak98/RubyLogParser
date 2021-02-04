require './web_parser_class'

##run 'ruby ruby_app.rb webserver.log'
#require 1 argument - input log file
#sort input file by first column
if ARGV.length < 1
  puts "No log file specified."
elsif !File.file?(ARGV[0])
  puts "No such file."
else
  begin
    is_sorted = system("sort -k1,1 -o #{ARGV[0]} #{ARGV[0]}")
    unless is_sorted then abort("Unable to sort the file") end
    file = File.new(ARGV[0])
    log_counter = LogCounter.new
    file.each { |line|
      log_counter.count(line)
    }
    puts "---------------------"
    puts log_counter.getViewsList()
    puts "---------------------"
    puts log_counter.getUniqueViewsList()
    puts "---------------------"

  rescue Errno::EACCES => e
    puts("Can't read from #{ARGV[0]}. No permission.")
  rescue => e
    puts(e)
    puts(e.backtrace)
  end
end



