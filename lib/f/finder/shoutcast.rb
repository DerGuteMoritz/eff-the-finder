F::Finder.define :shoutcast do
  
  description 'Shoutcast station search'
  base_uri 'http://www.shoutcast.com/'
  find { |http, o| http.get '/directory/search_results.jsp', :searchCrit => 'simple', :s => o[:terms] }
  default_command :t
  
  command :t, 'tune in with SHOUTCAST_PLAYER', 0 => :result_for_index do |result|
    player = env('SHOUTCAST_PLAYER')
    system("#{player} #{result.url}")
  end

  parse do |page, result|
    result.header << page.css('.paginationSelected').text
    
    nav = %w[Prev Next].map do |x|
      a = page.at(".paginationCntexpand a .bright#{x}").try(:parent)
      a && a['href'][/javascript:getSearchByKeywordList\('([^']+)/, 1]
    end
    
    result.previous_url = nav[0]
    result.next_url = nav[1]

    page.css('.dirMoreStDivexpand').each do |station|
      station_id = station.at('a')['onclick'].to_s[/holdStationID\('(\d+)'\)/, 1]
      result << [station.at('.dirStationCntDivexpand').text.strip.gsub(/Station:\s*/, ''), "http://yp.shoutcast.com/sbin/tunein-station.pls?id=#{station_id}"]
    end
  end

end
