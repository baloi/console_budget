require File.expand_path(File.dirname(__FILE__) + '/cal')

describe BudgetPeriod do
  it 'should have polymorphic methods' do 
    start_date = ('2010/09/03')
    end_date = ('2010/09/09')
    budget_period = BudgetPeriod.new(start_date, end_date)

  end

end
