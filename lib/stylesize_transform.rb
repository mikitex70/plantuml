class StyleSizeTransform < InlineSvg::CustomTransformation
    def transform(doc)
      doc = Nokogiri::XML::Document.parse(doc.to_html)
      svg = doc.at_css 'svg'
      width = width_of(self.value)
      height = height_of(self.value)
      svg['style'] = svg['style'].gsub('width', 'max-width').gsub('height','max-height')
      svg['style'] = svg['style']+"width:#{width};height:#{height}"
      doc
    end

    def width_of(value)
      value.split(/\*/).map(&:strip)[0]
    end

    def height_of(value)
      value.split(/\*/).map(&:strip)[1] || width_of(value)
    end
end
