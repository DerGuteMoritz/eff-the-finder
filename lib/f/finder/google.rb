class F::Finder::Google < F::Finder

  base_uri 'http://www.google.com/'

  def description
    'Google search.'
  end

  def find
    result_for '/search', :q => @term do |doc, result|

      result.header = 'Google Search' + doc.css('#ssb p').text

      doc.css('h3.r a.l').each do |a|
        result << [a.text, a['href']]
      end
    end
  end

end
