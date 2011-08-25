%w( rubygems jadof sinatra ).each {|lib| require lib}


get '/' do
  #JADOF::Page.all.map(&:name).join(', ')
  puts "calendar to be put here"
  haml :index
end

enable :inline_templates
__END__

@@ index
"hello janjan"
