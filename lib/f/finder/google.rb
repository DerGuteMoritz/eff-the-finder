F::Finder.define :google do
  description 'Google search'
  base_uri 'http://www.google.com/'
  find { |http, o| http.get '/search', :query => { :q => o[:terms] } }

  parse do |doc, result|
    result.header = 'Google Search' + doc.css('#ssb p').text
    result.previous_url = doc.css('#nav td.b:first a')
    result.next_url = doc.css('#nav td.b:last a')

    doc.css('h3.r a.l').each do |a|
      result << [a.text, a['href']]
    end
  end

end
