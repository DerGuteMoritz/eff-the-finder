require 'tempfile'

class F::Prompt
  def with_torrent_file_from(url)
    Tempfile.open 'f.piratebay' do |f|
      f.write(http.get(http.get(url).at('.download a')['href']).content)
      f.rewind
      yield(f)
    end
  end
end

F::Finder.define :piratebay do
  description 'Pirate Bay torrent search'
  base_uri 'http://thepiratebay.org/'
  find { |http, o| http.get "/search/#{o[:terms]}" }
  
  command :t, 'download torrent file and open it with BITTORRENT_CLIENT', 0 => :result_for_index do |result|
    torrent = ENV['BITTORRENT_CLIENT']
    raise 'environment variable BITTORRENT_CLIENT is not set or empty' if torrent.blank?
    with_torrent_file_from result.url do |f|
      system("#{torrent} #{f.path}")
    end
  end
  
  command :i, 'torrent info', 0 => :result_for_index do |result|
    puts http.get(result.url).css('.nfo pre').text
  end
  
  parse do |page, result|
    result.header = page.css('h2').text
    result.previous_url = page.xpath('//img[@alt="Previous"]/parent::a')
    result.next_url = page.xpath('//img[@alt="Next"]/parent::a')
    result.items = page.css('#SearchResults a.detLink')
  end

end
