require File.expand_path(File.dirname(__FILE__)) + '/calendar'
require 'rubygems'
require 'jadof'
include JADOF


class BudgetCalendar 
  # @report is the analysis of financial data gathered
  attr_reader :report, :all_entries

  def initialize
    @pages  = Page.all    
    @all_entries = @pages
  end

  def calculate(start_date, end_date)
    calculation = 0
    @date_array = date_range( start_date, end_date )
    
    # what months are included?
    ##@@@months = months_covered( start_date, end_date)
    
    # insert data into months 
     
    # insert entries to days (processed form)
  
    calculation
  end

  def calculate_month( year, month )
    budget_month = get_month(year, month)
    budget_month.report
    total_expenses = budget_month.total_expenses
    total_earnings = budget_month.total_earnings

    calculation = total_earnings + total_expenses
    #check_debit_credit(calculation)
    calculation
  end

  # returns an array of dates from start_date until end_date
  # start_date and end_date params should be 'yyyy/mm/dd' format
  def date_range( start_date, end_date )
    d_range = []
    cur_date = start_date 

    until cur_date == end_date
      d_range << cur_date
      cur_date = Calendar.next_day( cur_date )
    end
    
    d_range << end_date
  end


  # Get the BudgetMonth of specified month.
  #
  # +year+ of month to get & +month+ is the specific month being searched. 
  #
  # Returns BudgetMonth.
  def get_month(year, month)
    entries = month_entries(@pages, year, month) 

    budget_month = BudgetMonth.new(entries, year, month)

    budget_month
  end

  # Does page belong to month? 
  # 
  # +page+ Page to be verified if it belongs to a certain month. 
  # +year+ is the year of the specific month to check 
  # +month+ is the specific month we are asking about 
  #
  # Returns true if page is of specific month asked. 
  def page_is_of_month? (page, year, month)
    #puts "page.name == #{page.name}"
    return false if not Calendar.date?(page.name)
      
    # get the date for the page
    date_array = page.full_name.split "/"

    # extract year and month from page
    y = date_array[0].to_i
    m = date_array[1]
    m = Calendar.month(m).to_i

    # compare page's month with month in question
    if y == year and m == month
      true
    else
      false
    end

  end

  # Returns entries for a specific month
  # pages - array of pages to seive through (contains full_name, body, etc...)
  # year - year of month to be searched
  # month - month to be searched for
  def month_entries(pages, year, month)
    #puts ", year = #{year}, month = #{month}"
    # page.full_name => yyyy/mm/dd
    entries = []
    pages.each do |page|
      if page_is_of_month?(page, year, month)
        entries << page 
      end
    end
    entries
  end
end

class BudgetMonth
  attr_reader :entry_dates, :filled_days
  def initialize(entries, year, month)
  
    objMonth = Month.new(year, month)
    @month = objMonth       

    date_start = Calendar.date_string(year, month, 1) 
    date_end = Calendar.date_string(year, month, objMonth.last_day) 

    #days with entries
    @filled_days = []

    # create an array of dates from entries
    @entry_dates = Calendar::Entries.extract_dates(entries)

    #puts ">>> @entry_dates = #{@entry_dates}"
    @filled_days = insert_data_to_days(entries, @entry_dates)

  end

  def report
    "Another stub"
  end

  def insert_data_to_days(entries, entry_dates)
    # insert data to days with entries 
          
    filled_days = []
    entry_dates.each do |date|

      d = Calendar.day_from_date(date)

      #puts ">>> d #{d}"

      day = @month.get_day(d)
      #puts ">>>#{day}, date=#{date} <<<"
      #puts "name = #{entries.first.name}"
      #date_string = date.to_s
      date_string = date
      #puts ">>> date_string '#{date_string}'"
     
      entry = Calendar::Entries.find_entry(entries, date_string)  

      day = insert_entry_items_to_day(entry, day)
      #puts "++++#{day}"
    
      filled_days << day 
    end

    filled_days
  end

  def days_with_entries
    @filled_days
  end

  def total_earnings
    items = []
    @filled_days.each do |day|
      day.items.each do |item|
        items << item if item.is_earning? 
      end
    end
    total = get_total(items)
  end

  def total_expenses
    items = []
    @filled_days.each do |day|
      day.items.each do |item|
        items << item if item.is_expense? 
      end
    end
    total = get_total(items)
  end

  private
  def get_total(items)
    total = 0
    items.each do |item|
      total = total + item.amount
      #puts "item: #{item.description}, amount=#{item.amount}"
    end

    total
  end


  def insert_entry_items_to_day(entry, day)
    #puts "++++#{entry.body}"
    contents_array = entry.body.split "\n"
    #puts "++++#{contents_array}"

    contents_array.each do |content|

      details = content.split "," 

      item = Item.new
      item.kind = details[0].strip
      item.description = details[1].strip
      item.amount = details[2].to_i
      item.date = details[3].strip

      day.items << item 

    end

    day
  end

end
