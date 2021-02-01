require 'test/unit'
require './web_parser_class'

#TODO make proper documentation
class WebParserTest < Test::Unit::TestCase

  #test parsing standard line,
  def test_parser_ok
    parser_obj = WebParser.new("/about/2 016.464.657.359")
    assert_equal("/about/2", parser_obj.page, "'#{parser_obj.page}' != '/about/2' ")
    assert_equal("016.464.657.359", parser_obj.address, "'#{parser_obj.address}' != '016.464.657.359' ")
  end

  #test parsing line without any delimiter between page and address
  def test_parser_fail
    parser_obj = WebParser.new("/about/21234.464.657.359")
    assert_equal(nil, parser_obj.page, "'#{parser_obj.page}' != 'nil' ")
    assert_equal(nil, parser_obj.address, "'#{parser_obj.address}' != 'nil' ")
  end

  #test parsing line with other delimiters than " " between page and address
  def test_parser_wrong_delimiter
    test_line = "/help_page/1 016.464.657.359"
    delimiters = [",", ":", ";", "-"]

    delimiters.each { |delimiter|
      parser_obj = WebParser.new(test_line.tr(" ", delimiter))
      assert_equal("/help_page/1", parser_obj.page, "'#{parser_obj.page}' != '/help_page/1' ")
      assert_equal("016.464.657.359", parser_obj.address, "'#{parser_obj.address}' != '016.464.657.359' ")
    }
  end

  #test parsing line with incorrect page
  def test_wrong_format_page
    parser_obj = WebParser.new("about 016.464.657.359")
    assert_equal(nil, parser_obj.page, "'#{parser_obj.page}' != 'nil' ")
    assert_equal("016.464.657.359", parser_obj.address, "'#{parser_obj.page}' != '016.464.657.359' ")
  end

  #test parse line with address in format other than "\d{3}[.,;:-]\d{3}[.,;:-]\d{3}[.,;:-]\d{3}\"
  def test_wrong_format_address
    test_line1 = "/about 01.464.657.359"
    test_line2 = "/about 016.4a4.657.359"
    test_line3 = "/about 016.424.6-7.359"
    test_line4 = "/about 016.4a4.6572.359"
    test_line5 = "/about 016.464.657.359.123"

    test_line_delimiters = "/about 016.464.657.359"
    delimiters = [",", ":", ";", "-"]
    test_list = [test_line1, test_line2, test_line3, test_line4, test_line5]

    test_list.each { |line|
      parser_obj = WebParser.new(line)
      assert_equal("/about", parser_obj.page, "'#{parser_obj.page}' != '/about' ")
      assert_equal(nil, parser_obj.address, "'#{parser_obj.page}' != 'nil' ")
    }

    delimiters.each { |delimiter|
      parser_obj = WebParser.new(test_line_delimiters.tr(".", delimiter))
      assert_equal("/about", parser_obj.page, "'#{parser_obj.page}' != '/about' ")
      assert_equal(nil, parser_obj.address, "'#{parser_obj.page}' != 'nil' ")
    }
  end


end
