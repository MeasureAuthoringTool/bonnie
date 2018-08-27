require 'test_helper'

class ZipFileTest < ActiveSupport::TestCase
  test 'should reject absolute paths' do
    zip_path = Rails.root.join('test', 'fixtures', 'zip', 'absolutepath.zip')
    Zip::ZipFile.open(zip_path) do |zip_file|
      # Use glob to mimic the behavior in cql_loader.
      # Glob calls `entries`, which is monkey-patched.
      glob = zip_file.glob(File.join('**'))
      # There are 2 absolute path files in the zip.
      assert_equal 0, glob.count
    end
  end

  test 'should reject symlinks' do
    zip_path = Rails.root.join('test', 'fixtures', 'zip', 'symlink.zip')
    Zip::ZipFile.open(zip_path) do |zip_file|
      # There is 1 symlink and 1 non-symlink in the zip.
      glob = zip_file.glob(File.join('**'))
      assert_equal 1, glob.count
    end
  end

  test 'should reject relative paths' do
    zip_path = Rails.root.join('test', 'fixtures', 'zip', 'relativepath.zip')
    Zip::ZipFile.open(zip_path) do |zip_file|
      glob = zip_file.glob(File.join('**'))
      # There is 1 relative path file in the zip.
      assert_equal 0, glob.count
    end
  end
end
