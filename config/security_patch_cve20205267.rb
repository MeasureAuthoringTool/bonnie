# Name: actionview
# Version: 4.2.11.1
# Advisory: CVE-2020-5267
# Criticality: Unknown
# URL: https://groups.google.com/forum/#!topic/rubyonrails-security/55reWMM_Pg8
#     Title: Possible XSS vulnerability in ActionView
# Solution: upgrade to ~> 5.2.4, >= 5.2.4.2, >= 6.0.2.2

ActionView::Helpers::JavaScriptHelper::JS_ESCAPE_MAP.merge!(
  {
    "`" => "\\`",
    "$" => "\\$"
  }
)

module ActionView
  module Helpers
    module JavaScriptHelper
      alias old_ej escape_javascript
      alias old_j j
    
      def escape_javascript(javascript)
        javascript = javascript.to_s
        result = if javascript.empty?
                   ""
                 else
                   javascript.gsub(%r{(\\|</|\r\n|\342\200\250|\342\200\251|[\n\r"']|[`]|[$])}u, JS_ESCAPE_MAP)
                 end
        if javascript.html_safe?
          result.html_safe
        else
          result
        end
      end
    
      alias j escape_javascript
    end
  end
end

