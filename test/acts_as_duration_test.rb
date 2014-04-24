require 'test_helper'

class ActsAsDurationTest < ActiveSupport::TestCase

  test 'adds conversion methods to model' do
    expected_methods = [:test_minutes, :test_hours, :test_minutes=, :test_hours=]    
    assert (expected_methods - Foobar.instance_methods).empty?
  end
  
  test 'adds additional conversion methods to model' do
    Foobar.class_eval {acts_as_duration :test_seconds, additional_conversions: {days: 1.day.value}}
    expected_methods = [:test_minutes, :test_hours, :test_minutes=, :test_hours=, :test_days, :test_days=]
    assert (expected_methods - Foobar.instance_methods).empty?
  end
  
  test 'converts from seconds to minutes, hours and saves' do
    foo = Foobar.new(test_seconds: 5400)
    assert_equal 1.5, foo.test_hours
    assert_equal 90, foo.test_minutes
    
    foo.test_hours = 2
    assert_equal 7200, foo.test_seconds
    assert_equal 120, foo.test_minutes
    
    foo.test_minutes = 123
    assert_equal 7380, foo.test_seconds
    assert_equal 2.05, foo.test_hours
    
    foo.save
    foo.reload
    assert_equal 7380, foo.test_seconds
    assert_equal 2.05, foo.test_hours
    assert_equal 123, foo.test_minutes
  end
  
  
  test 'converts from minutes to seconds and hours' do
    Foobar.class_eval {attr_accessor :barfoo_minutes; acts_as_duration :barfoo_minutes}
    foo = Foobar.new(barfoo_minutes: 90)
    assert_equal 1.5, foo.barfoo_hours
    assert_equal 5400, foo.barfoo_seconds
    
    foo.barfoo_hours = 2
    assert_equal 7200, foo.barfoo_seconds
    assert_equal 120, foo.barfoo_minutes
    
    foo.barfoo_seconds = 7320
    assert_equal 122, foo.barfoo_minutes
    assert_equal 2.03, foo.barfoo_hours
  end
  
end
