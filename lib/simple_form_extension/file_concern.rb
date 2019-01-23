module SimpleFormExtension
  module FileConcern
    def existing_file_tag
      return '' unless file_exists?

      content_tag(:div, class: 'input-group help-block existing-file', data: { provides: 'existing-file'}) do
        content_tag(:span, class: 'input-group-addon') do
          "#{ _translate('file.existing_file') } : ".html_safe
        end +

        file_preview_and_remove_button
      end
    end

    def file_preview_and_remove_button
      content_tag(:div, class: 'btn-group') do
        content_tag(:a, class: 'btn btn-default ', href: file_url, target: '_blank', data: { toggle: 'existing-file' }) do
          content_tag(:i, '', class: 'fa fa-file') +
          "&nbsp;".html_safe +

          existing_file_name
        end +

        remove_file_button
      end
    end

    def existing_file_name
      if object.try(:"#{ attribute_name }?")
        object.send(:"#{ attribute_name }_file_name").html_safe
      elsif (attachment = object.try(attribute_name)).try(:attached?)
        attachment.filename.to_s
      end
    end

    def remove_file_button
      return unless object.respond_to?(:"#{ remove_attachment_method }=")

      content_tag(:button, class: 'btn btn-default', type: 'button', data: { dismiss: 'existing-file' }) do
        content_tag(:i, '', class: 'fa fa-remove', data: { :'removed-class' => 'fa fa-refresh' }) +
        @builder.hidden_field(remove_attachment_method, class: 'remove-file-input', value: nil)
      end
    end

    def remove_attachment_method
      options[:remove_method] || :"remove_#{ attribute_name }"
    end

    def file_exists?
      @file_exists ||= object.try(:"#{ attribute_name }?") ||
                       object.try(attribute_name).try(:attached?)
    end

    def file_url
      if object.try(:"#{ attribute_name }?")
        object.send(attribute_name)
      elsif object.try(attribute_name).try(:attached?)
        object.try(attribute_name).try(:service_url)
      end
    end
  end
end
