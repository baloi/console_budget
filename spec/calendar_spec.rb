require File.expand_path(File.dirname(__FILE__)) + '/../calendar'
require 'rubygems'
require 'jadof'
include JADOF

describe Month do
  it "should be able to retrieve specific day" do
    month = Calendar.create_month(2010, 8)
    day = month.get_day(21)

    day.year.should == 2010
    day.month.should == 8 
    day.day_of_week.should == "Sa" 
    day.items.length.should == 0 

  end
end

describe Day do
  it "should be able to have things added to items" do
    d = Day.new(2010, 10, 1)
    d.items.should be_an_instance_of Array
    d.items.length.should == 0
    item = Item.new
    item.kind = "expense"
    item.amount = 200
    item.date = '08/30/10'
    item.kind.should == 'expense'

    d.items << item

  end

  it "should be able to retrieve items" do
    d = Day.new(2010, 10, 1)
    d.items.should be_an_instance_of Array
    d.items.length.should == 0

    d.has_items.should == false

    item = Item.new
    item.kind = "expense"
    item.amount = 200
    item.description = "description" 
    item.amount = 200
    item.kind.should == 'expense'
    d.items << item

    d.has_items.should == true

    i = d.items.first
    i.kind.should == 'expense' 
    i.amount.should == 200 
  end

  it "should initially have a blank array of items" do
    d = Day.new(2010, 10, 1)
    d.items.should be_an_instance_of Array
    d.items.length.should == 0
  end

  it "should have an accurate representation of date(year, month, day)" do
    d = Day.new(2010, 10, 1)
    d.year.should == 2010
    d.month.should == 10
    d.day_of_week == 1
  end
end

describe Calendar do
  it 'should detect a valid month number' do
    Calendar.is_valid_month_number?(1).should == true
    Calendar.is_valid_month_number?(21).should == true
    Calendar.is_valid_month_number?(32).should_not == true
    Calendar.is_valid_month_number?(0).should_not == true
  end

  it "should be able to check for a date string" do
    Calendar.is_date_string?("2010/10/10").should == true
    Calendar.is_date_string?("2010/1/10").should_not == true
    Calendar.is_date_string?("2010/aug/10").should_not == true
    Calendar.is_date_string?("2010/32/10").should_not == true
    Calendar.is_date_string?("2010/13/10").should_not == true
    Calendar.is_date_string?("2010/12/32").should_not == true
  end

  it "should be able to return a date string 'yyyy/mm/dd' given year,month and day" do
    Calendar.date_string(2010, 9, 10).should == "2010/09/10"     
  end

  it "should be able to calculate for a date's next day" do
    d = "2010/09/27"
    Calendar.next_day(d).should == "2010/09/28"
  end

  it "should be able to convert a date into int array" do 

    d = Calendar.date_to_int_array("2010/08/30")
    d[0].should == 2010
    d[1].should == 8 
    d[2].should == 30 

  end

  it "should retrieve a month" do
    month = Calendar.create_month(2010, 8)
    month.number_of_weeks.should == 5
  end

  it "should have weeks" do
    #baloi
    # test number of  weeks
    month = Calendar.create_month(2010, 9)
    weeks = month.weeks
    month.number_of_weeks.should == 5

    #week1
    week1 = weeks[0]
    week1.week_of_month.should == 1
    
    week1.days[0].should == nil 
    week1.days[1].should == nil
    week1.days[2].should == nil

    week1.days[3].date.should == 1
    week1.days[4].date.should == 2

    week1.days[4].day_of_week.should == 'Th'

    week1.days[5].date.should == 3
    week1.days[5].day_of_week.should == 'Fr'

    week1.days[6].date.should == 4
    week1.days[6].day_of_week.should == 'Sa'

    #week2
    week2 = weeks[1]
    week2.week_of_month.should == 2 
    week2.days[0].date.should == 5 
    week2.days[0].day_of_week.should == "Su" 

    week2.days[1].date.should == 6 
    week2.days[1].day_of_week.should == "Mo" 

    week2.days[2].date.should == 7 
    week2.days[2].day_of_week.should == "Tu" 

    week2.days[3].date.should == 8 
    week2.days[3].day_of_week.should == "We" 


    week2.days[4].date.should == 9 
    week2.days[4].day_of_week.should == "Th" 


    week2.days[5].date.should == 10 
    week2.days[5].day_of_week.should == "Fr" 

    week2.days[6].date.should == 11 
    week2.days[6].day_of_week.should == "Sa" 

    #week5 
    week5 = weeks[4]
    week5.week_of_month.should == 5
   
    week5.days[0].date.should == 26 
    week5.days[0].day_of_week.should == "Su" 

    week5.days[1].date.should == 27 
    week5.days[1].day_of_week.should == "Mo" 


    week5.days[2].date.should == 28 
    week5.days[2].day_of_week.should == "Tu" 


    week5.days[3].date.should == 29 
    week5.days[3].day_of_week.should == "We" 


    week5.days[4].date.should == 30 
    week5.days[4].day_of_week.should == "Th" 

    week5.days[5].should == nil
    week5.days[6].should == nil

  end
end

describe Calendar::Entries do

  it "should detect date entries" do
    Calendar::Entries.is_date_entry?('2010/aug/10').should == true
    Calendar::Entries.is_date_entry?('2010/10/10').should_not == true 
    Calendar::Entries.is_date_entry?('2010/dec/30').should == true
    Calendar::Entries.is_date_entry?('2010/dec/31').should == true
    Calendar::Entries.is_date_entry?('2010/jan/32').should_not == true 
    Calendar::Entries.is_date_entry?('2010/jan/00').should_not == true 
  end

  it "should be able to extract days of month from entries" do
    #bc = BudgetCalendar.new
    #entries = bc.all_entries

    entries = Page.all
    
    #puts ">>>> entries  = #{entries}"

    entry_dates = Calendar::Entries.extract_dates(entries)
    #puts ">>>> entry_dates = #{entry_dates}"
    entry_dates.first.should == "2010/08/30"
    entry_dates.last.should == "2010/09/10"
  end

  it "should convert yyyy/mon/dd to yyyy/mm/dd format" do
    entry_sample = "2010/aug/10"
    date = Calendar::Entries.convert_to_date(entry_sample)
    date.should == "2010/08/10"
  end

end

