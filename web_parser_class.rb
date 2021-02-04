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

  def ==(compared_obj)
    if (compared_obj != nil) and (self.page == compared_obj.page) and (self.address == compared_obj.address) then return true else false end
  end

end

class LogCounter
  attr_reader(:page_views, :unique_page_views)

  def initialize
    @page_views = Hash.new
    @unique_page_views = Hash.new

    @highest_unique = 1
    @prev_line = nil
  end

  def count(line)
    unless line.nil? then line_parsed = WebParser.new(line) else nil end
    if @prev_line == nil
      @prev_line = line_parsed
      @page_views.store(line_parsed.page, 1)
      @unique_page_views.store(line_parsed.page, 1)
      return
    end

    if line_parsed == nil
      if @highest_unique >= @unique_page_views[@prev_line.page]
        @unique_page_views[line_parsed.page] = @highest_unique
      end
      return
    end

    #count all views
    if @page_views.key?(line_parsed.page)
      @page_views[line_parsed.page] += 1
    else
      @page_views.store(line_parsed.page, 1)
    end

    #count unique views
    if @prev_line == line_parsed
      @highest_unique += 1
      @unique_page_views[line_parsed.page] += 1
    elsif @prev_line.page == line_parsed.page and @prev_line.address != line_parsed.address
      if @highest_unique >= @unique_page_views[line_parsed.page]
        @unique_page_views[line_parsed.page] = @highest_unique
      end
      @highest_unique = 1
    elsif @prev_line.page != line_parsed.page
      @unique_page_views.store(line_parsed.page, 1)
      @highest_unique = 1
    end
    @prev_line = line_parsed
  end

  def getViewsList
    @page_views = @page_views.sort_by{ |k, v| -v}
    return @page_views.map{|line| lambda{line[0].to_s() + " " + line[1].to_s() + " visits"}.call}
  end

  def getUniqueViewsList
    @unique_page_views = @unique_page_views.sort_by{ |k, v| -v}
    return @unique_page_views.map{|line| lambda{line[0].to_s() + " " + line[1].to_s() + " unique views"}.call}
  end

end
