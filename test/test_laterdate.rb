gem "minitest"
require "minitest/autorun"


load "#{File.dirname($0)}/../later"

class LaterDateTest < Minitest::Test
    @today = Date.today()
    @tomorrow = @today.next_day()
    @yesterday = @today.prev_day()
    @last_month = @today.prev_month()
    @next_month = @today.next_month()
    @last_year = @today.prev_year()

    def setup
    end

    @range_past = @last_month.strftime("%F") + ".." + @yesterday.strftime("%F")
    @range_current = @last_month.strftime("%F") + ".." + @next_month.strftime("%F")
    @range_future = @tomorrow.strftime("%F") + ".." + @next_month.strftime("%F")

    @@ranges = { "past" => @range_past, "current" => @range_current, "future" => @range_future}

    # testing for invalid dates
    invalids = {
        "weird_string" => "bad date",
        "without_date" => "Mon,Fri/3",
        "start_date_only" => "2014-20-01",
        "start_date_of_range" => "2014-20-01..2014-01-01",
        "end_date_of_range" => "2014-01-01..2014-20-01",
        "start_date_after_end_date" => "2014-08-01..2014-01-01;Mon",
        "date_range_without_selector" => "2014-01-01..2014-08-01",
        "start_and_end_date_of_range" => "2014-20-01..2014-21-01",
        "selector_mix_1" => "1,2,3,Mon",
        "selector_mix_2" => "Nov23,1,2,3,Mon",
        "selector_mix_1_with_date" => "2014-01-01;1,2,3,Mon",
        "selector_mix_2_with_date" => "2014-01-01;Nov23,1,2,3,Mon",
        "selector_mix_1_with_date_range" => "2014-01-01..2014-02-02;1,2,3,Mon",
        "selector_mix_2_with_date_range" => "2014-01-01..2014-02-02;Nov23,1,2,3,Mon"
    }

    # testing valid dates
    invalids.each_pair do |invalid_name,invalid_param|
        define_method("test_invalid_#{invalid_name}") do
            @laterdate = LaterDate.new(invalid_param)
            assert_equal false, @laterdate.valid?
        end
    end

    valids = {
        "date_only" => "2014-08-01",
        "day_of_week" => "Mon,Thu,Fri",
        "day_of_month" => "1,14,20",
        "single_day_of_month" => "2",
        "date_and_day_of_week" => "2013-08-04;Mon,Thu,Fri",
        "day_of_month" => "1,14,20"
    }
    valids.each_pair do |valid_name,valid_param|
        define_method("test_valid_#{valid_name}") do
            @laterdate = LaterDate.new(valid_param)
            assert_equal true, @laterdate.valid?
        end
    end

    # testing for doables
    doable = {
        "date_only" => @today.strftime("%F"),
        "day_of_week" => @today.strftime("%a"),
        "day_of_week_interval1" => @today.strftime("%F") + ";" + @today.strftime("%a") + "/2",
        "day_of_week_interval2" => @yesterday.strftime("%F") + ";" + @today.strftime("%a") + "/2",
        "day_of_week_interval3" => @last_month.strftime("%F") + ";" + @today.strftime("%a") + "/4",
        "days_of_week" => [ @yesterday.strftime("%a"), @today.strftime("%a"), @tomorrow.strftime("%a") ].join(','),
        "day_of_month" => @today.strftime("%d"),
        "day_of_month_interval1" => @today.strftime("%F") + ";" + @today.strftime("%d") + "/2",
        "day_of_month_interval2" => @last_month.prev_month().strftime("%F") + ";" + @today.strftime("%d") + "/2",
        "days_of_month" => [ @yesterday.strftime("%d"), @today.strftime("%d"), @tomorrow.strftime("%d") ].join(','),
        "month_day" => @today.strftime("%b%d"),
        "month_day_interval1" => @last_year.prev_year().strftime("%F") + ";" + @today.strftime("%b%d") + "/2",
        "month_days" => [ @yesterday.strftime("%b%d"), @today.strftime("%b%d"), @tomorrow.strftime("%b%d") ].join(','),
        "day_of_week_range" => "#{@range_current};" + @today.strftime("%a"),
        "days_of_week_range" => "#{@range_current};" + [ @yesterday.strftime("%a"), @today.strftime("%a"), @tomorrow.strftime("%a") ].join(','),
        "day_of_month_range" => "#{@range_current};" + @today.strftime("%d"),
        "days_of_month_range" => "#{@range_current};" + [ @yesterday.strftime("%d"), @today.strftime("%d"), @tomorrow.strftime("%d") ].join(','),
        "month_day_range" => "#{@range_current};" + @today.strftime("%b%d"),
        "month_days_range" => "#{@range_current};" + [ @yesterday.strftime("%b%d"), @today.strftime("%b%d"), @tomorrow.strftime("%b%d") ].join(',')
    }
    doable.each_pair do |do_name,do_param|
        define_method("test_do_#{do_name}") do
            @laterdate = LaterDate.new(do_param)
            assert_equal true, @laterdate.do_today?
        end
    end

    # testing for nondoables
    nondoable = {
        "date_only" => @tomorrow.strftime("%F"),
        "day_of_week" => @tomorrow.strftime("%a"),
        "day_of_week_interval1" => @last_month.strftime("%F") + ";" + @today.strftime("%a") + "/3",
        "day_of_week_interval2" => @today.strftime("%F") + ";" + @tomorrow.strftime("%a") + "/2",
        "day_of_week_interval3" => @yesterday.strftime("%F") + ";" + @tomorrow.strftime("%a") + "/2",
        "day_of_week_interval4" => @last_month.strftime("%F") + ";" + @tomorrow.strftime("%a") + "/4",
        "days_of_week" => [ @yesterday.strftime("%a"), @tomorrow.strftime("%a") ].join(','),
        "day_of_month" => @tomorrow.strftime("%d"),
        "day_of_week_interval1" => @last_month.strftime("%F") + ";" + @today.strftime("%d") + "/3",
        "day_of_week_interval2" => @today.strftime("%F") + ";" + @tomorrow.strftime("%d") + "/2",
        "days_of_month" => [ @yesterday.strftime("%d"), @tomorrow.strftime("%d") ].join(','),
        "month_day" => @tomorrow.strftime("%b%d"),
        "month_day_interval1" => @last_year.strftime("%F") + ";" + @today.strftime("%b%d") + "/2",
        "month_days" => [ @yesterday.strftime("%b%d"), @tomorrow.strftime("%b%d") ].join(','),
        "day_of_week_range_past" => "#{@range_past};" + @today.strftime("%a"),
        "days_of_week_range_past" => "#{@range_past};" + [ @yesterday.strftime("%a"), @today.strftime("%a"), @tomorrow.strftime("%a") ].join(','),
        "day_of_month_range_past" => "#{@range_past};" + @today.strftime("%d"),
        "days_of_month_range_past" => "#{@range_past};" + [ @yesterday.strftime("%d"), @today.strftime("%d"), @tomorrow.strftime("%d") ].join(','),
        "month_day_range_past" => "#{@range_past};" + @today.strftime("%b%d"),
        "month_days_range_past" => "#{@range_past};" + [ @yesterday.strftime("%b%d"), @today.strftime("%b%d"), @tomorrow.strftime("%b%d") ].join(','),
        "day_of_week_range_future" => "#{@range_future};" + @today.strftime("%a"),
        "days_of_week_range_future" => "#{@range_future};" + [ @yesterday.strftime("%a"), @today.strftime("%a"), @tomorrow.strftime("%a") ].join(','),
        "day_of_month_range_future" => "#{@range_future};" + @today.strftime("%d"),
        "days_of_month_range_future" => "#{@range_future};" + [ @yesterday.strftime("%d"), @today.strftime("%d"), @tomorrow.strftime("%d") ].join(','),
        "month_day_range_future" => "#{@range_future};" + @today.strftime("%b%d"),
        "month_days_range_future" => "#{@range_future};" + [ @yesterday.strftime("%b%d"), @today.strftime("%b%d"), @tomorrow.strftime("%b%d") ].join(',')
    }
    nondoable.each_pair do |nodo_name,nodo_param|
        define_method("test_no_do_#{nodo_name}") do
            @laterdate = LaterDate.new(nodo_param)
            assert_equal false, @laterdate.do_today?
        end
    end


    # test end of range
    end_ranges = [
        [ "range_past", "#{@range_past};" + @today.strftime("%d"), true ],
        [ "range_current", "#{@range_current};" + @today.strftime("%d"), false ],
        [ "range_future", "#{@range_future};" + @today.strftime("%d"), false ]
    ]
    end_ranges.each do |range|
        define_method("test_#{range[0]}") do
            @laterdate = LaterDate.new(range[1])
            assert_equal range[2], @laterdate.past_end?
        end
    end

end
