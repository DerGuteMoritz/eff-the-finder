F::Finder.define :piratebay do
  description 'Pirate Bay torrent search'
  base_uri 'http://thepiratebay.org/'
  find { |http, o| http.get "/search/#{o[:terms]}" }

  parse do |doc, result|
    result.header = doc.css('h2').text
    result.previous_url = doc.xpath('//img[@alt="Previous"]/parent::a')
    result.next_url = doc.xpath('//img[@alt="Next"]/parent::a')
    result.items = doc.css('#SearchResults a.detLink')
  end

end
