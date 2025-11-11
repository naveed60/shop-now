namespace :active_admin do
  desc "Compile ActiveAdmin SCSS into app/assets/builds/active_admin.css"
  task build_css: :environment do
    require "sassc"

    source = Rails.root.join("app/assets/stylesheets/active_admin.scss")
    destination = Rails.root.join("app/assets/builds/active_admin.css")

    load_paths = [
      Rails.root.join("app/assets/stylesheets"),
      Gem.loaded_specs["activeadmin"].full_gem_path + "/app/assets/stylesheets"
    ]

    css = SassC::Engine.new(
      source.read,
      filename: source.to_s,
      load_paths: load_paths,
      style: :compressed
    ).render

    FileUtils.mkdir_p(destination.dirname)
    File.write(destination, css)
    puts "Built #{destination.relative_path_from(Rails.root)}"
  end
end
