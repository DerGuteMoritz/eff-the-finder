class F::Finder::Google < F::Finder

  base_uri 'http://www.google.com'

  def description
    'Google search.'
  end

  def find
    doc('/search', :q => @term).css('h3.r a.l').map do |a|
       result a.text, a['href']
    end
  end

end
