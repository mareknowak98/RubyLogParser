require './web_parser_class'

parser_obj = WebParser.new("/about/2 016.464.657.359")
puts parser_obj.page
puts parser_obj.address
puts "#{parser_obj.page} != '/about/2' "
