## Clear the screen before every task
clearing :on

guard :minitest, spring: true, all_on_start: false do
  # with Minitest::Unit
  watch(%r{^test/(.*)\/?test_(.*)\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }

  # Rails 4
  watch(%r{^app/(.+)\.rb$})                               { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/application_controller\.rb$}) { 'test/controllers' }
  watch(%r{^app/controllers/(.+)_controller\.rb$})        { |m| "test/integration/#{m[1]}_test.rb" }
  watch(%r{^app/views/(.+)_mailer/.+})                    { |m| "test/mailers/#{m[1]}_mailer_test.rb" }
  watch(%r{^lib/(.+)\.rb$})                               { |m| "test/lib/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^test/test_helper\.rb$})                       { 'test' }
  
  #my custom
  watch(%r{^app/controllers})               {"test/integration"}
  watch(%r{^app/helpers})                   {"test/integration"}
  watch(%r{^app/views})                     {"test/integration"}
  watch(%r{^app/helpers/(.+)_helper\.rb$})  {|m| "test/helpers/#{m[1]}_test"}
  watch(%r{^config/routes.rb})              {'test'}
  
end
