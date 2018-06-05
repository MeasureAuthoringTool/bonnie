# Disable WebMock globally so it allows VSAC to work outside of tests
if defined?(WebMock)
  WebMock.disable!
end
