require 'rack/test'
require 'json'
require_relative '../../app/api'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do
    include Rack::Test::Methods
    def app
      ExpenseTracker::API.new
    end

    def post_expenses(expense)
      post '/expenses', JSON.generate(expense)
      expect(last_response.status).to eq(200)

      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
      expense.merge('id' => parsed['expense_id'])
    end

    it 'record submit expenses' do
      pending 'Need to persistend expense'
      coffee = post_expenses(
        'payee'  => 'Starbucks',
        'amount' => 5.75,
        'date'   => '2017-06-10'
      )

      zoo = post_expenses(
        'payee'  => 'Zoo',
        'amount' => 15.25,
        'date'   => '2017-06-10'
      )

      groceries = post_expenses(
        'payee'  => 'Whole Foods',
        'amount' => 95.20,
        'date'   => '2017-06-11'
      )

      cup_of_cofee = post_expenses(
        'payee'  => 'Chiapas',
        'amount' => 70.20,
        'date'   => '2017-06-11'
      )

      get '/expenses/2017-06-10'

      expenses = JSON.parse(last_response.body)
      expect(expenses).to contain_exactly(coffee, zoo)
    end
  end
end
