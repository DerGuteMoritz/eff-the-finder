class F::Finder::Google < F::Finder

  base_uri 'http://www.google.com'

  def description
    'Google search.'
  end

  def find
    result_for '/search', :q => @term do |doc, result|
      doc.css('h3.r a.l').map do |a|
        result << [a.text, a['href']]
      end
    end
  end

end
