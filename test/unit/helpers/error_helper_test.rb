require 'test_helper'
require './app/helpers/error_helper'

class ErrorHelperTest < ActionView::TestCase
  test 'Empty error message from execution engine' do
    error_info = {section: 'cql-measure-calculation',
                  cms_id: 'CMSv0', type: 'javascript',
                  url: 'http://127.0.0.1:3000/#measures/21C422D4-1658-478D-AEC2-B87B73638C41/patients/new',
                  controller: 'application', action: 'client_error'}
    exception = {section: 'cql-measure-calculation', cms_id: 'CMSv0', type: 'javascript', 
                 url: 'http://127.0.0.1:3000/#measures/21C422D4-1658-478D-AEC2-B87B73638C41/patients/new', 
                 controller: 'application', action: 'client_error'}
    request = 'empty'
    error_message = ErrorHelper.describe_error(error_info, exception, request)
    assert_equal 'One of the data elements associated with the measure is causing an issue. ' \
                 'Please review the elements associated with the measure to verify that they ' \
                 'are all constructed properly.<br>Error message: <b>An unspecified error has occurred.</b>', error_message[:body]
    assert_equal 'Measure Calculation Error', error_message[:title]
  end

  test 'Unknown error information section' do
    error_info = {section: 'unknown section',
                  cms_id: 'CMSv0', type: 'javascript',
                  url: 'http://127.0.0.1:3000/#measures/21C422D4-1658-478D-AEC2-B87B73638C41/patients/new',
                  controller: 'application', action: 'client_error', msg: 'Test Error'}
    exception = {section: 'cql-measure-calculation', cms_id: 'CMSv0', type: 'javascript',
                 url: 'http://127.0.0.1:3000/#measures/21C422D4-1658-478D-AEC2-B87B73638C41/patients/new',
                 controller: 'application', action: 'client_error'}
    request = 'empty'
    error_message = ErrorHelper.describe_error(error_info, exception, request)
    assert_nil error_message
  end

  test 'Empty error message' do
    error_info = {section: 'cql-measure-calculation',
                  cms_id: 'CMSv0', type: 'javascript',
                  url: 'http://127.0.0.1:3000/#measures/21C422D4-1658-478D-AEC2-B87B73638C41/patients/new',
                  controller: 'application', action: 'client_error', msg: ''}
    exception = {section: 'cql-measure-calculation', cms_id: 'CMSv0', type: 'javascript', 
                 url: 'http://127.0.0.1:3000/#measures/21C422D4-1658-478D-AEC2-B87B73638C41/patients/new', 
                 controller: 'application', action: 'client_error'}
    request = 'empty'
    error_message = ErrorHelper.describe_error(error_info, exception, request)
    assert_equal 'One of the data elements associated with the measure is causing an issue. ' \
                 'Please review the elements associated with the measure to verify that they ' \
                 'are all constructed properly.<br>Error message: <b>An unspecified error has occurred.</b>', error_message[:body]
    assert_equal 'Measure Calculation Error', error_message[:title]
  end
end
