gem "minitest"
require "minitest/autorun"


load "#{File.dirname($0)}/../later"

class TodoItemTest < Minitest::Test

    def setup
        @todays_date = Date.today.strftime("%F")
        @todo_pri_date = "(A) 2013-09-27 do something @foo +bar"
        @todo_pri = "(A) do something @foo +bar"
        @todo_date = "2013-09-27 do something @foo +bar"
        @todo_plain = "do something @foo +bar"
    end

    # since a date is set we will preserve it in the next 2 tests
    def test_dated_priority_no_add_date
        todo_item = TodoItem.new(@todo_pri_date, false)
        assert_equal "(A) 2013-09-27 do something @foo +bar", todo_item.build_todo()
    end
    def test_dated_priority_add_date
        todo_item = TodoItem.new(@todo_pri_date, true)
        assert_equal "(A) 2013-09-27 do something @foo +bar", todo_item.build_todo()
    end

    # if there is no date and we don't want one
    def test_undated_priority_no_add_date
        @todo_item = TodoItem.new(@todo_pri, false)
        assert_equal "(A) do something @foo +bar", @todo_item.build_todo()
    end

    # if there is no date and we add one
    def test_undated_priority_add_date
        @todo_item = TodoItem.new(@todo_pri, true)
        assert_equal "(A) #{@todays_date} do something @foo +bar", @todo_item.build_todo()
    end

    # in both cases we should preserve the date, since there is one
    def test_dated_no_add_date
        @todo_item = TodoItem.new(@todo_date, false)
        assert_equal "2013-09-27 do something @foo +bar", @todo_item.build_todo()
    end
    def test_dated_add_date
        @todo_item = TodoItem.new(@todo_date, true)
        assert_equal "2013-09-27 do something @foo +bar", @todo_item.build_todo()
    end

    # no date requested for plain entry
    def test_plain_no_add_date
        @todo_item = TodoItem.new(@todo_plain, false)
        assert_equal "do something @foo +bar", @todo_item.build_todo()
    end
    # make sure the date shows up
    def test_plain_add_date
        @todo_item = TodoItem.new(@todo_plain, true)
        assert_equal "#{@todays_date} do something @foo +bar", @todo_item.build_todo()
    end

end
