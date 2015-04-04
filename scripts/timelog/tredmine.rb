#!/usr/bin/env ruby
require 'shell'
require 'bigdecimal'
require 'json'
require 'net/https'

if ENV.fetch('LEDGER_TIMELOG', '') == ''
  abort('$LEDGER_TIMELOG not set. Set it to the path of the timelog file.')
end

unless ARGV.size >= 2
  puts 'Usage: tredmine api_key date'
  exit
end

api_key, date = ARGV

abort("Invalid date format for #{date}") unless date =~ /\A\d\d\d\d-\d\d-\d\d\z/

ACTIVITIY_IDS = {
  'code'       => 9,  # Development
  'review'     => 20, # Code review
  'merge'      => 14, # Code review
  'adm'        => 14, # Other
  'meeting'    => 14, # Other
  'external'   => 14, # Other
  'operations' => 14  # Other
}

def time_entry(date, issue, activity, subtask, seconds)
  {
    issue_id: issue,
    spent_on: date,
    hours: (seconds / (60 * 60)).round(2).to_s('F'),
    activity_id: activity && ACTIVITIY_IDS.fetch(activity),
    comments: subtask
  }
end

Shell.verbose = false
ledger = Shell.new.transact do |sh|
  sh.system('cut -d " " -f 1-3,5- "$LEDGER_TIMELOG"') |
  sh.system('ledger', '-f', '-', 'equity', '--flat', '-p', date, 'reg', '^i:|^issue:')
end.to_s

entries = ledger.lines.drop(1).map do |line|
  m = line.match(/\(([^)]+)\) *(\d+)s/)
  raise "Line #{line.inspect} failed to parse" unless m
  _, issue, activity, subtask = m[1].split(':')
  seconds = BigDecimal(m[2])

  time_entry(date, issue, activity, subtask, seconds)
end

def post_json(server, path, key, data)
  req = Net::HTTP::Post.new(path)
  req['Content-Type'] = 'application/json'
  req['X-Redmine-API-Key'] = key
  req.body = data.to_json
  res = http_request(server, req)

  raise "Unexpected status #{res.code}, body: #{res.body}" unless res.code =~ /^2/

  puts res.body
end

def http_request(server, req)
  http = Net::HTTP.new(server.host, server.port)
  http.use_ssl = server.scheme == 'https'
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  http.request(req)
end

server = URI('https://project.bonniergaming.com')

entries.each do |entry|
  post_json(server, '/time_entries.json', api_key, time_entry: entry)
end
