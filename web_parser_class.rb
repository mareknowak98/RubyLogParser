# Parses line to page and user address
# TODO docs
class WebParser
  attr_reader(:page, :address)

  def initialize(line)
    splitted_line = line.split(/[ ,;:-]/, 2)

    if splitted_line.length() != 2
      @page = nil
      @address = nil
      return nil
    end

    #check if page contains only letters, numbers "_" or "/"
    if splitted_line[0].match?(/^\/[a-zA-Z_\/0-9]*/) then @page = splitted_line[0] else nil end
    if splitted_line[1].match?(/^\d{3}[.]\d{3}[.]\d{3}[.]\d{3}$/)
      @address = splitted_line[1]
    else
      @address = nil
    end

  end

end
