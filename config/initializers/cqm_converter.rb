require 'cqm/converter'
# Initialize HDSRecord to QDMRecord Converter
# This can be used throughout Bonnie Application as CQMConverter
::CQMConverter = CQM::Converter::HDSRecord.new
