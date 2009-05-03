F::Finder.define :youtube do
  
  description 'YouTube video search'
  base_uri 'http://www.youtube.com'
  find { |http, o| http.get '/results', :search_query => o[:terms] }
  default_command :v
  
  command :v, 'view with FLV_PLAYER', 0 => :result_page_for_index do |page|
    player = env('FLV_PLAYER')
    
    if page.body =~ /swfArgs.*"video_id"\s*:\s*"(.*?)".*"t"\s*:\s*"(.*?)".*/
      system(player, "http://www.youtube.com/get_video?video_id=#{$1}&t=#{$2}")
    end
  end

  # ridiculous work-around for youtube's stupid language auto-detection
  http.pre_connect_hooks << lambda do |o|
    o[:request].path << '&hl=en'
  end

  parse do |page, result|
    result.header << page.at('#search-section-header').text.gsub(/.*results/, '').strip
    result.previous_url = page.css('a.pagerNotCurrent:contains("Previous")')
    result.next_url = page.css('a.pagerNotCurrent:contains("Next")')
    result.items = page.css('.video-title-results .video-long-title a')
  end

end
