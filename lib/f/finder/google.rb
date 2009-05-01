F::Finder.define :google do
  description 'Google search'
  base_uri 'http://www.google.com/'
  find { |http, args| http.get '/search', :query => { :q => args.join(' ') } }

  parse do |doc, result|
    result.header = 'Google Search' + doc.css('#ssb p').text

    unless (next_url = doc.css('#nav td.b:last a')).empty?
      result.next_url = next_url[0]['href']
    end

    doc.css('h3.r a.l').each do |a|
      result << [a.text, a['href']]
    end
  end

end
