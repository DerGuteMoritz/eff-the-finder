F::Finder.define :google do
  description 'Google search'
  base_uri 'http://www.google.com/'
  find { |http, o| http.get '/search', :query => { :q => o[:terms] } }

  parse do |doc, result|
    result.header = 'Google Search' + doc.css('#ssb p').text
    result.previous_url = doc.css('#nav td.b:first a')
    result.next_url = doc.css('#nav td.b:last a')
    result.items = doc.css('h3.r a.l')
  end

end
