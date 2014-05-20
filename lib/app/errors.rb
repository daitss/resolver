
error do
  e = @env['sinatra.error']

  # Passenger phusion complains to STDERR about the dropped body data unless we rewind.

  request.body.rewind if request.body.respond_to?('rewind')  

  Datyl::Logger.err "Internal Service Error - #{e.message}", @env
  puts "in errors.rb #{e.message}, #{e.inspect}"
  e.backtrace.each { |line| Datyl::Logger.err line, @env }
  halt 500, { 'Content-Type' => 'text/plain' }, "Internal Service Error.\n"   # ruby 1.9.3

end

not_found  do
  e = @env['sinatra.error']
  message = "404 Not Found - #{request.url} doesn't exist.\n"
  Datyl::Logger.warn message, @env
  content_type 'text/plain'
  message
end
