Redmine::Plugin.register :plantuml do
  name 'PlantUML plugin for Redmine'
  author 'Michael Skrynski'
  description 'This is a plugin for Redmine which renders PlantUML diagrams.'
  version '0.3.0'
  url 'https://github.com/dkd/plantuml'

  requires_redmine version: '2.6'..'3.1'
  require_dependency "plantuml/patches/inline_svg"
  require_dependency 'stylesize_transform'

  settings(partial: 'settings/plantuml',
           default: { 'plantuml_binary' => {}, 'cache_seconds' => '0' })

  InlineSvg.configure do |config|
    config.add_custom_transformation(attribute: :style_size, transform: StyleSizeTransform)
  end

  Redmine::WikiFormatting::Macros.register do
    desc <<EOF
      Render PlantUML image.
      <pre>
      {{plantuml(png)
      (Bob -> Alice : hello)
      }}
      </pre>

      Available options are:
      ** (png|svg|inline_svg)
EOF
    macro :plantuml do |obj, args, text|
      raise 'No PlantUML binary set.' if Setting.plugin_plantuml['plantuml_binary_default'].blank?
      raise 'No or bad arguments.' if args.size != 1
      frmt = PlantumlHelper.check_format(args.first)
      image = PlantumlHelper.plantuml(text, args.first)

      return inline_svg(File.open(PlantumlHelper.plantuml_file(image, frmt[:ext]), "rb"), style_size: '100%', preserve_aspect_ratio: 'xMaxYMax meet') if frmt[:type] == 'svg' and frmt[:inline]

      image_tag "/plantuml/#{frmt[:type]}/#{image}#{frmt[:ext]}"
    end
  end
end

Rails.configuration.to_prepare do
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks

  unless Redmine::WikiFormatting::Textile::Helper.included_modules.include? PlantumlHelperPatch
    Redmine::WikiFormatting::Textile::Helper.send(:include, PlantumlHelperPatch)
    require_dependency 'plantuml/hooks/views_layouts_hook'
  end
end
