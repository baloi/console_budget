require 'rubygems'
require 'highline'


class BudgetApp
  def initialize
    @h = HighLine.new
    # all controllers here
    @expenses_controller = ExpensesController.new(self)
    @earnings_controller = EarningsController.new(self)
    @debts_controller = DebtsController.new(self)
    @budget_controller = BudgetController.new(self)
  end

  def expenses
    @expenses_controller
  end
  def earnings
    @earnings_controller
  end
  def index

    puts """
      ===========================
      ====  BALOI'S BUDGETER ====
      ===========================
    """
    puts

    @h.choose do |menu|
      menu.prompt = "Main Menu"
      menu.choice(:expenses) { @expenses_controller.index }
      menu.choice(:earnings) { @earnings_controller.index }
      menu.choice(:budget) { @budget_controller.index }
      menu.choice(:debts) { @debts_controller.index }
      menu.choice(:calendar) { @calendars_controller.index }
      menu.choice(:exit) { puts "bye...."}
    end
  end
end

class BudgetController
  def initialize(app)
    @app = app
    @h = HighLine.new
    @budgets = []
  end

  def index
    # prepare budget
    prepare_budget

    @h.choose do |menu|
      menu.prompt = "Budget Index"
      menu.choice(:calculate) { calculate; index }
      menu.choice(:main_menu) { @app.index  }
    end
  end

  def prepare_budget
    # get all earnings
    @earnings = @app.earnings
    # get all expenses
    @expenses = @app.expenses
  end

  def calculate
    puts ">>Earnings<<"
    @earnings.list
    puts ">>Expenses<<"
    @expenses.list
    #puts "#{@earnings.id}, #{}#{}"
    #puts "#{@expenses.id} #{}#{}"
    
    total_earnings = @earnings.sum
    total_expenses = @expenses.sum

    balance = total_earnings - total_expenses

    puts "Earnings = #{total_earnings}"
    puts "Expenses = #{total_expenses}"

    if balance > 0 
      puts "You have an excess of #{balance}" 
    elsif balance < 0 
      puts "You have balance of #{balance}" 
    elsif balance == 0 
      puts "Balanced out"
    else
      puts "Does not compute"

    end

    puts ""
  end

end

class ExpensesController
  def initialize(app)
    @app = app
    @h = HighLine.new
    @expenses = []
  end

  def all
    @expenses
  end

  def sum
    sum = 0
    @expenses.each do |expense|
      sum = sum + expense.amount 
    end
    sum
  end

  def index

    @h.choose do |menu|
      menu.prompt = "Expenses Index"
      menu.choice(:add) { add }
      menu.choice(:list) { list; index }
      menu.choice(:edit) { edit }
      menu.choice(:delete) { delete  }
      menu.choice(:main_menu) { @app.index  }
    end
    
  end

  def add
    amount = @h.ask("Amount: ", Integer) 
    description = @h.ask("Description: ")
    e = Expense.new(amount, description)
    @expenses << e
    index
  end

  def list
    @expenses.each do |expense|
      puts "#{expense.object_id}, #{expense.amount}, #{expense.description}"
    end
  end

  def edit
    puts 'in Expenses::edit'
  end
  def delete
    puts 'in Expenses::delete'
  end
end

class EarningsController

  def initialize(app)
    @app = app
    @h = HighLine.new
    @earnings = []
  end

  def all
    @earnings
  end

  def sum
    sum = 0
    @earnings.each do |earning|
      sum = sum + earning.amount 
    end
    sum
  end


  def index

    @h.choose do |menu|
      menu.prompt = "Earnings Index"
      menu.choice(:add) { add }
      menu.choice(:list) { list; index }
      menu.choice(:edit) { edit }
      menu.choice(:delete) { delete  }
      menu.choice(:main_menu) { @app.index  }
    end
    
  end

  def add
    amount = @h.ask("Amount: ", Integer) 
    description = @h.ask("Description: ")
    earning = Earning.new(amount, description)
    @earnings << earning
    index
  end

  def list
    @earnings.each do |earning|
      puts "#{earning.object_id}, #{earning.amount}, #{earning.description}"
    end
  end


  def edit
    puts 'in Earnings::edit'
  end
  def delete
    puts 'in Earnings::delete'
  end


end

class DebtsController
  def initialize(app)
    @app = app
  end
end

class CalendarsController
end


class Expense
  attr_reader :amount, :description
  def initialize(amount, description)
    @amount = amount
    @description = description
  end
end

class Earning
  attr_reader :amount, :description
  def initialize(amount, description)
    @amount = amount
    @description = description
  end
end

class Debt
end
class BudgetCalendar
end
