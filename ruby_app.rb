require './web_parser_class'

if ARGV.length < 1
  puts "No log file specified."
elsif !File.file?(ARGV[0])
  puts "No such file."
else
  begin
    is_sorted = system("sort -k1,1 -o #{ARGV[0]} #{ARGV[0]}")
    if !is_sorted then abort("Unable to sort the file") end
    file = File.new(ARGV[0])
    file.each { |line| puts line }
  rescue Errno::EACCES => e
    puts("Can't read from #{ARGV[0]}. No permission.")
  rescue => e
    puts(e)
    puts(e.backtrace)
  end
end



