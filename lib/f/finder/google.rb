F::Finder.define :google do
  description 'Google search'
  base_uri 'http://www.google.com/'
  list { |http, args| http.get '/search', :query => { :q => args.join(' ') } }

  parse do |doc, result|
    result.header = 'Google Search' + doc.css('#ssb p').text
    result.next_url = doc.css('#nav td.b:last a')[0]['href']

    doc.css('h3.r a.l').each do |a|
      result << [a.text, a['href']]
    end
  end

end
