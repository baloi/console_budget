require File.expand_path(File.dirname(__FILE__)) + '/../budget_calendar'

module BudgetAppTestHelperMethods
  def get_file_content(date_string)
    path = '/../pages/' + date_string
    fname = File.expand_path(File.dirname(__FILE__) + path)
    f = File.open(fname)
    lines = f.readlines
    content = lines.join
    content
  end
end

describe BudgetMonth do
  it "should be able to find an entry" do
    bc = BudgetCalendar.new
    all_entries = bc.all_entries
    month_entries = bc.month_entries(all_entries, 2010, 9)
    entries = bc.all_entries

    entry = Calendar::Entries.find_entry(entries, "2010/09/10")  
  end

  it "should be able to insert data to days of month" do
    pending("insert_data_to_days(entries, entry_dates) entry dates should be YYY/mm/dd")

  end

  it "should return total expenses for the month" do
    budget_month = BudgetCalendar.new().get_month(2010, 9)
    expenses = budget_month.total_expenses
    expenses.should == -382 
  end

  it "should return total earnings for the month" do
    budget_month = BudgetCalendar.new().get_month(2010, 9)
    earnings = budget_month.total_earnings
    earnings.should == 473
  end
end

describe "BudgetCalendar" do
  include BudgetAppTestHelperMethods

  before(:each) do
    @budget_calendar = BudgetCalendar.new
  end

  it "should return corresponding dates when given start and end dates" do
    start_date = "2010/08/29"
    end_date = "2010/09/02"
    budget_calendar = BudgetCalendar.new
    
    budget_calendar.date_range(start_date, end_date).should == ["2010/08/29", "2010/08/30", "2010/08/31", "2010/09/01", "2010/09/02"]
  end

  it "should be able to calculate budget for a period" do
    start_date = "2010/08/30"
    end_date = "2010/09/10"
    period_result = @budget_calendar.calculate(start_date, end_date)
    pending("get calculations working")
    period_result.should == 3
  end

  it "should be able to return the months covered by start and end date" do
    pending("get the months included in the date range")
  end

  it "should calculate a budget for the whole month" do
    
    @budget_calendar.should respond_to(:calculate_month)

    calculation = @budget_calendar.calculate_month(2010, 9)    
    calculation.should == 91 

  end

  it "should be able to load all budget data" do
    @budget_calendar.should be_an_instance_of BudgetCalendar
    month = @budget_calendar.get_month(2010, 8)
  end

  it "should get month entries" do
    pages =  Page.all
    entries = @budget_calendar.month_entries(pages, 2010, 8)
    #puts "entries.length == #{entries.length}"
    entries.length.should == 1 
    content = get_file_content(entries.last.full_name)

    entries.first.body.should == content
    entries.last.name.should == "30"
    entries.last.full_name.should == "2010/aug/30"
     
    entries.last.body.should == content
  end

  it "should return month containing items days with expense/earnings" do
    budget_month = @budget_calendar.get_month(2010, 8)
    budget_month.entry_dates.size.should == 1 
    budget_month.entry_dates.first.should == "2010/08/30"
    days = budget_month.days_with_entries
    days.length.should == 1

    #puts "====#{days}"
    days.last.items.length.should == 3

    one_day = days.last
    one_day.class.should == Day
    one_day.items.last.class.should == Item
    one_day.items.last.amount.should == -80 
    one_day.items.last.description.should == "groceries" 
    one_day.items.last.date.should == '08/30/10' 


    bm2 = @budget_calendar.get_month(2010, 9)
    bm2.entry_dates.size.should == 1
    bm2.entry_dates.first.should == "2010/09/10" 
    days = bm2.days_with_entries
    days.length.should == 1

    first_day = days.first
    first_day.class.should == Day
    first_day.items.last.class.should == Item
    first_day.items[3].class.should == Item

    first_day.items.first.amount.should == 473 
    first_day.items.first.description.should == "salary for sep first week" 
    first_day.items.first.kind.should == "EAR" 
    first_day.items.first.date.should == '09/10/10' 

    first_day.items[1].amount.should == -30 
    first_day.items[1].description.should == "soccer" 
    first_day.items[1].kind.should == "EXP" 
    first_day.items[1].date.should == '09/10/10' 

    first_day.items[5].amount.should == -110 
    first_day.items[5].description.should == "bata clothes" 
    first_day.items[5].kind.should == "EXP" 
    first_day.items[5].date.should == '09/10/10' 


  end

end
