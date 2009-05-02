require 'tempfile'

F::Finder.define :piratebay do
  description 'Pirate Bay torrent search'
  base_uri 'http://thepiratebay.org/'
  find { |http, o| http.get "/search/#{o[:terms]}" }
  
  command :t, 'download torrent file and open it with BITTORRENT_CLIENT', 0 => :result_for_index do |result|
    torrent = env('BITTORRENT_CLIENT')

    Tempfile.open 'f.piratebay' do |f|
      f.write(http.get(http.get(result.url).at('.download a')['href']).content)
      f.rewind
      system("#{torrent} #{f.path}")
    end
  end
  
  command :i, 'torrent info', 0 => :result_page_for_index do |page|
    puts page.at('.nfo pre').text
  end
  
  parse do |page, result|
    result.header = page.css('h2').text
    result.previous_url = page.xpath('//img[@alt="Previous"]/parent::a')
    result.next_url = page.xpath('//img[@alt="Next"]/parent::a')
    result.items = page.css('#SearchResults a.detLink')
  end

end
