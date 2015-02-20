# Calculate measures from ruby, using V8; use it something like this:
#
#   calculator = BonnieBackendCalculator.new
#   calculator.set_measure_and_population(measure1, 0)
#   calculator.calculate(patient1)
#   calculator.calculate(patient2)
#   calculator.set_measure_and_population(measure2, 0)
#   calculator.calculate(patient3)
#   calculator.calculate(patient4)

class BonnieBackendCalculator

  def initialize
    # Set up the V8 context and evaluate the basic libraries
    @v8 = V8::Context.new
    @v8.eval HQMF2JS::Generator::JS.map_reduce_utils
    # Don't include crosswalk but do include underscore when loading library functions
    @v8.eval HQMF2JS::Generator::JS.library_functions(false, true)
  end

  # Specify the measure and population to calculate against; can be called multiple times to change
  def set_measure_and_population(measure, population, options = {})
    options.reverse_merge! rationale: false
    begin
      @v8.eval BonnieBackendMeasureJavascript.generate_for_population(measure, population, rationale: options[:rationale])
    rescue
      return false
    end
    return true
  end

  # Calculate a patient against the previously set up measure and population, returning the result
  def calculate(patient)
    result = @v8.eval "calculatePatient(#{patient.to_json(except: :results)})"
    JSON.parse(result)
  end

end
