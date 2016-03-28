module InlineSvg
  module ActionView
    module Helpers
      def inline_svg(filename, transform_params={})
        begin
	  if filename.is_a?(IO)
	    svg_file = filename.read
	    filename.close
	  else
	    svg_file = AssetFile.named(filename)
	  end
        rescue InlineSvg::AssetFile::FileNotFound
          return "<svg><!-- SVG file not found: '#{filename}' --></svg>".html_safe
        end

        InlineSvg::TransformPipeline.generate_html_from(svg_file, transform_params).html_safe
      end
    end
  end
end
