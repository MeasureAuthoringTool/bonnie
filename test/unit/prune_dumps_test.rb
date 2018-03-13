require 'test_helper'

# Tests for bonnie:db:prune_dumps rake task. Note that coverage for the task is not being calculated correctly.
class PruneDumpsTest < ActiveSupport::TestCase

  DUMP_TIME_FORMAT = "%Y-%m-%d-%H-%M-%S"
  DUMPS_FOLDER = File.join('db', 'backups')

  def create_mock_dump(date)
    filename = "bonnie_production-#{date.strftime(DUMP_TIME_FORMAT)}.tgz"
    FileUtils.touch File.join(DUMPS_FOLDER, filename)
    filename
  end

  setup do
    if !Dir.exist?(DUMPS_FOLDER)
      Dir.mkdir(DUMPS_FOLDER)
    end
    Dir.glob(File.join(DUMPS_FOLDER, '*.tgz')).each { |f| File.delete(f) }
  end

  test "dumps things older than a year old" do
    remove_filenames = []
    keep_filenames = []
    remove_filenames << create_mock_dump(13.months.ago)
    remove_filenames << create_mock_dump(2.years.ago)
    keep_filenames << create_mock_dump(11.months.ago)
    keep_filenames << create_mock_dump(2.months.ago)
    keep_filenames << create_mock_dump(DateTime.now)

    Rake::Task['bonnie:db:prune_dumps'].execute

    remove_filenames.each { |f| assert_equal false, File.exist?(File.join(DUMPS_FOLDER, f)), "#{f} should have been removed" }
    keep_filenames.each { |f| assert_equal true, File.exist?(File.join(DUMPS_FOLDER, f)), "#{f} should have been kept" }
  end

  test "keeps newest monthly older than 3 months" do
    remove_filenames = []
    keep_filenames = []

    firstMonth = 5.months.ago
    firstOfMonth = Date.new(firstMonth.year, firstMonth.month, 1)
    remove_filenames << create_mock_dump(firstOfMonth)
    remove_filenames << create_mock_dump(firstOfMonth.next_day(6))
    keep_filenames << create_mock_dump(firstOfMonth.next_day(18))

    firstMonth = 6.months.ago
    firstOfMonth = Date.new(firstMonth.year, firstMonth.month, 1)
    remove_filenames << create_mock_dump(firstOfMonth)
    remove_filenames << create_mock_dump(firstOfMonth.next_day(6))
    keep_filenames << create_mock_dump(firstOfMonth.next_day(18))

    Rake::Task['bonnie:db:prune_dumps'].execute

    remove_filenames.each { |f| assert_equal false, File.exist?(File.join(DUMPS_FOLDER, f)), "#{f} should have been removed" }
    keep_filenames.each { |f| assert_equal true, File.exist?(File.join(DUMPS_FOLDER, f)), "#{f} should have been kept" }
  end

  test "keeps most recent weekly dump within last 3 months" do
    remove_filenames = []
    keep_filenames = []

    # figure out the first day of the week approximately 2 months ago
    twoMonthsAgo = 2.months.ago
    twoMonthsAgoDT = DateTime.new(twoMonthsAgo.year, twoMonthsAgo.month, twoMonthsAgo.day)
    firstOfWeek = twoMonthsAgoDT.prev_day(twoMonthsAgoDT.wday - 1)

    # create a few mocks for this week. the last will be kept
    remove_filenames << create_mock_dump(firstOfWeek)
    remove_filenames << create_mock_dump(firstOfWeek.next_day(2))
    keep_filenames << create_mock_dump(firstOfWeek.next_day(5))

    # for the following week do the same.
    remove_filenames << create_mock_dump(firstOfWeek.next_day(7))
    remove_filenames << create_mock_dump(firstOfWeek.next_day(10))
    keep_filenames << create_mock_dump(firstOfWeek.next_day(13))

    Rake::Task['bonnie:db:prune_dumps'].execute

    remove_filenames.each { |f| assert_equal false, File.exist?(File.join(DUMPS_FOLDER, f)), "#{f} should have been removed" }
    keep_filenames.each { |f| assert_equal true, File.exist?(File.join(DUMPS_FOLDER, f)), "#{f} should have been kept" }
  end

  test "keeps most recent daily dump within last month" do
    remove_filenames = []
    keep_filenames = []

    sixDaysAgo = DateTime.new(6.days.ago.year, 6.days.ago.month, 6.days.ago.day)
    remove_filenames << create_mock_dump(sixDaysAgo)
    keep_filenames << create_mock_dump(sixDaysAgo.advance(minutes: 30, hours: 1))
    keep_filenames << create_mock_dump(sixDaysAgo.next_day)
    keep_filenames << create_mock_dump(sixDaysAgo.next_day(2))
    remove_filenames << create_mock_dump(sixDaysAgo.next_day(3))
    keep_filenames << create_mock_dump(sixDaysAgo.next_day(3).advance(hours: 4))

    Rake::Task['bonnie:db:prune_dumps'].execute

    remove_filenames.each { |f| assert_equal false, File.exist?(File.join(DUMPS_FOLDER, f)), "#{f} should have been removed" }
    keep_filenames.each { |f| assert_equal true, File.exist?(File.join(DUMPS_FOLDER, f)), "#{f} should have been kept" }
  end
end
