#!/usr/bin/env ruby
require "rubygems"
require "thor"
require "date"
require "json"
require "pry"

class Regression < Thor
  desc "save <email>", "Save initial results of <email> to regression-results-<email>"
  def save(email)
    init

    first_half_results = regress(email)

    # Sanitize username/password
    first_half_results.each do |_account, scraper|
      scraper.uid = "NotARealEmail"
      scraper.pass = "NotARealPassword"
    end

    results_json = {}
    first_half_results.each do |account, scraper|
      scraper_json = {}
      scraper_json['passing_coverage'] = scraper.passing_coverage
      scraper_json['coverage'] = scraper.coverage
      results_json[account] = scraper_json
    end

    save_path = "#{Dir.pwd}/regression-results-#{email}"
    puts "Saving results to #{save_path}"
    File.write(save_path, results_json.to_json)
  end

  desc "load <path to results file>", "Load results from provided file and run second half of regression using current database and local bonnie server"
  def load(file_path)
    init

    first_half_results = {}
    file_json = JSON.parse(File.read(file_path))
    email = ""
    file_json.each do |account, scraper_json|
      email = account
      coverage = scraper_json['coverage']
      passing_coverage = scraper_json['passing_coverage']
      first_half_results[account] = BonnieScraper.new(@url, @uid, @pass, account, coverage, passing_coverage)
    end

    second_half_results = regress(email)

    compare(first_half_results, second_half_results)
  end

  desc "setup", "Install needed dependencies (assumes ruby+chrome installed)"
  def setup
    system 'gem install capybara'
    system 'gem install colorize'
    system 'gem install selenium-webdriver'
    system 'brew install --cask chromedriver'
    Capybara.ignore_hidden_elements = false
  end

  no_commands do
    def init
      require "capybara/dsl"
      require "selenium/webdriver"
      require 'colorize'
      BonnieScraper.include Capybara::DSL
      @url = ENV["BONNIE_URL"] || ask("Bonnie URL: ")
      @uid = ENV["BONNIE_USER"] || ask("Bonnie User ID: ")
      @pass = ENV["BONNIE_PASSWORD"] || ask("Bonnie User Password: ", :echo => false)
    end

    def regress(email)
      puts "\nExecuting Regression on #{@url}"
      results = {}
      email = email.to_s
      puts "Testing #{email}".colorize(:cyan)
      local = BonnieScraper.new(@url, @uid, @pass, email)
      local.scrape!
      results[email] = local
      results
    end

    def compare(before, after)
      before.each_pair do |acc, r|
        puts acc.colorize(:cyan)
        r.compare!(after[acc])
      end
    end
  end
end

class BonnieScraper

  attr_reader :session, :host, :account, :errors, :passing_coverage, :coverage
  attr_accessor :uid, :pass

  def initialize(host, uid, pass, account, coverage = {}, passing_coverage = {})
    @host = host
    @uid = uid
    @pass = pass
    @account = account
    @errors = []
    @passing_coverage = passing_coverage
    @coverage = coverage
    Capybara.register_driver :selenium do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.read_timeout = 300
      client.open_timeout = 300
      Capybara::Selenium::Driver.new(
        app,
        browser: :chrome,
        options: options,
        http_client: client
      )
    end
    Capybara.default_driver = :selenium
    Capybara.run_server = false
    Capybara.default_max_wait_time = 20
  end

  def scrape!
    login
    dashboard
    admin
    measures
  end

  def new_session
    @session = Capybara::Session.new(:selenium)
  end

  def login
    new_session
    visit host
    click_link("login")
    fill_in 'user_email', with: @uid
    fill_in 'user_password', with: @pass
    click_button "Login"
  end

  def dashboard
    sleep 1
    click_button("Close") if has_css?("div.modal-footer")
    sleep(1)
    find("li.nav-admin a").click
  end

  def admin
    find(:xpath, "//tr[td[text()='#{account.downcase}']]").find("button.btn-danger").click
  end

  def handle_errors
    sleep(1)
    error_dialog = all('div#errorDialog').last
    return unless error_dialog
    errors << error_dialog.find("div.modal-body h4").text
    error_dialog.find("div#errorDialog button").click
    sleep(1)
    handle_errors
  end

  def measures
    handle_errors
    key_index = 0

    all("div.dashboard-data div.measure", wait: 0).each do |m|
      key = m.find("span.cms-id").text
      key = key.gsub("CMS ID:\n", "") # Clean up title
      begin
        value_node = m.first("span.patient-listing")
      rescue StandardError
        value_node = nil
      end
      value = value_node ? value_node.text : nil
      # Allow for duplicate keys by adding an index:
      if passing_coverage[key]
        key = key + "-" + key_index.to_s
        key_index += 1
      end
      passing_coverage[key] = value

      # Loop over any populations within this measure.
      m.find_all('div.population', wait: 0).each do |p|
        key = p.find("div.population-title").text
        key = key.gsub("EDIT THIS POPULATION TITLE", "") # Clean up title

        value_node = nil
        begin
          value_node = p.first("span.patient-listing")
        rescue StandardError
          value_node = nil
        end
        value = value_node ? value_node.text : nil
        # Allow for duplicate keys by adding an index:
        if passing_coverage[key]
          key = key + "-" + key_index.to_s
          key_index += 1
        end
        passing_coverage[key] = value
      end

      # Loop over any component measures within this measure.
      m.find_all('div.component-measure', wait: 0).each do |c|
        key = c.find("div.component-measure-title").text

        begin
          value_node = c.first("span.patient-listing")
        rescue StandardError
          value_node = nil
        end
        value = value_node ? value_node.text : nil
        # Allow for duplicate keys by adding an index:
        if passing_coverage[key]
          key = key + "-" + key_index.to_s
          key_index += 1
        end
        passing_coverage[key] = value
      end
    end

    # for Bonnie v3.2 (production)
    @coverage =
      if !evaluate_script(%[ bonnie.measures.at(0).get('cms_id') ]).nil?
        evaluate_script(%[ bonnie.measures.map(function(measure) { return { cms_id: measure.get('cms_id'), population_sets: measure.get('populations').map(function(population) { var toReturn = {}; _.each(_.pairs(population.coverage().rationaleCriteria), function(library) { toReturn[library[0]] = []; _.each(library[1], function(clause, localId) { toReturn[library[0]].push(clause.statementName + "_" + localId); }); }); return toReturn; }) }; });])
      else
        # for Bonnie v4.0 (cqm-integration)
        evaluate_script(%[bonnie.measures.map(function(measure) { return { cms_id: measure.get('cqmMeasure').cms_id, population_sets: measure.get('populations').map(function(population) { var toReturn = {}; _.each(_.pairs(population.coverage().rationaleCriteria), function(library) { toReturn[library[0]] = []; _.each(library[1], function(clause, localId) { toReturn[library[0]].push(clause.statement_name + '_' + localId); }); }); return toReturn; }) }; });])
      end

    click_link("Logout")
  end

  def compare!(prod)
    new_errors = prod.errors - errors
    puts "REGRESSION: Additional errors found on production #{new_errors.join}".colorize(:red) unless new_errors.empty?
    pass = 0
    total = 0
    puts "====Patients Passing Regression===========\n"
    passing_coverage.each_pair do |m, v|
      total += 1
      v2 = prod.passing_coverage[m]
      if v.to_i > v2.to_i
        puts "-: #{m} FIRST BRANCH HAS MORE PASSES (#{v} > #{v2})".colorize(:red)
      elsif v2.to_i > v.to_i
        puts "+: #{m} SECOND BRANCH HAS MORE PASSES (#{v} < #{v2})".colorize(:green)
      else
        puts "=: #{m} RESULTS ARE EQUAL (#{v2} == #{v})"
        pass += 1
      end
    end
    if pass == total
      puts "Measures with no differences: #{pass}/#{total}\n".colorize(:green)
    else
      puts "Measures with no differences: #{pass}/#{total}\n".colorize(:red)
    end
    puts "====Code Coverage Percentage Regression===========\n"
    pass = 0
    total = 0
    new_coverage = {}
    dropped_coverage = {}

    coverage.each_with_index do |measure, measure_index|
      cms_id = measure['cms_id']
      measure['population_sets'].each_with_index do |pop, pop_index|
        pop.each_pair do |library_name, clause_results|
          total += clause_results.length
          clause_results.each do |clause|
            if prod.coverage[measure_index].nil? ||
               prod.coverage[measure_index]['population_sets'][pop_index].nil? ||
               prod.coverage[measure_index]['population_sets'][pop_index][library_name].nil? ||
               !prod.coverage[measure_index]['population_sets'][pop_index][library_name].include?(clause)
              add_coverage_info_to_results(dropped_coverage, cms_id, pop_index, library_name, clause)
            else
              pass += 1
            end
          end

          next if prod.coverage[measure_index].nil? ||
                  prod.coverage[measure_index]['population_sets'][pop_index].nil? ||
                  prod.coverage[measure_index]['population_sets'][pop_index][library_name].nil?

          prod.coverage[measure_index]['population_sets'][pop_index][library_name].each do |clause|
            if coverage[measure_index]['population_sets'][pop_index].nil? ||
               !coverage[measure_index]['population_sets'][pop_index][library_name].include?(clause)
              add_coverage_info_to_results(new_coverage, cms_id, pop_index, library_name, clause)
              total += 1
            else
              total += 1
              pass += 1
            end
          end
        end
      end
    end

    unless new_coverage.empty?
      puts "Uncovered clauses now covered:".colorize(:green)
      new_coverage.each_pair do |cms_id_and_pop, libraries|
        puts cms_id_and_pop
        libraries.each_pair do |library_name, clauses|
          puts "Library: #{library_name}".colorize(:green)
          clauses.each do |clause|
            puts "Clause: #{clause}".colorize(:green)
          end
        end
      end
    end

    unless dropped_coverage.empty?
      puts "Covered clauses now uncovered:".colorize(:red)
      dropped_coverage.each_pair do |cms_id_and_pop, libraries|
        puts cms_id_and_pop
        libraries.each_pair do |library_name, clauses|
          puts "Library: #{library_name}".colorize(:red)
          clauses.each do |clause|
            puts "Clause: #{clause}".colorize(:red)
          end
        end
      end
    end

    if pass == total
      puts "Clauses with no differences: #{pass}/#{total}".colorize(:green)
    else
      puts "Clauses with no differences: #{pass}/#{total}".colorize(:red)
    end
  end
end

def add_coverage_info_to_results(coverage_results, cms_id, population_index, library_name, clause)
  cms_and_pop = "#{cms_id}: Population #{population_index}"
  coverage_results[cms_and_pop] = {} unless coverage_results[cms_and_pop]
  coverage_results[cms_and_pop][library_name] = [] unless coverage_results[cms_and_pop][library_name]
  coverage_results[cms_and_pop][library_name].push clause
end

def wait_for_input(input_character)
  while (user_input = STDIN.gets.chomp)
    case user_input
    when input_character
      break
    end
  end
end

Regression.start(ARGV)
