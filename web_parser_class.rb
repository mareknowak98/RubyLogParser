# Parses line to page and user address
# TODO
class WebParser
  attr_reader(:page, :address)

  def initialize(line)
    @page = "testpage"
    @address = "123.456.789"
  end

end
