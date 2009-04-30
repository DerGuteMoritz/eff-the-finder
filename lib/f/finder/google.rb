class F::Finder::Google < F::Finder

  base_uri 'http://www.google.com'

  def run
    doc('/search', :q => @term).search('h3.r a.l').map do |a|
      a.text
    end
  end

end
