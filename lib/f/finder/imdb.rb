F::Finder.define :imdb do
  description 'IMDB movie title search'
  base_uri 'http://www.imdb.com/'
  find { |http, o| http.get '/find', :q => o[:terms], :s => 'tt' }

  parse do |page, result|
    page.css('td > a[href^="/title/"]').each do |a|
      next if a.text.blank?
      result << [a.parent.text.squeeze, a['href']]
    end
  end

end
