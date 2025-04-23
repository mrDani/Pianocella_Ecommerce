module ApplicationHelper
    def breadcrumb(trail)
      content_tag(:nav, class: "breadcrumb mb-3") do
        trail.map.with_index do |(label, path), index|
          if path.present? && index < trail.length - 1
            link_to(label, path, class: "breadcrumb-item text-decoration-none")
          else
            content_tag(:span, label, class: "breadcrumb-item active", aria: { current: "page" })
          end
        end.join(" > ").html_safe
      end
    end
  end
  