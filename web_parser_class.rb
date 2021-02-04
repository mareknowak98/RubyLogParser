## This class represents a single page view
# Holds page name, and address which was visited
class WebParser
  #getters for @page and @address
  attr_reader(:page, :address)

  #parse single line into WebParser object
  #line can be in format:
  #/index 451.106.204.921
  #page must start with '/' and contain only [a-zA-Z_\/0-9] - else = nil
  #address must be in format d{3}[.]\d{3}[.]\d{3}[.]\d{3} - else = nil
  #accepted delimiters: [ ,;:-] - else (@page and @address) = nil
  def initialize(line)
    split_line = line.split(/[ ,;:-]/, 2)

    if split_line.length() != 2
      @page = nil
      @address = nil
      return nil
    end

    if split_line[0].match?(/^\/[a-zA-Z_\/0-9]*/) then @page = split_line[0] else nil end
    if split_line[1].match?(/^\d{3}[.]\d{3}[.]\d{3}[.]\d{3}$/)
      @address = split_line[1]
    else
      @address = nil
    end
  end

  #WebParser objects comparator
  def ==(compared_obj)
    if (compared_obj != nil) and (self.page == compared_obj.page) and (self.address == compared_obj.address) then return true else false end
  end

end

## This class represents an object which has counted views and unique address views of page
# Holds overall and single address page views in @page_views and @unique_page_views hashes
class LogCounter
  #getters for @page_views and @unique_page_views
  attr_reader(:page_views, :unique_page_views)

  # LogCounter object constructor
  def initialize
    @page_views = Hash.new
    @unique_page_views = Hash.new
    @highest_unique = 1
    @prev_line = nil
  end

  #method counting overall and single address page views
  #take single line of file and parse it into WebParser objects if its possible, else skip value
  def count(line)
    unless line.nil? then line_parsed = WebParser.new(line) else nil; return end
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

  #convert @page_views hash to list of strings in format 'about/2 90 visits'
  def getViewsList
    @page_views = @page_views.sort_by{ |k, v| -v}
    return @page_views.map{|line| lambda{line[0].to_s() + " " + line[1].to_s() + " visits"}.call}
  end

  #convert @unique_page_views hash to list of strings in format '/about/2 10 unique views'
  def getUniqueViewsList
    @unique_page_views = @unique_page_views.sort_by{ |k, v| -v}
    return @unique_page_views.map{|line| lambda{line[0].to_s() + " " + line[1].to_s() + " unique views"}.call}
  end

end
