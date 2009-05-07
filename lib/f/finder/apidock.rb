F::Finder.define :apidock do
  description 'APIdock search'
  base_uri 'http://apidock.com/'
  find { |http, o| http.get '/rails/search', :query => o[:terms], :hl => 'en' }

  parse do |page, result|
    require 'pp'
    puts "[#{page.css('#docs_container #main_body h2').public_methods.pretty_inspect}]"
    
    result.header = page.css('#docs_container #main_body h2').inner_html
    result.previous_url = page.css('#main_body div.pagination a.prev_page')
    result.next_url = page.css('#main_body div.pagination a.next_page')
    result.items = page.css('#main_body .result .result_title h3 a')
  end
end
