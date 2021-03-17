# frozen_string_literal: true

# String input with template styling
class TextInput < Formtastic::Inputs::TextInput
  def to_html
    input_wrapping do
      label_html << builder.text_area(method, input_html_options)
    end
  end

  def hint_html
    return nil if hint_text.blank?

    template.content_tag(
      :small,
      hint_text,
      class: 'form-text text-muted'
    )
  end

  def error_html
    return nil if errors.blank?

    template.content_tag(
      :div,
      errors.join('<br/>').html_safe,
      class: 'invalid-feedback'
    )
  end

  def input_html_options
    new_class = [super[:class], 'form-control', errors.any? ? 'is-invalid' : nil].compact.join(' ')
    super.merge(class: new_class, rows: options.with_indifferent_access.dig(:input_html, :rows) || 3)
  end

  def line_html
    '<i class="form-group__bar"></i>'
  end

  def input_wrapping(&block)
    template.content_tag(
      :div,
      (
        template.content_tag(
          :div,
          [template.capture(&block), line_html].join("\n").html_safe,
          class: 'position-relative'
        ) <<
        error_html <<
        hint_html
      ).html_safe,
      wrapper_html_options
    )
  end

  def wrapper_html_options
    new_class = [options[:class], super[:class], 'form-group'].compact.join(' ')
    super.merge(class: new_class)
  end
end
