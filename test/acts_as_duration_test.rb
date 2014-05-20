require 'test_helper'

class ActsAsDurationTest < ActiveSupport::TestCase

  test 'adds conversion methods to model' do
    expected_methods = [:test_minutes, :test_hours, :test_hhmmss, :test_minutes=, :test_hours=, :test_hhmmss=]    
    assert (expected_methods - Foobar.instance_methods).empty?
  end
  
  test 'adds additional conversion methods to model' do
    Foobar.class_eval {acts_as_duration :test_seconds, additional_conversions: {days: 1.day.value}}
    expected_methods = [:test_minutes, :test_hours, :test_hhmmss, :test_minutes=, :test_hours=, :test_days, :test_days=, :test_hhmmss=]
    assert (expected_methods - Foobar.instance_methods).empty?
  end
  
  test 'converts from seconds to minutes, hours, and string, and saves' do
    foo = Foobar.new(test_seconds: 5400)
    assert_equal 1.5, foo.test_hours
    assert_equal 90, foo.test_minutes
    assert_equal "01:30:00", foo.test_hhmmss
    
    foo.test_hours = 2
    assert_equal 7200, foo.test_seconds
    assert_equal 120, foo.test_minutes
    assert_equal "02:00:00", foo.test_hhmmss
    
    foo.test_minutes = 123
    assert_equal 7380, foo.test_seconds
    assert_equal 2.05, foo.test_hours
    assert_equal "02:03:00", foo.test_hhmmss
    
    
    foo.test_hhmmss = "02:12:34"
    assert_equal 7954, foo.test_seconds
    assert_equal 2.21, foo.test_hours
    assert_equal 132.57, foo.test_minutes
        
    foo.test_hhmmss = "02:12"
    assert_equal 7920, foo.test_seconds
    assert_equal 132, foo.test_minutes
    assert_equal 2.2, foo.test_hours
    
    foo.test_hhmmss = "02"
    assert_equal 7200, foo.test_seconds
    assert_equal 120, foo.test_minutes
    assert_equal 2, foo.test_hours
    
    
    foo.test_hhmmss = "00:30"
    foo.save
    foo.reload
    assert_equal 1800, foo.test_seconds
    assert_equal 30, foo.test_minutes
    assert_equal 0.5, foo.test_hours
    assert_equal "00:30:00", foo.test_hhmmss
  end
  
  
  test 'converts from minutes to seconds, hours, and hhmmss' do
    Foobar.class_eval {attr_accessor :barfoo_minutes; acts_as_duration :barfoo_minutes}
    foo = Foobar.new(barfoo_minutes: 90)
    assert_equal 1.5, foo.barfoo_hours
    assert_equal 5400, foo.barfoo_seconds
    assert_equal "01:30:00", foo.barfoo_hhmmss
    
    foo.barfoo_hours = 2
    assert_equal 7200, foo.barfoo_seconds
    assert_equal 120, foo.barfoo_minutes
    assert_equal "02:00:00", foo.barfoo_hhmmss
    
    foo.barfoo_seconds = 7320
    assert_equal 122, foo.barfoo_minutes
    assert_equal 2.03, foo.barfoo_hours
    assert_equal "02:02:00", foo.barfoo_hhmmss
    
    foo.barfoo_hhmmss = "02:12:34"
    assert_equal 7954, foo.barfoo_seconds
    assert_equal 2.21, foo.barfoo_hours
    assert_equal 132.57, foo.barfoo_minutes.round(2)    
  end
  
  test 'converts from hhmmss to minutes, seconds, and hours' do
    Foobar.class_eval {attr_accessor :barfoo_hhmmss; acts_as_duration :barfoo_hhmmss}
    foo = Foobar.new(barfoo_hhmmss: '02:12:34')
    assert_equal 2.21, foo.barfoo_hours
    assert_equal 132.57, foo.barfoo_minutes    
    assert_equal 7954, foo.barfoo_seconds
    
    foo.barfoo_hours = 2
    assert_equal 7200, foo.barfoo_seconds
    assert_equal 120, foo.barfoo_minutes
    assert_equal "02:00:00", foo.barfoo_hhmmss
    
    foo.barfoo_seconds = 7320
    assert_equal 122, foo.barfoo_minutes
    assert_equal 2.03, foo.barfoo_hours
    assert_equal "02:02:00", foo.barfoo_hhmmss    
    
    foo.barfoo_minutes = 132.57
    assert_equal 7954, foo.barfoo_seconds
    assert_equal 2.21, foo.barfoo_hours
    assert_equal "02:12:34", foo.barfoo_hhmmss 
  end
  
  test 'accepts multiple attributs as well as hash arguments' do
    Foobar.class_eval do 
      attr_accessor :a_seconds, :b_minutes, :c_hours
      acts_as_duration :a_seconds, :b_minutes, :c_hours, read_only: true
    end
    
    expected_methods = [:a_minutes, :a_hours, :b_seconds, :b_hours, :c_seconds, :c_minutes]    
    assert (expected_methods - Foobar.instance_methods).empty?
    
    unexpected_methods = [:a_minutes=, :a_hours=, :b_seconds=, :b_hours=, :c_seconds=, :c_minutes=]    
    assert_equal 6, (unexpected_methods - Foobar.instance_methods).count
    
    
  end
  
end
